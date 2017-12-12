//: Playground - noun: a place where people can play

import Foundation

let url = Bundle.main.url(forResource: "input", withExtension: "txt")!
let input = try! String.init(contentsOf: url)

struct Program {
    let pid: Int
    var pipesTo = [Int]()
    
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
assert(examplePrograms.count == 7)
assert(examplePrograms[4]?.pipesTo.count == 3)

func numberOfProgram(thatCanCommunicateWith pid: Int, in programs: [Int: Program], excluding: inout Set<Int>) -> Int {
    guard let program = programs[pid] else {
        return 0
    }
    if excluding.contains(pid) {
        return 0
    }
    
    let pipes = program.pipesTo.filter({ !excluding.contains($0) })
    excluding.insert(program.pid)
    return pipes.reduce(1, { $0 + numberOfProgram(thatCanCommunicateWith: $1, in: programs, excluding: &excluding) })
}

var exampleExcluding = Set<Int>()
let exampleResult = numberOfProgram(thatCanCommunicateWith: 0, in: examplePrograms, excluding: &exampleExcluding)
assert(exampleResult == 6)

var programExcluding = Set<Int>()
let inputPrograms = programs(from: input)
print("Number of programs that can communicate with 0 for 12-1: \(numberOfProgram(thatCanCommunicateWith: 0, in: inputPrograms, excluding: &programExcluding))")
