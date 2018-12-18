//: Playground - noun: a place where people can play

import Foundation

let url = Bundle.main.url(forResource: "input", withExtension: "txt")!
let input = try! String.init(contentsOf: url)

struct Program {
    let pid: Int
    var pipesTo = [Int]()
    
    func directPipesToPrograms(with programs: [Int: Program]) -> [Program] {
        return pipesTo.flatMap({ programs[$0] })
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
        
        let pipes = components[1].components(separatedBy: ", ").flatMap({ Int($0) })
        return Program(pid: pid, pipesTo: pipes)
    }
}

func programs(from input: String) -> [Int: Program] {
    var programs = [Int: Program]()
    for line in input.components(separatedBy: .newlines) {
        if let program = Program.from(line: line) {
            programs.updateValue(program, forKey: program.pid)
        }
    }
    return programs
}

func groupsOfPrograms(programs: [Int: Program]) -> [Set<Int>] {
    var groups = [Set<Int>]()
    var programsCopy = programs
    
    while let program = programsCopy.values.first {
        let group =  program.allPipes(with: programs)
        for pid in group {
            programsCopy.removeValue(forKey: pid)
        }
        groups.append(group)
    }
    
    return groups
}

func numberOfProgram(thatCanCommunicateWith pid: Int, with groups: [Set<Int>]) -> Int {
    return groups.first(where: { $0.contains(pid) })?.count ?? 0
}

let example = """
0 <-> 2
1 <-> 1
2 <-> 0, 3, 4
3 <-> 2, 4
4 <-> 2, 3, 6
5 <-> 6
6 <-> 4, 5
"""
let examplePrograms = programs(from: example)
let groupedExample = groupsOfPrograms(programs: examplePrograms)
assert(examplePrograms.count == 7)
assert(examplePrograms[4]?.pipesTo.count == 3)
assert(numberOfProgram(thatCanCommunicateWith: 0, with: groupedExample) == 6)
assert(groupedExample.count == 2)


let inputPrograms = programs(from: input)
let groupedPrograms = groupsOfPrograms(programs: inputPrograms)
let number = numberOfProgram(thatCanCommunicateWith: 0, with: groupedPrograms)
print("Number of programs that can communicate with 0 for 12-1: \(number)")
print("Number of groups of programs for 12-2: \(groupedPrograms.count)")
