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
        
        var regions: Int {
            // TODO!
            return 0
        }
    }
    
    static func run(input: String) {
        
        assert(Disk(string: "flqrgnkx").used == 8108)
        
        let disk = Disk(string: input.components(separatedBy: .whitespacesAndNewlines).first!)
        print("Number of squares used for 14-1: \(disk.used)")
        
        assert(Disk(string: "flqrgnkx").regions == 1242)
        print("Number of regions for 14-2: \(disk.regions)")
    }
}
