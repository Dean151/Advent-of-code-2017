//
//  Day18.swift
//  AdventOfCode2017
//
//  Created by Thomas DURAND on 21/12/2018.
//  Copyright © 2018 Thomas DURAND. All rights reserved.
//

import Foundation

protocol Value {
    func realValue(with registry: [Character: Int]) -> Int
}

extension Value {
    static func from(string: String) -> Value? {
        if let integer = Int(string) {
            return RawValue(value: integer)
        }
        
        if let character = string.first {
            return CodedValue(variable: character)
        }
        
        return nil
    }
}

struct RawValue: Value {
    let value: Int
    
    func realValue(with registry: [Character: Int]) -> Int {
        return value
    }
}

struct CodedValue: Value {
    let variable: Character
    
    func realValue(with registry: [Character: Int]) -> Int {
        return registry[variable] ?? 0
    }
}

class Day18: Day {
    
    class Program {
        
        let pid: Int
        let instructions: [Instruction]
        
        var registry: [Character: Int]
        
        enum Instruction {
            case sound(variable: Character)
            case set(variable: Character, value: Value)
            case add(variable: Character, value: Value)
            case multiply(variable: Character, value: Value)
            case modulo(variable: Character, value: Value)
            case recovers(variable: Character)
            case jumps(variable: Character, value: Value)
            
            func perform(on registry: inout [Character: Int]) {
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
                let variable = components[1].first!
                
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
        
        init(pid: Int, instructions: [Instruction]) {
            self.pid = pid
            self.instructions = instructions
            registry = ["p": pid]
        }
        
        static func from(input: String, pid: Int = 0) -> Program {
            let instructions = input.components(separatedBy: .newlines).compactMap({ Instruction.from(string: $0) })
            return Program(pid: pid, instructions: instructions)
        }
        
        var current = 0
        
        @discardableResult
        func execute(snd: (Character) -> Bool, rcv: (Character) -> Bool) -> Bool {
            while current < instructions.count {
                let instruction = instructions[current]
                switch instruction {
                case .sound(variable: let variable):
                    if !snd(variable) {
                        return false
                    }
                case .recovers(variable: let variable):
                    if !rcv(variable) {
                        return false
                    }
                case .jumps(variable: let variable, value: let jumpValue):
                    if let value = registry[variable], value > 0 {
                        current += jumpValue.realValue(with: registry) - 1
                    }
                default:
                    instruction.perform(on: &registry)
                }
                current += 1
            }
            return true
        }
        
        func soundRecovered() -> Int {
            var lastSoundPlayed = 0
            
            execute(snd: { (variable) -> Bool in
                lastSoundPlayed = registry[variable] ?? 0
                return true
            }, rcv: { (variable) -> Bool in
                return registry[variable] != 0 ? false : true
            })
            
            return lastSoundPlayed
        }
        
        var isKilled = false
        var waiting = false
        var sendedCount = 0
        
        var queue: DispatchQueue?
        private var received = [Int]()
        func received(value: Int) {
            queue!.sync {
                received.append(value)
            }
        }
        var unqueueReceived: Int? {
            return queue!.sync {
                if received.count == 0 {
                    return nil
                }
                return received.removeFirst()
            }
        }
        var pending: Int {
            return queue!.sync {
                return received.count
            }
        }
        var isWaiting: Bool {
            return queue!.sync {
                return waiting
            }
        }
        
        func execute(with another: Program) {
            while !isKilled {
                if execute(snd: { (variable) -> Bool in
                    print("pid \(pid) send \(registry[variable] ?? 0)")
                    another.received(value: registry[variable] ?? 0)
                    sendedCount += 1
                    return true
                }, rcv: { (variable) -> Bool in
                    if let value = unqueueReceived {
                        print("pid \(pid) received \(value) (\(pending) left)")
                        registry[variable] = value
                        return true
                    } else if another.isWaiting {
                        print("DEADLOCK")
                        isKilled = true
                        another.isKilled = true
                        return false
                    } else {
                        print("pid \(pid) waits for a value")
                        waiting = true
                        return false
                    }
                }) {
                    isKilled = true
                }
            }
        }
    }
    
    static func competion(between p0: Program, and p1: Program) -> Int {
        
        let communicationQueue = DispatchQueue(label: "safe communication queue")
        p0.queue = communicationQueue
        p1.queue = communicationQueue
        
        DispatchQueue.global(qos: .userInitiated).async {
            p0.execute(with: p1)
        }
        
        // p1 on main thread. Once p1 is gone ; it cannot send anymore data
        p1.execute(with: p0)
        
        return p1.sendedCount
    }
    
    static func run(input: String) {
        
        let example = "set a 1\nadd a 2\nmul a a\nmod a 5\nsnd a\nset a 0\nrcv a\njgz a -1\nset a 1\njgz a -2"
        assert(Program.from(input: example).soundRecovered() == 4)
        print("Last sound recovered for 18-1 is \(Program.from(input: input).soundRecovered())")
        
        let example2 = "snd 1\nsnd 2\nsnd p\nrcv a\nrcv b\nrcv c\nrcv d"
        assert({ () -> Bool in
            let p0 = Program.from(input: example2, pid: 0)
            let p1 = Program.from(input: example2, pid: 1)
            let nb = competion(between: p0, and: p1)
            
            return nb == 3
        }())
        
        
        let p0 = Program.from(input: input, pid: 0)
        let p1 = Program.from(input: input, pid: 1)
        
        let nb = competion(between: p0, and: p1)
        print("Number of data sent by p1 for 18-2 is \(nb)")
    }
}
