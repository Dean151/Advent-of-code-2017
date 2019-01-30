//
//  Day19.swift
//  AdventOfCode2017
//
//  Created by Thomas DURAND on 30/01/2019.
//  Copyright © 2019 Thomas DURAND. All rights reserved.
//

import Foundation

class Day19: Day {
    
    enum Section {
        enum StraightType {
            case horizontal, vertical
        }
        enum CurveType {
            case topLeft, topRight, bottomLeft, bottomRight
        }
        
        case straight(type: StraightType), curve, intersection, letter(char: Character)
        
        static func from(char: Character, previous: Character?) -> Section? {
            switch char {
            case "-":
                return .straight(type: .horizontal)
            case "|":
                return previous == "-" ? .intersection : .straight(type: .vertical)
            case "+":
                return .curve
            default:
                return .letter(char: char)
            }
        }
    }
    
    enum Direction {
        case up, right, down, left
    }
    
    class Pipe {
        
        let width: Int
        let height: Int
        let sections: [Int: Section]
        
        init(width: Int, height: Int, sections: [Int: Section]) {
            self.width = width
            self.height = height
            self.sections = sections
        }
        
        static func index(for pos: Position, in width: Int) -> Int {
            return pos.y * width + pos.x
        }
        
        func index(for pos: Position) -> Int {
            return Pipe.index(for: pos, in: width)
        }
        
        func position(at index: Int) -> Position {
            return (x: index % width, y: (index - (index % width))/width)
        }
        
        func nextPosition(from position: Position, going direction: Direction) -> Position {
            switch direction {
            case .up:
                return (x: position.x, y: position.y - 1)
            case .right:
                return (x: position.x + 1, y: position.y)
            case .down:
                return (x: position.x, y: position.y + 1)
            case .left:
                return (x: position.x - 1, y: position.y)
            }
        }
        
        func nextIndex(from currentIndex: Int, going direction: Direction) -> Int {
            return index(for: nextPosition(from: position(at: currentIndex), going: direction))
        }
        
        func goThrew() -> (word: String, steps: Int) {
            var word = ""
            var steps = 0
            var current = sections.keys.min() ?? 0
            var direction: Direction = .down
            
            while current >= 0 && current < width * height {
                guard let section = sections[current] else {
                    break
                }
                
                steps += 1
                
                switch section {
                case .letter(char: let char):
                    word.append(char)
                case .curve:
                    // Find new direction
                    switch direction {
                    case .up, .down:
                        if current % width == 0 {
                            direction = .right
                        } else if current % width == width-1 {
                            direction = .left
                        } else {
                            direction = sections[current-1] != nil ? .left : .right
                        }
                    case .left, .right:
                        if current < width {
                            direction = .down
                        } else if current >= width * (height-1) {
                            direction = .up
                        } else {
                            direction = sections[current-width] != nil ? .up : .down
                        }
                        break
                    }
                default:
                    break
                }
                
                current = nextIndex(from: current, going: direction)
            }
            
            return (word, steps)
        }
        
        static func parse(input: String) -> Pipe {
            let lines = input.components(separatedBy: .newlines)
            
            // Get width and height
            let height = lines.count, width = lines.max(by: { $0.count < $1.count })!.count
            
            var sections = [Int: Section](minimumCapacity: width*height)
            
            // Now we parse each character.
            for (y,line) in lines.enumerated() {
                var previous: Character?
                for (x,c) in line.enumerated() {
                    if c == " " {
                        continue
                    }
                    
                    let index = Pipe.index(for: (x: x, y: y), in: width)
                    
                    // Parse the section
                    if let section = Section.from(char: c, previous: previous) {
                        sections[index] = section
                    }
                    
                    previous = c
                }
            }
            
            return Pipe(width: width, height: height, sections: sections)
        }
    }
    
    static func run(input: String) {
        let pipe = Pipe.parse(input: input)
        
        let (word, steps) = pipe.goThrew()
        print("Word found by going threw pipe for Day 19-1 is \(word)")
        print("Number of steps package been threw for Day 19-2 is \(steps)")
    }
}
