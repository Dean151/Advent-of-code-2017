//
//  Day11.swift
//  AdventOfCode2017
//
//  Created by Thomas DURAND on 19/12/2018.
//  Copyright © 2018 Thomas DURAND. All rights reserved.
//

import Foundation

class Day11: Day {
    
    struct HexGrid {
        enum Direction: String {
            case north = "n", northEst = "ne", northWest = "nw"
            case south = "s", southEst = "se", southWest = "sw"
            
            func move(from coords: Position) -> Position {
                switch self {
                case .north:
                    return (x: coords.x, y: coords.y + 1)
                case .northEst:
                    return (x: coords.x + 1, y: coords.y)
                case .south:
                    return (x: coords.x, y: coords.y - 1)
                case .southWest:
                    return (x: coords.x - 1, y: coords.y)
                // Combined cases
                case .northWest:
                    return (x: coords.x - 1, y: coords.y + 1)
                case .southEst:
                    return (x: coords.x + 1, y: coords.y - 1)
                }
            }
            
            static func from(input: String) -> [Direction] {
                return input.components(separatedBy: .newlines).first!.components(separatedBy: ",").compactMap { Direction(rawValue: $0) }
            }
        }
        
        
        struct Coordinates {
            var position = (x: 0, y: 0)
            var maxDistance = 0
            
            mutating func move(direction: Direction) {
                position = direction.move(from: position)
                maxDistance = max(maxDistance, distanceFromOrigin)
            }
            
            var distanceFromOrigin: Int {
                if position.x == 0 || position.y == 0 || position.x/abs(position.x) == position.y/abs(position.y) {
                    // If same sign
                    return abs(position.x + position.y)
                } else {
                    // Not the same sign
                    return max(abs(position.x), abs(position.y))
                }
            }
        }
        
        static func coordinates(after moves: [Direction]) -> Coordinates {
            var coordinates = Coordinates()
            moves.forEach({
                coordinates.move(direction: $0)
            })
            return coordinates
        }
    }
    
    static func run(input: String) {
        let directions = HexGrid.Direction.from(input: input)
        
        assert(HexGrid.coordinates(after: HexGrid.Direction.from(input: "ne,ne,ne")).distanceFromOrigin == 3)
        assert(HexGrid.coordinates(after: HexGrid.Direction.from(input: "ne,ne,sw,sw")).distanceFromOrigin == 0)
        assert(HexGrid.coordinates(after: HexGrid.Direction.from(input: "ne,ne,s,s")).distanceFromOrigin == 2)
        assert(HexGrid.coordinates(after: HexGrid.Direction.from(input: "se,sw,se,sw,sw")).distanceFromOrigin == 3)
        
        let coordinate = HexGrid.coordinates(after: directions)
        print("Distance from origin for Day 11-1: \(coordinate.distanceFromOrigin)")
        print("Furthest we ever got from origin for Day 11-2: \(coordinate.maxDistance)")
    }
}
