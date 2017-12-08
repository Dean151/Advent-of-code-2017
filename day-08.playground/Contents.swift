//: Playground - noun: a place where people can play

import Foundation

// Get the puzzle input
let url = Bundle.main.url(forResource: "input", withExtension: "txt")!
let input = try! String.init(contentsOf: url)

enum Errors: Error {
    case errorOccured
}

struct Register {
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

enum Operation {
    case increase(String, Int)
    case decrease(String, Int)
    
    func perform(for register: inout Register) {
        switch self {
        case .increase(let variable, let amount):
            let oldValue = register.get(variable)
            register.set(variable, value: oldValue + amount)
        case .decrease(let variable, let amount):
            let oldValue = register.get(variable)
            register.set(variable, value: oldValue - amount)
        }
    }
    
    static func from(string: String) throws -> Operation {
        let components = string.components(separatedBy: .whitespaces)
        
        if components.count != 3 {
            throw Errors.errorOccured
        }
        
        guard let value = Int(components[2]) else {
            throw Errors.errorOccured
        }
        
        switch components[1] {
        case "inc":
            return .increase(components[0], value)
        case "dec":
            return .decrease(components[0], value)
        default:
            throw Errors.errorOccured
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
    
    func isSatisfied(for register: Register) -> Bool {
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
    
    static func from(string: String) throws -> Condition {
        let components = string.components(separatedBy: .whitespaces)
        
        if components.count != 3 {
            throw Errors.errorOccured
        }
        
        guard let value = Int(components[2]) else {
            throw Errors.errorOccured
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
            throw Errors.errorOccured
        }
    }
}

struct Instruction {
    let operation: Operation
    let condition: Condition
    
    static func from(string: String) throws -> Instruction {
        let components = string.components(separatedBy: " if ")
        if components.count != 2 {
            throw Errors.errorOccured
        }
        
        let operation = try Operation.from(string: components[0])
        let condition = try Condition.from(string: components[1])
        return Instruction(operation: operation, condition: condition)
    }
}

func puzzle6(input: String) -> (Int, Int) {
    var register = Register()
    for instruction in input.components(separatedBy: .newlines) {
        do {
            let instruction = try Instruction.from(string: instruction)
            if instruction.condition.isSatisfied(for: register) {
                instruction.operation.perform(for: &register)
            }
        } catch {
            print("Could not parse instruction: \(instruction)")
        }
    }
    return (register.max(), register.overallMax())
}

let example = """
b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10
"""

let exampleValues = puzzle6(input: example)
assert(exampleValues.0 == 1)
assert(exampleValues.1 == 10)

let values = puzzle6(input: input)
print("Max register value for 8-1: \(values.0)")
print("Overall max register value for 8-2: \(values.1)")

