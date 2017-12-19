//: Playground - noun: a place where people can play

import Foundation
import XCPlayground

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

let url = Bundle.main.url(forResource: "input", withExtension: "txt")!
let input = try! String(contentsOf: url)

protocol Value {
    func realValue(with registry: [String: Int]) -> Int
}

extension Value {
    static func from(string: String) -> Value? {
        if let integer = Int(string) {
            return RawValue(value: integer)
        }
        if string.count == 1 {
            return CodedValue(variable: string)
        }
        return nil
    }
}

struct RawValue: Value {
    let value: Int
    
    func realValue(with registry: [String: Int]) -> Int {
        return value
    }
}

struct CodedValue: Value {
    let variable: String
    
    func realValue(with registry: [String: Int]) -> Int {
        return registry[variable] ?? 0
    }
}

enum Instruction {
    case sound(variable: String)
    case set(variable: String, value: Value)
    case add(variable: String, value: Value)
    case multiply(variable: String, value: Value)
    case modulo(variable: String, value: Value)
    case recovers(variable: String)
    case jumps(variable: String, value: Value)
    
    func perform(on registry: inout [String: Int]) {
        switch self {
        case .sound, .recovers, .jumps:
            // Case treated without this function
            break
        case .set(variable: let variable, value: let value):
            registry.updateValue(value.realValue(with: registry), forKey: variable)
        case .add(variable: let variable, value: let value):
            let oldValue = registry[variable] ?? 0
            registry.updateValue(oldValue + value.realValue(with: registry), forKey: variable)
        case .multiply(variable: let variable, value: let value):
            let oldValue = registry[variable] ?? 0
            registry.updateValue(oldValue * value.realValue(with: registry), forKey: variable)
        case .modulo(variable: let variable, value: let value):
            let oldValue = registry[variable] ?? 0
            registry.updateValue(oldValue % value.realValue(with: registry), forKey: variable)
        }
    }
    
    static func from(string: String) -> Instruction? {
        let components = string.components(separatedBy: .whitespaces)
        guard let type = components.first, components.count >= 2 else { return nil }
        let variable = components[1]
        
        switch type {
        case "snd":
            return .sound(variable: variable)
        case "rcv":
            return .recovers(variable: variable)
        default:
            break
        }
        
        // We need a value
        guard components.count == 3 else { return nil }
        // From can be called either on RawValue or CodedValue. It'll be the same
        guard let value = RawValue.from(string: components[2]) else { return nil }
        
        switch type {
        case "set":
            return .set(variable: variable, value: value)
        case "add":
            return .add(variable: variable, value: value)
        case "mul":
            return .multiply(variable: variable, value: value)
        case "mod":
            return .modulo(variable: variable, value: value)
        case "jgz":
            return .jumps(variable: variable, value: value)
        default:
            return nil
        }
    }
}

func instructions(for input: String) -> [Instruction] {
    return input.components(separatedBy: .newlines).flatMap({ Instruction.from(string: $0) })
}

func frequencyAtLastRecovery(for instructions: [Instruction]) -> Int? {
    var registry = [String: Int]()
    var index = 0
    var lastSoundPlayed = 0
    
    while index < instructions.count {
        
        let instruction = instructions[index]
        
        switch instruction {
        case .sound(variable: let variable):
            lastSoundPlayed = registry[variable] ?? 0
        case .recovers(variable: let variable):
            if let value = registry[variable], value != 0 {
                return lastSoundPlayed
            }
        case .jumps(variable: let variable, value: let jumpValue):
            if let value = registry[variable], value > 0 {
                index += jumpValue.realValue(with: registry) - 1
            }
        default:
            instruction.perform(on: &registry)
        }
        
        index += 1
    }
    
    return nil
}

let example = """
set a 1
add a 2
mul a a
mod a 5
snd a
set a 0
rcv a
jgz a -1
set a 1
jgz a -2
"""
let exampleInstructions = instructions(for: example)
assert(frequencyAtLastRecovery(for: exampleInstructions) == 4)

//print("Last sound recovered for 18-1: \(frequencyAtLastRecovery(for: instructions(for: input)))")

class Program {
    let pid: Int
    let instructions: [Instruction]
    var registry: [String: Int]
    
    var retreiveQueue: [Int] = []
    var communicateWith: Program?
    var isLocked = false
    var timesSended = 0
    
    var index = 0
    
    init(pid: Int, instructions: [Instruction]) {
        self.pid = pid
        self.instructions = instructions
        registry = ["p": pid]
    }
    
    func resume(queue: DispatchQueue) {
        self.isLocked = false
        queue.async {
            print("Resuming \(self.pid)")
            while self.index < self.instructions.count {
                let instruction = self.instructions[self.index]
                
                switch instruction {
                case .sound(variable: let variable):
                    // It's send
                    self.timesSended += 1
                    self.communicateWith?.retreiveQueue.insert(self.registry[variable] ?? 0, at: 0)
                    if self.communicateWith?.isLocked == true {
                        self.communicateWith?.resume(queue: queue)
                    }
                case .recovers(variable: let variable):
                    // It's receive
                    if let value = self.retreiveQueue.popLast() {
                        self.registry.updateValue(value, forKey: variable)
                    }
                    else if self.communicateWith?.isLocked == true {
                        // deadlock
                        if self.pid == 1 {
                            print("Finished with \(self.timesSended)")
                        } else if self.communicateWith?.pid == 1 {
                            print("Finished with \(self.communicateWith?.timesSended ?? 0)")
                        }
                        print("Deadlock with \(self.pid)")
                        return
                    }
                    else {
                        self.isLocked = true
                        print("Stopping \(self.pid)")
                        return
                    }
                case .jumps(variable: let variable, value: let jumpValue):
                    if let value = self.registry[variable], value > 0 {
                        self.index += jumpValue.realValue(with: self.registry) - 1
                    }
                default:
                    instruction.perform(on: &self.registry)
                }
                
                self.index += 1
            }
        }
    }
}

func perform(for input: String) {
    // Set everything up
    let inputInstructions = instructions(for: input)
    let p0 = Program(pid: 0, instructions: inputInstructions)
    let p1 = Program(pid: 1, instructions: inputInstructions)
    
    p0.communicateWith = p1
    p1.communicateWith = p0
    
    let queue = DispatchQueue(label: "queue")
    p0.resume(queue: queue)
    p1.resume(queue: queue)
}

// Example
let example2 = """
snd 1
snd 2
snd p
rcv a
rcv b
rcv c
rcv d
"""
perform(for: example2)

perform(for: input)
