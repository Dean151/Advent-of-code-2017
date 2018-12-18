//: Playground - noun: a place where people can play

import Foundation

let input = "46,41,212,83,1,255,157,65,139,52,39,254,2,86,0,204"

extension Array {
    func circularSubList(subrange: Range<Int>) -> [Element] {
        var sublist = [Element]()
        for index in subrange.lowerBound..<subrange.upperBound {
            let element = self[index % self.count]
            sublist.append(element)
        }
        return sublist
    }
    
    mutating func circularReverseSublist(subrange: Range<Int>) {
        let extractedList = self.circularSubList(subrange: subrange)
        let reversedList = extractedList.reversed()
        for (i, element) in reversedList.enumerated() {
            self[(subrange.lowerBound + i) % self.count] = element
        }
    }
}

func hash(for input: [Int], initialList: [Int], initialPosition: Int = 0, initialSkip: Int = 0) -> ([Int], Int, Int) {
    var list = initialList
    var position = initialPosition
    var skip = initialSkip
    
    for number in input {
        // Reversing sublist
        list.circularReverseSublist(subrange: position..<position+number)
        
        // Position change
        position += number + skip
        position %= list.count
        
        // Skip increment
        skip += 1
    }
    
    return (list, position, skip)
}

let example = hash(for: [3, 4, 1, 5], initialList: [Int](0..<5)).0
assert(example[0] * example[1] == 12)

let intInput = input.components(separatedBy: ",").flatMap({ Int($0) })
let result = hash(for: intInput, initialList: [Int](0..<256)).0
print("Knock hash for 10-1: \(result[0] * result[1])")

func complexInput(for string: String) -> [Int] {
    
    // Convert every character to ASCII number
    var input = string.unicodeScalars.map({ Int($0.value) })
    
    // Adding arbitrary end
    input.append(contentsOf: [17, 31, 73, 47, 23])
    
    return input
}

assert(complexInput(for: "1,2,3") == [49,44,50,44,51,17,31,73,47,23])

func xorReduce(for list: [Int]) -> Int {
    var incremental: UInt8?
    
    for number in list {
        if let precedent = incremental {
            incremental = precedent ^ UInt8(number)
        } else {
            incremental = UInt8(number)
        }
    }
    
    return Int(incremental!)
}

assert(xorReduce(for: [65, 27, 9, 1, 4, 3, 40, 50, 91, 7, 6, 0, 2, 5, 68, 22]) == 64)

extension Int {
    func toHex(size: Int = 2) -> String {
        
        var string = ""
        
        if self < 10 {
            string = "\(self)"
        } else if self < 16 {
            switch self {
            case 10:
                string = "a"
            case 11:
                string = "b"
            case 12:
                string = "c"
            case 13:
                string = "d"
            case 14:
                string = "e"
            default:
                string = "f"
            }
        } else {
            var quotient = self
            var stop = false
            repeat {
                let remainder = quotient % 16
                stop = remainder == quotient
                quotient = quotient / 16
                string = remainder.toHex(size: 1) + string
            } while !stop
        }
        
        while string.count < size {
            string = "0" + string
        }
        
        return string
    }
}

assert(0.toHex() == "00")
assert(7.toHex() == "07")
assert(64.toHex() == "40")
assert(128.toHex() == "80")
assert(255.toHex() == "ff")

func knotHash(for string: String) -> String {
    let input = complexInput(for: string)
    
    var list = [Int](0..<256)
    var position = 0
    var skip = 0
    
    for _ in 1...64 {
        let result = hash(for: input, initialList: list, initialPosition: position, initialSkip: skip)
        list = result.0
        position = result.1
        skip = result.2
    }
    
    // Reduce to only 16 number with xor
    var reducedList = [Int]()
    for i in 0..<16 {
        let range = i*16..<(i+1)*16
        let sublist = [Int](list[range])
        reducedList.append(xorReduce(for: sublist))
    }
    
    // Convert to hexadecimal
    var hexString = ""
    for number in reducedList {
        // Convert each number to hexa
        hexString += number.toHex()
    }
    
    return hexString
}

assert(knotHash(for: "") == "a2582a3a0e66e6e86e3812dcb672a272")
assert(knotHash(for: "AoC 2017") == "33efeb34ea91902bb2f59c9920caa6cd")
assert(knotHash(for: "1,2,3") == "3efbe78a8d82f29979031a4aa0b16a9d")
assert(knotHash(for: "1,2,4") == "63960835bcdc130f0b66d7ff4f6a5a8e")

print("Knot hash for 10-2: \(knotHash(for: input.trimmingCharacters(in: CharacterSet.whitespaces)))")
