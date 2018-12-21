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
            case sound(value: Value)
            case set(variable: Character, value: Value)
            case add(variable: Character, value: Value)
            case multiply(variable: Character, value: Value)
            case modulo(variable: Character, value: Value)
            case recovers(variable: Character)
            case jumps(test: Value, value: Value)
            
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
                    guard let value = RawValue.from(string: components[1]) else { return nil }
                    return .sound(value: value)
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
                    guard let test = RawValue.from(string: components[1]) else { return nil }
                    return .jumps(test: test, value: value)
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
        
        enum Action {
            case stopping, none
        }
        
        enum State {
            case stopped, waiting, running
        }
        
        var state = State.stopped
        var current = 0
        func execute(snd: (Int) -> Action, rcv: (Character) -> Action) {
            if current >= instructions.count || current < 0 {
                state = .stopped
            }
            state = .running
            while current < instructions.count {
                let instruction = instructions[current]
                switch instruction {
                case .sound(value: let value):
                    let action = snd(value.realValue(with: registry))
                    if action == .stopping {
                        return
                    }
                case .recovers(variable: let variable):
                    let action = rcv(variable)
                    if action == .stopping {
                        return
                    }
                case .jumps(test: let test, value: let jumpValue):
                    if test.realValue(with: registry) > 0 {
                        current += jumpValue.realValue(with: registry)
                        continue
                    }
                default:
                    instruction.perform(on: &registry)
                }
                current += 1
            }
            state = .stopped
        }
        
        func soundRecovered() -> Int {
            var lastSoundPlayed = 0
            
            execute(snd: { (value) -> Action in
                lastSoundPlayed = value
                return .none
            }, rcv: { (variable) -> Action in
                return (registry[variable] ?? 0) != 0 ? .stopping : .none
            })
            
            return lastSoundPlayed
        }
        
        var received = [Int]()
        var sendedCount = 0
        
        func execute(with another: Program, firstRun: Bool = true) {
            if firstRun {
                another.state = .running
            }
            execute(snd: { (value) -> Day18.Program.Action in
                another.received.append(value)
                sendedCount += 1
                if another.state == .waiting {
                    another.state = .running
                }
                return .none
            }, rcv: { (variable) -> Day18.Program.Action in
                if received.isEmpty {
                    if another.state != .running {
                        state = .stopped
                        return .stopping
                    }
                    state = .waiting
                    another.execute(with: self, firstRun: false)
                    return .stopping
                }
                let value = received.removeFirst()
                registry[variable] = value
                return .none
            })
        }
    }
    
    static func run(input: String) {
        
        let example = "set a 1\nadd a 2\nmul a a\nmod a 5\nsnd a\nset a 0\nrcv a\njgz a -1\nset a 1\njgz a -2"
        assert(Program.from(input: example).soundRecovered() == 4)
        print("Last sound recovered for 18-1 is \(Program.from(input: input).soundRecovered())")
        
        let example2 = "snd 1\nsnd 2\nsnd p\nrcv a\nrcv b\nrcv c\nrcv d"
        assert({ () -> Bool in
            let p0 = Program.from(input: example2, pid: 0)
            let p1 = Program.from(input: example2, pid: 1)
            
            p0.execute(with: p1)
            return p1.sendedCount == 3
        }())
        
        
        let p0 = Program.from(input: input, pid: 0)
        let p1 = Program.from(input: input, pid: 1)
        
        p0.execute(with: p1)
        print("Number of data sent by p1 for 18-2 is \(p1.sendedCount)")
    }
}
