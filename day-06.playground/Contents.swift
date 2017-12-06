//: Playground - noun: a place where people can play

import Foundation

let input = "4    1    15    12    0    9    9    5    5    8    7    3    14    5    12    3"

func banks(for input: String) -> [Int] {
    return input.components(separatedBy: .whitespaces).flatMap {
        return Int($0)
    }
}

assert(banks(for: input).count == 16)

func hash(for banks: [Int]) -> String {
    // This hashvalue is not okay, but enough for this puzzle
    // Convert to hexadecimal
    var hash = ""
    for e in banks {
        if e >= 0 && e <= 9 {
            hash += "\(e)"
        } else {
            switch e {
            case 10:
                hash += "A"
            case 11:
                hash += "B"
            case 12:
                hash += "C"
            case 13:
                hash += "D"
            case 14:
                hash += "E"
            default:
                hash += "F"
            }
        }
        
    }
    return hash
}

func puzzle6_1(for input: [Int]) -> Int {
    var count = 0
    var history = Set<String>()
    var banks = input
    
    var hashValue = hash(for: banks)
    while !history.contains(hashValue) {
        history.insert(hashValue)
        
        // Finding the max
        let max = banks.enumerated().max(by: {
            if $0.element == $1.element {
                return $0.offset > $1.offset
            }
            return $0.element < $1.element
        })!
        
        // Removing the selected bank it's treasuary
        banks[max.offset] = 0
        
        // Redistributing
        var money = max.element
        var index = max.offset
        while money > 0 {
            index = (index + 1) % banks.count
            banks[index] += 1
            money -= 1
        }
        
        // Update the hash, and the count
        hashValue = hash(for: banks)
        count += 1
    }
    
    return count
}

assert(puzzle6_1(for: banks(for: "0 2 7 0")) == 5)

print("Exchange number for puzzle 6-1: \(puzzle6_1(for: banks(for: input)))")
