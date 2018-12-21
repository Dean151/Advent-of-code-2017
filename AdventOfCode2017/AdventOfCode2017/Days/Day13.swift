//
//  Day13.swift
//  AdventOfCode2017
//
//  Created by Thomas DURAND on 21/12/2018.
//  Copyright © 2018 Thomas DURAND. All rights reserved.
//

import Foundation

class Day13: Day {
    
    struct Scanner {
        let depth: Int
        let range: Int
        
        init?(string: String) {
            let components = string.components(separatedBy: ": ")
            guard let depth = components.first.flatMap({ Int($0) }) else {
                return nil
            }
            guard let range = components.last.flatMap({ Int($0) }) else {
                return nil
            }
            self.depth = depth
            self.range = range
        }
        
        var period: Int {
            return (range - 1) * 2
        }
        
        func doCatch(delayedBy delay: Int = 0) -> Bool {
            return (depth+delay) % period == 0
        }
    }
    
    struct Firewall {
        
        let scanners: [Scanner]
        
        static func from(input: String) -> Firewall {
            let scanners = input.components(separatedBy: .newlines).compactMap({ Scanner(string: $0) })
            return Firewall(scanners: scanners)
        }
        
        func goThrew(delayedBy delay: Int) -> Bool {
            return !scanners.contains(where: { $0.doCatch(delayedBy: delay) })
        }
        
        var severity: Int {
            return scanners.filter({ $0.doCatch() }).map({ $0.depth * $0.range }).reduce(0, +)
        }
        
        var minimumDelay: Int {
            var delay = 1
            while !goThrew(delayedBy: delay) {
                delay += 1
            }
            return delay
        }
    }
    
    static func run(input: String) {
        
        let firewall = Firewall.from(input: input)
        
        assert(Firewall.from(input: "0: 3\n1: 2\n4: 4\n6: 4").severity == 24)
        print("Severity for 13-1: \(firewall.severity)")
        
        assert(Firewall.from(input: "0: 3\n1: 2\n4: 4\n6: 4").minimumDelay == 10)
        print("Delay to get through for 13-2: \(firewall.minimumDelay)")
    }
}
