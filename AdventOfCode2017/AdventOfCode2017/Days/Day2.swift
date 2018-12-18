//
//  Day2.swift
//  AdventOfCode2017
//
//  Created by Thomas DURAND on 18/12/2018.
//  Copyright © 2018 Thomas DURAND. All rights reserved.
//

import Foundation

class Day2: Day {
    
    static func sumOfDifference(matrix: [[Int]]) -> Int {
        return matrix.map({ $0.max()! - $0.min()! }).reduce(0, +)
    }
    
    static func sumOfDividers(matrix: [[Int]]) -> Int {
        return matrix.map({
            let sortedArray = $0.sorted() // Sort to make one check instead of two
            // o(n*log(n)) complexity
            for i in 0..<$0.count-1 {
                for j in i+1..<$0.count {
                    if sortedArray[j] % sortedArray[i] == 0 {
                        return sortedArray[j] / sortedArray[i]
                    }
                }
            }
            assertionFailure()
            return 0
        }).reduce(0, +)
    }
    
    static func run(input: String) {
        
        let matrix = input.components(separatedBy: .newlines).filter({ !$0.isEmpty }).map {
            $0.components(separatedBy: CharacterSet.whitespaces).compactMap { Int($0) }
        }
        
        assert(sumOfDifference(matrix: [[5, 1, 9, 5], [7, 5, 3], [2, 4, 6, 8]]) == 18)
        
        let checksum = sumOfDifference(matrix: matrix)
        print("Captcha sum for Day 1-1 is \(checksum)")
        
        assert(sumOfDividers(matrix: [[5, 9, 2, 8], [9, 4, 7, 3], [3, 8, 6, 5]]) == 9)
        
        let newChecksum = sumOfDividers(matrix: matrix)
        print("Captcha sum for Day 1-2 is \(newChecksum)")
    }
}
