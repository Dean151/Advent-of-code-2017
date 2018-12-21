//
//  Day17.swift
//  AdventOfCode2017
//
//  Created by Thomas DURAND on 21/12/2018.
//  Copyright © 2018 Thomas DURAND. All rights reserved.
//

import Foundation

class Day17: Day {
    
    static func spinlock(steps: Int, iterations: Int = 2017) -> Int {
        var memory = [0]
        var index = 0
        for iteration in 1...iterations {
            index = ((index + steps) % iteration) + 1
            memory.insert(iteration, at: index)
        }
        return memory[index+1 % memory.count]
    }
    
    static func firstValueAfter0(steps: Int, iterations: Int = 50000000) -> Int {
        var index = 0
        var value = 0
        for iteration in 1...iterations {
            index = ((index + steps) % iteration) + 1
            if index == 1 {
                value = iteration
            }
        }
        return value
    }
    
    static func run(input: String) {
        let input = Int(input.components(separatedBy: .whitespacesAndNewlines).first!)!
        
        assert(spinlock(steps: 3) == 638)
        print("Value right after 2017 for 17-1: \(spinlock(steps: input))")
        print("Value right after 0 for 17-2: \(firstValueAfter0(steps: input))")
    }
}
