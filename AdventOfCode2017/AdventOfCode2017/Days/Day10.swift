//
//  Day10.swift
//  AdventOfCode2017
//
//  Created by Thomas DURAND on 19/12/2018.
//  Copyright © 2018 Thomas DURAND. All rights reserved.
//

import Foundation

class Day10: Day {
    
    static func circularSubList(list: [Int], range: Range<Int>) -> [Int] {
        var sublist = [Int]()
        for index in range.lowerBound..<range.upperBound {
            let element = list[index % list.count]
            sublist.append(element)
        }
        return sublist
    }
    
    static func circularReversedSublist(list: inout [Int], range: Range<Int>) {
        for (i, element) in circularSubList(list: list, range: range) .reversed().enumerated() {
            list[(range.lowerBound + i) % list.count] = element
        }
    }
    
    static func knocked(list: [Int], knots: [Int], position: Int = 0, skip: Int = 0) -> (list: [Int], position: Int, skip: Int) {
        
        // Make everything mutable
        var list = list, position = position, skip = skip
        
        for knot in knots {
            // Reversing sublist
            circularReversedSublist(list: &list, range: position..<position+knot)
            
            // Position change
            position += knot + skip
            position %= list.count
            
            // Skip increment
            skip += 1
        }
        
        return (list, position, skip)
    }
    
    static func asciiRepresentation(for string: String) -> [Int] {
        // Convert every character to ASCII number
        var input = string.unicodeScalars.map({ Int($0.value) })
        
        // Adding arbitrary end
        input.append(contentsOf: [17, 31, 73, 47, 23])
        
        return input
    }
    
    static func xorReducer(_ carry: Int?, _ element: Int) -> Int {
        return Int(carry != nil ? UInt8(carry!) ^ UInt8(element) : UInt8(element))
    }
    
    static func knotHash(for string: String) -> String {
        let knots = asciiRepresentation(for: string)
        
        var result = (list: [Int](0..<256), position: 0, skip: 0)
        for _ in 1...64 {
            result = knocked(list: result.list, knots: knots, position: result.position, skip: result.skip)
        }
        
        // Reduce to only 16 number with xor
        let reduced = [Int](0..<16).map({
            return [Int](result.list[$0*16..<($0+1)*16]).reduce(nil, xorReducer)!
        })
        
        // Convert to hexadecimal
        return reduced.reduce("", { $0 + $1.hexValue(minDigits: 2) })
    }
    
    static func run(input: String) {
        let exampleList = [Int](0..<5)
        let exampleKnots = [3, 4, 1, 5]
        assert(knocked(list: exampleList, knots: exampleKnots).list[0...1].reduce(1, *) == 12)
        
        let knots = input.components(separatedBy: .newlines).first!.components(separatedBy: .punctuationCharacters).compactMap({ Int($0) })
        let result = knocked(list: [Int](0..<256), knots: knots).list[0...1].reduce(1, *)
        print("Knock simple hash for Day 10-1 is \(result)")
        
        assert(asciiRepresentation(for: "1,2,3") == [49,44,50,44,51,17,31,73,47,23])
        
        assert([65, 27, 9, 1, 4, 3, 40, 50, 91, 7, 6, 0, 2, 5, 68, 22].reduce(nil, xorReducer) == 64)
        
        assert(0.hexValue(minDigits: 2) == "00")
        assert(7.hexValue(minDigits: 2) == "07")
        assert(64.hexValue(minDigits: 2) == "40")
        assert(128.hexValue(minDigits: 2) == "80")
        assert(255.hexValue(minDigits: 2) == "ff")
        
        assert(knotHash(for: "") == "a2582a3a0e66e6e86e3812dcb672a272")
        assert(knotHash(for: "AoC 2017") == "33efeb34ea91902bb2f59c9920caa6cd")
        assert(knotHash(for: "1,2,3") == "3efbe78a8d82f29979031a4aa0b16a9d")
        assert(knotHash(for: "1,2,4") == "63960835bcdc130f0b66d7ff4f6a5a8e")
        
        print("Knot hash for 10-2: \(knotHash(for: input.trimmingCharacters(in: .whitespacesAndNewlines)))")
    }
}
