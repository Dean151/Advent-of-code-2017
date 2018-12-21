//
//  shared.swift
//  AdventOfCode2018
//
//  Created by Thomas Durand on 04/12/2018.
//  Copyright © 2018 Thomas Durand. All rights reserved.
//

import Foundation

typealias Position = (x: Int, y: Int)

extension NSTextCheckingResult {
    public func group(at index: Int, in string: String) -> String {
        let range = self.range(at: index)
        if range.location > string.count {
            return ""
        }
        return (string as NSString).substring(with: range)
    }
}

extension Int {
    func hexValue(minDigits: UInt = 0) -> String {
        var hex = String(self, radix: 16)
        while minDigits > hex.count {
            hex = "0" + hex
        }
        return hex
    }
}

extension Character {
    func hexToBin(minDigits: UInt = 0) -> [Bool] {
        var array = [Bool](repeating: false, count: Int(minDigits))
        var value = UInt("\(self)") ?? UInt(self.unicodeScalars.first!.value - 87)
        var index = 0
        repeat {
            let bool = value % 2 == 1
            if index >= array.count {
                array.append(bool)
            } else {
                array[index] = bool
            }
            
            value = (value - (value % 2)) / 2
            index += 1
        } while value > 0
        
        return array.reversed()
    }
}
