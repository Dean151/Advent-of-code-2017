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

class Disk {
    var data: [[Bool]] = []
    
    init(input: String) {
        for row in 0..<128 {
            data.append(knotHash(for: input.appending("-\(row)")).hexToBinary())
        }
    }
    
    func bool(at coords: (x: Int, y: Int)) -> Bool {
        if  data.count == 0 || data.first!.count == 0 || coords.x < 0 || coords.y < 0 || coords.x >= data.first!.count || coords.y >= data.count {
            return false
        }
        
        return data[coords.y][coords.x]
    }
    
    func eraseRegion(around coords: (x: Int, y: Int)) {
        let dxs = [-1,-1,1,1]
        let dys = [-1,1,-1,1]
        for i in 0..<4 {
            let neighboor = (x: coords.x + dxs[i], y: coords.y + dys[i])
            if bool(at: neighboor) {
                eraseRegion(around: neighboor)
            }
            data[coords.y][coords.x] = false
        }
    }
}

func numberOfRegions(in disk: Disk) -> Int {
    var numberOfRegions = 0
    for y in 0..<128 {
        for x in 0..<128 {
            if disk.bool(at: (x: x, y: y)) {
                // We count the region
                numberOfRegions += 1
                // We erase the region
                disk.eraseRegion(around: (x: x, y: y))
            }
        }
    }
    return numberOfRegions
}

assert(numberOfRegions(in: Disk(input: example)) == 1242)

print("Number of regions for 14-2: \(numberOfRegions(in: Disk(input: input)))")
