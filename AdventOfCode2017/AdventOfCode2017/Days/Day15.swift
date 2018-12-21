//
//  Day15.swift
//  AdventOfCode2017
//
//  Created by Thomas DURAND on 21/12/2018.
//  Copyright © 2018 Thomas DURAND. All rights reserved.
//

import Foundation

class Day15: Day {
    
    struct Generator {
        let initial: Int
        let factor: Int
        let multiple: Int
        
        var current: Int
        
        init(initial: Int, factor: Int, multiple: Int? = nil) {
            self.initial = initial
            self.current = initial
            self.factor = factor
            self.multiple = multiple ?? 1
        }
        
        mutating func reinit() {
            current = initial
        }
        
        mutating func next() -> Int {
            var next = current
            repeat {
                next = nextNumber(from: next)
            } while next % multiple != 0
            current = next
            return next
        }
        
        private func nextNumber(from previous: Int) -> Int {
            return previous * factor % 2147483647
        }
    }
    
    struct Judge {
        var a: Generator, b: Generator
        
        mutating func findEqualities(on iterations: Int) -> Int {
            a.reinit()
            b.reinit()
            
            let limit = Int(truncating: NSDecimalNumber(decimal: pow(2, 16)))
            
            var matching = 0
            for _ in 0..<iterations {
                if a.next() % limit == b.next() % limit {
                    matching += 1
                }
            }
            return matching
        }
    }
    
    static func run(input: String) {
        let numbers = input.components(separatedBy: .newlines).compactMap({ $0.components(separatedBy: .whitespaces).last }).compactMap({ Int($0) })
        assert(numbers.count == 2)
        
        assert({ () -> Bool in
            var a = Generator(initial: 65, factor: 16807)
            var b = Generator(initial: 8921, factor: 48271)
            
            if a.next() != 1092455 || b.next() != 430625591 {
                return false
            }
            if a.next() != 1181022009 || b.next() != 1233683848 {
                return false
            }
            if a.next() != 245556042 || b.next() != 1431495498 {
                return false
            }
            if a.next() != 1744312007 || b.next() != 137874439 {
                return false
            }
            if a.next() != 1352636452 || b.next() != 285222916 {
                return false
            }
            
            var judge = Judge(a: a, b: b)
            if judge.findEqualities(on: 5) != 1 || judge.findEqualities(on: 40000000) != 588 {
                return false
            }
            
            return true
        }())
        
        var judge = Judge(a: Generator(initial: numbers.first!, factor: 16807), b: Generator(initial: numbers.last!, factor: 48271))
        print("Judge found \(judge.findEqualities(on: 40000000)) matching pairs for 15-1")
        
        assert({ () -> Bool in
            var a = Generator(initial: 65, factor: 16807, multiple: 4)
            var b = Generator(initial: 8921, factor: 48271, multiple: 8)
            
            if a.next() != 1352636452 || b.next() != 1233683848 {
                return false
            }
            if a.next() != 1992081072 || b.next() != 862516352 {
                return false
            }
            if a.next() != 530830436 || b.next() != 1159784568 {
                return false
            }
            if a.next() != 1980017072 || b.next() != 1616057672 {
                return false
            }
            if a.next() != 740335192 || b.next() != 412269392 {
                return false
            }
            
            var judge = Judge(a: a, b: b)
            if judge.findEqualities(on: 1057) != 1 || judge.findEqualities(on: 5000000) != 309 {
                return false
            }
            
            return true
        }())
        
        judge = Judge(a: Generator(initial: numbers.first!, factor: 16807, multiple: 4), b: Generator(initial: numbers.last!, factor: 48271, multiple: 8))
        print("Judge found \(judge.findEqualities(on: 5000000)) matching pairs for 15-2")
    }
}
