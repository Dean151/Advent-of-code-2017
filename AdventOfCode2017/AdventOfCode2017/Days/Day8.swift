//
//  Day8.swift
//  AdventOfCode2017
//
//  Created by Thomas DURAND on 19/12/2018.
//  Copyright © 2018 Thomas DURAND. All rights reserved.
//

import Foundation

class Day8: Day {
    
    struct Register {
        
        enum Operation {
            case increase(String, Int)
            case decrease(String, Int)
            
            func perform(on register: inout Register) {
                switch self {
                case .increase(let variable, let amount):
                    let oldValue = register.get(variable)
                    register.set(variable, value: oldValue + amount)
                case .decrease(let variable, let amount):
                    let oldValue = register.get(variable)
                    register.set(variable, value: oldValue - amount)
                }
            }
            
            static func from(string: String) -> Operation? {
                let components = string.components(separatedBy: .whitespaces)
                
                if components.count != 3 {
                    return nil
                }
                
                guard let value = Int(components[2]) else {
                    return nil
                }
                
                switch components[1] {
                case "inc":
                    return .increase(components[0], value)
                case "dec":
                    return .decrease(components[0], value)
                default:
                    return nil
                }
            }
        }
        
        enum Condition {
            case equal(String, Int)
            case notEqual(String, Int)
            case lowerThan(String, Int)
            case greaterThan(String, Int)
            case lowerOrEqualThan(String, Int)
            case greaterOrEqualThan(String, Int)
            
            func isSatisfied(in register: Register) -> Bool {
                switch self {
                case .equal(let variable, let value):
                    return register.get(variable) == value
                case .notEqual(let variable, let value):
                    return register.get(variable) != value
                case .lowerThan(let variable, let value):
                    return register.get(variable) < value
                case .lowerOrEqualThan(let variable, let value):
                    return register.get(variable) <= value
                case .greaterThan(let variable, let value):
                    return register.get(variable) > value
                case .greaterOrEqualThan(let variable, let value):
                    return register.get(variable) >= value
                }
            }
            
            static func from(string: String) -> Condition? {
                let components = string.components(separatedBy: .whitespaces)
                
                if components.count != 3 {
                    return nil
                }
                
                guard let value = Int(components[2]) else {
                    return nil
                }
                
                switch components[1] {
                case "==":
                    return .equal(components[0], value)
                case "!=":
                    return .notEqual(components[0], value)
                case "<":
                    return .lowerThan(components[0], value)
                case ">":
                    return .greaterThan(components[0], value)
                case "<=":
                    return .lowerOrEqualThan(components[0], value)
                case ">=":
                    return .greaterOrEqualThan(components[0], value)
                default:
                    return nil
                }
            }
        }
        
        struct Instruction {
            let operation: Operation
            let condition: Condition
            
            func perform(on register: inout Register) {
                if condition.isSatisfied(in: register) {
                    operation.perform(on: &register)
                }
            }
            
            static func from(string: String) -> Instruction? {
                let components = string.components(separatedBy: " if ")
                if components.count != 2 {
                    return nil
                }
                guard let operation = Operation.from(string: components[0]), let condition = Condition.from(string: components[1]) else {
                    return nil
                }
                return Instruction(operation: operation, condition: condition)
            }
        }
        
        private var values = [String: Int]()
        private var maximum = 0
        
        func get(_ variable: String) -> Int {
            return values[variable] ?? 0
        }
        
        mutating func set(_ variable: String, value: Int) {
            values.updateValue(value, forKey: variable)
            maximum = Swift.max(value, maximum)
        }
        
        func max() -> Int {
            return values.values.max() ?? 0
        }
        
        func overallMax() -> Int {
            return maximum
        }
    }
    
    static func perform(instructions: [Register.Instruction]) -> Register {
        var register = Register()
        instructions.forEach({ $0.perform(on: &register) })
        return register
    }
    
    static func run(input: String) {
        
        let instructions = input.components(separatedBy: .newlines).compactMap({ Register.Instruction.from(string: $0) })
        let registry = perform(instructions: instructions)
        
        let example = "b inc 5 if a > 1\na inc 1 if b < 5\nc dec -10 if a >= 1\nc inc -20 if c == 10"
        assert(perform(instructions: example.components(separatedBy: .newlines).compactMap { Register.Instruction.from(string: $0) }).max() == 1)
        
        print("Maximum value in any registry for Day 8-1 is \(registry.max())")
        
        assert(perform(instructions: example.components(separatedBy: .newlines).compactMap { Register.Instruction.from(string: $0) }).overallMax() == 10)
        print("Maximum value reached for all time for Day 8-2 is \(registry.overallMax())")
    }
}
