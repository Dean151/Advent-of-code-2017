//: Playground - noun: a place where people can play

import Foundation

let input = [46, 41, 212, 83, 1, 255, 157, 65, 139, 52, 39, 254, 2, 86,0 ,204]

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

func performHash(for input: [Int], listSize: Int) -> Int {
    var list = [Int](0..<listSize)
    var position = 0
    var skip = 0
    
    for number in input {
        // Reversing sublist
        list.circularReverseSublist(subrange: position..<position+number)
        
        // Position change
        position += number + skip
        position %= list.count
        
        // Skip increment
        skip += 1
    }
    
    return list[0] * list[1]
}

assert(performHash(for: [3, 4, 1, 5], listSize: 5) == 12)

print("Knock hash for 10-1: \(performHash(for: input, listSize: 256))")
