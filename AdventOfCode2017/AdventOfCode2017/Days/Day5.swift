//
//  Day5.swift
//  AdventOfCode2017
//
//  Created by Thomas DURAND on 18/12/2018.
//  Copyright © 2018 Thomas DURAND. All rights reserved.
//

import Foundation

class Day5: Day {
    
    static func perform(_ jumps: [Int], decreasing: Bool = false) -> Int {
        var count = 0
        
        var jumps = jumps
        var index = 0
        while index >= 0 && index < jumps.count {
            let i = index
            index += jumps[i]
            jumps[i] += (decreasing && jumps[i] >= 3) ? -1 : 1
            count += 1
        }
        return count
    }
    
    static func run(input: String) {
        let jumps = input.components(separatedBy: .whitespacesAndNewlines).compactMap { Int($0) }
        
        assert(perform([0, 3, 0, 1, -3]) == 5)
        
        let number = perform(jumps)
        print("Number of jumps for Day 5-1 is \(number)")
        
        assert(perform([0, 3, 0, 1, -3], decreasing: true) == 10)
        
        let numberWithDecrease = perform(jumps, decreasing: true)
        print("Number of jumps for Day 5-2 is \(numberWithDecrease)")
    }
}
