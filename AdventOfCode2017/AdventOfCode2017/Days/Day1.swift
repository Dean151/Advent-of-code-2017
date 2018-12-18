//
//  Day1.swift
//  AdventOfCode2017
//
//  Created by Thomas DURAND on 18/12/2018.
//  Copyright © 2018 Thomas DURAND. All rights reserved.
//

import Foundation

class Day1: Day {
    
    static func captchaSum(input: String, offsetted: Bool = false) -> Int {
        let digits = input.reduce(into: [Int](), { if let digit = Int("\($1)") { $0.append(digit) } })
        let total = digits.count
        let offset = offsetted ? total / 2 : 1
        
        var sum = 0
        for (index, digit) in digits.enumerated() {
            if digit == digits[(index + offset) % total] {
                // Only if it's the same than before, we add
                sum += digit
            }
        }
        return sum
    }
    
    static func run(input: String) {
        assert(captchaSum(input: "1122") == 3)
        assert(captchaSum(input: "1111") == 4)
        assert(captchaSum(input: "1234") == 0)
        assert(captchaSum(input: "91212129") == 9)
        
        let sum = captchaSum(input: input)
        print("Captcha sum for Day 1-1 is \(sum)")
        
        assert(captchaSum(input: "1122", offsetted: true) == 6)
        assert(captchaSum(input: "1221", offsetted: true) == 0)
        assert(captchaSum(input: "123425", offsetted: true) == 4)
        assert(captchaSum(input: "123123", offsetted: true) == 12)
        assert(captchaSum(input: "12131415", offsetted: true) == 4)
        
        let offsetSum = captchaSum(input: input, offsetted: true)
        print("Captcha sum for Day 1-2 is \(offsetSum)")
    }
}
