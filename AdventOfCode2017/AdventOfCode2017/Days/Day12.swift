//
//  Day12.swift
//  AdventOfCode2017
//
//  Created by Thomas DURAND on 21/12/2018.
//  Copyright © 2018 Thomas DURAND. All rights reserved.
//

import Foundation

class Day12: Day {

    struct Program {
        let pid: Int
        var pipesTo = [Int]()
        
        func directPipesToPrograms(with programs: [Int: Program]) -> [Program] {
            return pipesTo.compactMap({ programs[$0] })
        }
        
        func allPipes(with programs: [Int: Program], excluding: Set<Int> = []) -> Set<Int> {
            var pipes = Set<Int>([pid])
            let directPipes = directPipesToPrograms(with: programs).filter({ !excluding.contains($0.pid) })
            for program in directPipes {
                pipes = pipes.union(program.allPipes(with: programs, excluding: pipes.union(excluding)))
            }
            return pipes
        }
        
        static func from(line: String) -> Program? {
            let components = line.components(separatedBy: " <-> ")
            guard let pid = Int(components[0]) else {
                return nil
            }
            
            let pipes = components[1].components(separatedBy: ", ").compactMap({ Int($0) })
            return Program(pid: pid, pipesTo: pipes)
        }
        
        static func parse(lines: [String]) -> [Int: Program] {
            return lines.compactMap({ Program.from(line: $0) }).reduce(into: [Int: Program]()) { (result, program) in
                    result.updateValue(program, forKey: program.pid)
            }
        }
        
        static func groups(programs: [Int: Program]) -> [Set<Int>] {
            var groups = [Set<Int>]()
            var programs = programs
            
            while let program = programs.values.first {
                let group =  program.allPipes(with: programs)
                groups.append(group)
                for pid in group {
                    programs.removeValue(forKey: pid)
                }
            }
            
            return groups
        }
    }
    
    static func programsThatCommunicates(with pid: Int, from groups: [Set<Int>]) -> Set<Int> {
        return groups.first(where: { $0.contains(pid) }) ?? Set<Int>()
    }
    
    static func run(input: String) {
        assert({ () -> Bool in
            let example = "0 <-> 2\n1 <-> 1\n2 <-> 0, 3, 4\n3 <-> 2, 4\n4 <-> 2, 3, 6\n5 <-> 6\n6 <-> 4, 5"
            let programs = Program.parse(lines: example.components(separatedBy: .newlines))
            if (programs.count != 7 || programs[4]?.pipesTo.count != 3) {
                return false
            }
            let groups = Program.groups(programs: programs)
            if (groups.count != 2) {
                return false
            }
            
            return programsThatCommunicates(with: 0, from: groups).count == 6
        }())
        
        let programs = Program.parse(lines: input.components(separatedBy: .newlines))
        let groups = Program.groups(programs: programs)
        print("Number of programs that can communicate with 0 for 12-1: \(programsThatCommunicates(with: 0, from: groups).count)")
        print("Number of groups of programs for 12-2: \(groups.count)")
    }
}
