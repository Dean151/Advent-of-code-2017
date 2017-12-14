import Foundation

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

func complexInput(for string: String) -> [Int] {
    
    // Convert every character to ASCII number
    var input = string.unicodeScalars.map({ Int($0.value) })
    
    // Adding arbitrary end
    input.append(contentsOf: [17, 31, 73, 47, 23])
    
    return input
}

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

public func knotHash(for string: String) -> String {
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
