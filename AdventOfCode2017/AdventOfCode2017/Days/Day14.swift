//
//  Day14.swift
//  AdventOfCode2017
//
//  Created by Thomas DURAND on 21/12/2018.
//  Copyright © 2018 Thomas DURAND. All rights reserved.
//

import Foundation

class Day14: Day {
    
    class Disk {
        let width: Int
        let height: Int
        
        let usage: [Bool]
        
        init(string: String) {
            let width = 128
            let height = 128
            
            var usage = [Bool]()
            for row in 0..<height {
                Day10.knotHash(for: string + "-\(row)").forEach {
                    usage.append(contentsOf: $0.hexToBin(minDigits: 4))
                }
            }
            
            self.width = width
            self.height = height
            self.usage = usage
        }
        
        var used: Int {
            return usage.filter({ $0 }).count
        }
        
        func neighbors(from index: Int, includeSelf: Bool = true) -> [Int] {
            let neighbors: [Int]
            if index % width == width - 1 {
                neighbors = [index - width, index - 1, index + width]
            } else if index % width == 0 {
                neighbors = [index - width, index + 1, index + width]
            } else {
                neighbors = [index - width, index - 1, index + 1, index + width]
            }
            return neighbors.filter({ $0 >= 0 && $0 < width * height })
        }
        
        func delimitRegion(from index: Int) -> Set<Int> {
            var region = Set<Int>()
            var toResolve = Set<Int>([index])
            repeat {
                let current = toResolve.removeFirst()
                region.insert(current)
                toResolve.formUnion(neighbors(from: current).filter({ usage[$0] && !region.contains($0) }))
            } while !toResolve.isEmpty
            
            return region
        }
        
        var regions: Int {
            var inRegion = Set<Int>()
            var regions = 0
            for (index,used) in usage.enumerated() {
                if used && !inRegion.contains(index) {
                    regions += 1
                    inRegion.formUnion(delimitRegion(from: index))
                }
            }
            return regions
        }
    }
    
    static func run(input: String) {
        
        let disk = Disk(string: input.components(separatedBy: .whitespacesAndNewlines).first!)
        
        assert(Disk(string: "flqrgnkx").used == 8108)
        print("Number of squares used for 14-1: \(disk.used)")
        
        assert(Disk(string: "flqrgnkx").regions == 1242)
        print("Number of regions for 14-2: \(disk.regions)")
    }
}
