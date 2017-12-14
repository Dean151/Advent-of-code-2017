//: Playground - noun: a place where people can play

import Foundation

let input = "hxtvlmkl"

extension Character {
    var hexValue: UInt {
        if let number = UInt("\(self)") {
            return number
        }
        
        return UInt(self.unicodeScalars.first!.value - 87)
    }
    
    func hexToBinary(minSize: Int) -> [Bool] {
        var array = [Bool].init(repeating: false, count: minSize)
        
        var value = self.hexValue
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

extension String {
    func hexToBinary() -> [Bool] {
        var binary: [Bool] = []
        
        for character in self {
            binary.append(contentsOf: character.hexToBinary(minSize: 4))
        }
        
        return binary
    }
}

assert("a0c2017".hexToBinary().reduce("", { $0 + ($1 ? "1" : "0") }) == "1010000011000010000000010111")

func numberSquareUsed(for input: String) -> Int {
    var squares = 0
    
    for row in 0..<128 {
        squares += knotHash(for: input.appending("-\(row)")).hexToBinary().reduce(0, { $0 + ($1 ? 1 : 0) })
    }
    
    return squares
}

let example = "flqrgnkx"
assert(numberSquareUsed(for: example) == 8108)

print("Number of squares used for 14-1: \(numberSquareUsed(for: input))")
