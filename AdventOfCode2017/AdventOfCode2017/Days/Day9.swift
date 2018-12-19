//
//  Day9.swift
//  AdventOfCode2017
//
//  Created by Thomas DURAND on 19/12/2018.
//  Copyright © 2018 Thomas DURAND. All rights reserved.
//

import Foundation

class Day9: Day {
    
    static func clean(input: String, escaper: Character = "!", starter: Character = "<", ender: Character = ">") -> (String, Int) {
        var string = input
        
        // Remove escaped characted from the string
        while let index = string.index(of: escaper) {
            // Remove the escaper
            string.remove(at: index)
            // Remove the escaped charater
            string.remove(at: index)
        }
        
        var garbageCount = 0
        while let startIndex = string.index(of: starter) {
            if let endIndex = string.index(of: ender) {
                garbageCount += Int(string.distance(from: startIndex, to: endIndex).magnitude) - 1
                string.removeSubrange(startIndex...endIndex)
            }
        }
        
        return (string, garbageCount)
    }
    
    static func score(for input: String, starter: Character = "{", ender: Character = "}") -> Int {
        var score = 0
        var length = 1
        input.forEach {
            if $0 == starter {
                score += length
                length += 1
            } else if $0 == ender {
                length -= 1
            }
        }
        return score
    }
    
    static func run(input: String) {
        assert(clean(input: "{{<a>},{<a>},{<a>},{<a>}}").0 == "{{},{},{},{}}")
        assert(clean(input: "{{<!>},{<!>},{<!>},{<a>}}").0 == "{{}}")
        
        assert(score(for: clean(input: "{}").0) == 1)
        assert(score(for: clean(input: "{{{}}}").0) == 6)
        assert(score(for: clean(input: "{{},{}}").0) == 5)
        assert(score(for: clean(input: "{{{},{},{{}}}}").0) == 16)
        assert(score(for: clean(input: "{<a>,<a>,<a>,<a>}").0) == 1)
        assert(score(for: clean(input: " {{<ab>},{<ab>},{<ab>},{<ab>}}").0) == 9)
        assert(score(for: clean(input: "{{<!!>},{<!!>},{<!!>},{<!!>}}").0) == 9)
        assert(score(for: clean(input: "{{<a!>},{<a!>},{<a!>},{<ab>}}").0) == 3)
        
        let cleaned = clean(input: input)
        print("Score for input for Day 9-1 is \(score(for: cleaned.0))")
        
        assert(clean(input: "<>").1 == 0)
        assert(clean(input: "<random characters>").1 == 17)
        assert(clean(input: "<<<<>").1 == 3)
        assert(clean(input: "<{!>}>").1 == 2)
        assert(clean(input: "<!!>").1 == 0)
        assert(clean(input: "<!!!>>").1 == 0)
        assert(clean(input: "<{o\"i!a,<{i<a>").1 == 10)
        
        print("Number of garbage characters removed for Day 9-2 is \(cleaned.1)")
    }
}
