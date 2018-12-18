//
//  Day6.swift
//  AdventOfCode2017
//
//  Created by Thomas DURAND on 18/12/2018.
//  Copyright © 2018 Thomas DURAND. All rights reserved.
//

import Foundation

class Day6: Day {
    
    static func hexValue(bank: [Int]) -> String {
        return bank.reduce("", { return $0 + String($1, radix: 16) })
    }
    
    static func redistribute(bank: [Int]) -> [Int] {
        var (index, money) = bank.enumerated().max(by: { return $0.element != $1.element ? $0.element < $1.element : $0.offset > $1.offset })!
        
        var bank = bank
        bank[index] = 0
        while money > 0 {
            index = (index + 1) % bank.count
            bank[index] += 1
            money -= 1
        }
        return bank
    }
    
    static func redistributeUntilRepeat(bank: [Int]) -> (count: Int, output: [Int]) {
        var hashes = Set<String>()
        var counter = 0
        var bank = bank
        while !hashes.contains(hexValue(bank: bank)) {
            hashes.insert(hexValue(bank: bank))
            bank = redistribute(bank: bank)
            counter += 1
        }
        return (counter, bank)
    }
    
    static func run(input: String) {
        let bank = input.components(separatedBy: .whitespacesAndNewlines).compactMap { Int($0) }
        
        let example = redistributeUntilRepeat(bank: [0, 2, 7, 0])
        assert(example.count == 5)
        
        let redistributed = redistributeUntilRepeat(bank: bank)
        print("Redistributed \(redistributed.count) times before repeating for Day 6-1")
        
        // Redistribute
        let example2 = redistributeUntilRepeat(bank: example.output)
        assert(example2.count == 4)
        
        let redistributed2 = redistributeUntilRepeat(bank: redistributed.output)
        print("The loop size for Day 6-2 is \(redistributed2.count)")
    }
}
