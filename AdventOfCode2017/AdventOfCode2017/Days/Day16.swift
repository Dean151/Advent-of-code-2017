//
//  Day16.swift
//  AdventOfCode2017
//
//  Created by Thomas DURAND on 21/12/2018.
//  Copyright © 2018 Thomas DURAND. All rights reserved.
//

import Foundation

class Day16: Day {
    
    struct Programs: CustomStringConvertible {
        
        enum Move {
            case spin(size: Int)
            case exchange(a: Int, b: Int)
            case partner(a: Character, b: Character)
            
            func perform(on programs: inout [Character]) {
                switch self {
                case .spin(size: let size):
                    let offset = programs.count - size
                    programs = [Character](programs[offset...] + programs[..<offset])
                case .exchange(a: let a, b: let b):
                    let c = programs[a]
                    programs[a] = programs[b]
                    programs[b] = c
                case .partner(a: let a, b: let b):
                    guard let i = programs.firstIndex(of: a), let j = programs.firstIndex(of: b) else {
                        fatalError("Program not found")
                    }
                    Move.exchange(a: i, b: j).perform(on: &programs)
                }
            }
            
            static func from(string: String) -> Move? {
                guard let type = string.first else { return nil }
                
                let nextIndex = string.index(after: string.startIndex)
                let orders = string[nextIndex..<string.endIndex]
                
                switch type {
                case "s":
                    guard let size = Int(orders) else { return nil }
                    return .spin(size: size)
                case "x":
                    let components = orders.components(separatedBy: "/")
                    if components.count != 2 { return nil }
                    guard let a = Int(components.first!), let b = Int(components.last!) else { return nil }
                    return .exchange(a: a, b: b)
                case "p":
                    let components = orders.components(separatedBy: "/")
                    if components.count != 2 { return nil }
                    return .partner(a: components.first!.first!, b: components.last!.first!)
                default:
                    return nil
                }
            }
            
            static func danceMoves(from: String) -> [Move] {
                return from.components(separatedBy: ",").compactMap({ Programs.Move.from(string: $0.trimmingCharacters(in: .whitespacesAndNewlines)) })
            }
        }
        
        var programs: [Character]
        
        var done = 0
        var seen = [String: Int]()
        
        init(size: Int) {
            self.programs = [Int](0..<size).map { Character(Unicode.Scalar(UInt8(97 + $0))) }
        }
        
        mutating func danceLoop(n: Int, moves: [Move]) {
            var cycleFound = false
            while done < n {
                dance(with: moves)
                if !cycleFound, let value = seen[description] {
                    cycleFound = true
                    done = n - ((n - value) % (done - value))
                } else if !cycleFound {
                    seen.updateValue(done, forKey: description)
                }
            }
        }
        
        @discardableResult
        mutating func dance(with moves: [Move]) -> Programs {
            moves.forEach {
                $0.perform(on: &programs)
            }
            done += 1
            return self
        }
        
        var description: String {
            return programs.reduce(into: "", { (string, c) in
                string.append(c)
            })
        }
    }
    
    static func run(input: String) {
        let moves = Programs.Move.danceMoves(from: input)
        
        var example = Programs(size: 5)
        assert(example.dance(with: Programs.Move.danceMoves(from: "s1")).description == "eabcd", "spin is badly implemented")
        assert(example.dance(with: Programs.Move.danceMoves(from: "x3/4")).description == "eabdc", "exchange is badly implemented")
        assert(example.dance(with: Programs.Move.danceMoves(from: "pe/b")).description == "baedc", "partners is badly implemented")
        
        var programs = Programs(size: 16)
        programs.dance(with: moves)
        print("After one dance for Day 16-1, programs are like \(programs)")
        
        programs.danceLoop(n: 1000000000, moves: moves)
        print("After one billion dances for Day 16-2, programs are like \(programs)")
    }
}
