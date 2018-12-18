//
//  Day3.swift
//  AdventOfCode2017
//
//  Created by Thomas DURAND on 18/12/2018.
//  Copyright © 2018 Thomas DURAND. All rights reserved.
//

import Foundation

class Day3: Day {
    
    enum Direction {
        case right, up, left, down
        
        func move(from pos: Position, length: Int = 1) -> Position {
            switch self {
            case .right:
                return (x: pos.x + length, y: pos.y)
            case .up:
                return (x: pos.x, y: pos.y + length)
            case .left:
                return (x: pos.x - length, y: pos.y)
            case .down:
                return (x: pos.x, y: pos.y - length)
            }
        }
        
        static func from(turns: Int) -> Direction {
            switch turns % 4 {
            case 0:
                return .right
            case 1:
                return .up
            case 2:
                return .left
            case 3:
                return .down
            default:
                fatalError("cannot append")
            }
        }
    }
    
    struct SpiralSum {
        var values = [Int:[Int:Int]]()
        
        func value(at coordinate: (x: Int, y: Int)) -> Int? {
            return values[coordinate.y]?[coordinate.x]
        }
        
        func sum(around coordinate: (x: Int, y: Int)) -> Int {
            if coordinate.x == 0 && coordinate.y == 0 {
                return 1
            } else {
                var offsetX = [-1, -1, -1, 0, 0, 1, 1, 1]
                var offsetY = [-1,  0,  1, -1, 1, -1, 0, 1]
                var sum = 0
                for i in 0..<8 {
                    sum += value(at: (x: coordinate.x + offsetX[i], y: coordinate.y + offsetY[i])) ?? 0
                }
                return sum
            }
        }
        
        mutating func set(value: Int, at coordinate: (x: Int, y: Int)) {
            if values[coordinate.y] == nil {
                values.updateValue([coordinate.x : value], forKey: coordinate.y)
            } else {
                values[coordinate.y]!.updateValue(value, forKey: coordinate.x)
            }
        }
    }
    
    static func distance(of input: Int) -> Int {
        var position = (x: 0, y: 0)
        var n = 1
        var turns = 0
        
        while n < input-1 {
            let length = (turns / 2) + 1
            n += length
            let direction = Direction.from(turns: turns)
            position = direction.move(from: position, length: length)
            if n > input {
                let diff = n - input
                position = Direction.from(turns: turns).move(from: position, length: -diff)
                break
            }
            turns += 1
        }
        
        return abs(position.x) + abs(position.y)
    }
    
    static func summedDistance(of input: Int) -> Int {
        var values = SpiralSum()
        var position = (x: 0, y: 0)
        var n = 0
        var turns = 0
        
        while n < input {
            let length = (turns / 2) + 1
            for _ in 0..<length {
                if n >= input {
                    break
                }
                // Sommer la somme des carrés adjacents
                n = values.sum(around: position)
                values.set(value: n, at: position)
                position = Direction.from(turns: turns).move(from: position)
            }
            turns += 1
        }
        
        return n
    }
    
    static func run(input: String) {
        let input = Int(input.components(separatedBy: .newlines).first!)!
        
        assert(distance(of: 1) == 0)
        assert(distance(of: 12) == 3)
        assert(distance(of: 23) == 2)
        assert(distance(of: 1024) == 31)
        
        let foundDistance = self.distance(of: input)
        print("Distance from 1 to \(input) for Day 3-1 is \(foundDistance)")
        
        assert(summedDistance(of: 20) == 23)
        assert(summedDistance(of: 100) == 122)
        assert(summedDistance(of: 700) == 747)
        assert(summedDistance(of: 800) == 806)
        
        let foundSummedDistance = self.summedDistance(of: input)
        print("First value bigger than \(input) for Day 3-2 is \(foundSummedDistance)")
    }
}
