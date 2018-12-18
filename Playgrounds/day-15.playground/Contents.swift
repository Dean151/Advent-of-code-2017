//: Playground - noun: a place where people can play

import Foundation

// last bits comparaisons of numbers
func compare(onLast bits: Int) -> ((Int, Int) -> Bool) {
    let limit = Int(truncating: NSDecimalNumber(decimal: pow(2, bits)))
    return { lhs, rhs -> Bool in
        return lhs % limit == rhs % limit
    }
}

struct Generator {
    let initial: Int
    let factor: Int
    let multipleOf: Int?
    
    func nextNumber(from previous: Int) -> Int {
        guard let multipleOf = multipleOf else {
            return _nextNumber(from: previous)
        }
        
        var value = _nextNumber(from: previous)
        while value % multipleOf != 0 {
            value = _nextNumber(from: value)
        }
        return value
    }
    
    func _nextNumber(from previous: Int) -> Int {
        return previous * factor % 2147483647
    }
}

func numberOfEqualsOn16bits(for generators: (a: Generator, b: Generator), on iterations: Int) -> Int {
    
    let comparer = compare(onLast: 16)
    var a = generators.a.initial
    var b = generators.b.initial
    var number = 0
    
    for _ in 0..<iterations {
        a = generators.a.nextNumber(from: a)
        b = generators.b.nextNumber(from: b)
        if comparer(a, b) {
            number += 1
        }
    }
    
    return number
}

// First part

let exampleA = Generator(initial: 65, factor: 16807, multipleOf: nil)
let exampleB = Generator(initial: 8921, factor: 48271, multipleOf: nil)

assert(exampleA.nextNumber(from: 65) == 1092455)
assert(exampleA.nextNumber(from: 1092455) == 1181022009)
assert(exampleA.nextNumber(from: 1181022009) == 245556042)
assert(exampleA.nextNumber(from: 245556042) == 1744312007)
assert(exampleA.nextNumber(from: 1744312007) == 1352636452)

assert(exampleB.nextNumber(from: 8921) == 430625591)
assert(exampleB.nextNumber(from: 430625591) == 1233683848)
assert(exampleB.nextNumber(from: 1233683848) == 1431495498)
assert(exampleB.nextNumber(from: 1431495498) == 137874439)
assert(exampleB.nextNumber(from: 137874439) == 285222916)

assert(numberOfEqualsOn16bits(for: (a: exampleA, b: exampleB), on: 5) == 1)
assert(numberOfEqualsOn16bits(for: (a: exampleA, b: exampleB), on: 40000000) == 588)

let a = Generator(initial: 512, factor: 16807, multipleOf: nil)
let b = Generator(initial: 191, factor: 48271, multipleOf: nil)
print("Judge found \(numberOfEqualsOn16bits(for: (a: a, b: b), on: 40000000)) matching pairs for 15-1")

// Second part

let example2A = Generator(initial: 65, factor: 16807, multipleOf: 4)
let example2B = Generator(initial: 8921, factor: 48271, multipleOf: 8)

assert(example2A.nextNumber(from: 65) == 1352636452)
assert(example2A.nextNumber(from: 1352636452) == 1992081072)
assert(example2A.nextNumber(from: 1992081072) == 530830436)
assert(example2A.nextNumber(from: 530830436) == 1980017072)
assert(example2A.nextNumber(from: 1980017072) == 740335192)

assert(example2B.nextNumber(from: 8921) == 1233683848)
assert(example2B.nextNumber(from: 1233683848) == 862516352)
assert(example2B.nextNumber(from: 862516352) == 1159784568)
assert(example2B.nextNumber(from: 1159784568) == 1616057672)
assert(example2B.nextNumber(from: 1616057672) == 412269392)

assert(numberOfEqualsOn16bits(for: (a: example2A, b: example2B), on: 1057) == 1)
assert(numberOfEqualsOn16bits(for: (a: example2A, b: example2B), on: 5000000) == 309)

let a2 = Generator(initial: 512, factor: 16807, multipleOf: 4)
let b2 = Generator(initial: 191, factor: 48271, multipleOf: 8)
print("Judge found \(numberOfEqualsOn16bits(for: (a: a2, b: b2), on: 5000000)) matching pairs for 15-2")
