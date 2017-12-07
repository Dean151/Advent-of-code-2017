//: Playground - noun: a place where people can play

import Foundation

// Get the puzzle input
let url = Bundle.main.url(forResource: "input", withExtension: "txt")!
let input = try! String.init(contentsOf: url)

// Make a tree structure
class Program {
    let name: String
    let weight: Int
    
    var parent: Program?
    var children = [Program]()
    
    init(name: String, weight: Int) {
        self.name = name
        self.weight = weight
    }
    
    static func reconstructTree(input: String) -> Program {
        // Making a list of programs
        var programList = [String: Program]()
        var childrenList = [String: [String]]()
        
        // Recreating all of the programs
        let programs = input.components(separatedBy: .newlines)
        for program in programs {
            let components = program.components(separatedBy: .whitespaces)
            if components.count < 2 {
                continue
            }
            
            var weightString = components[1]
            weightString.removeFirst()
            weightString.removeLast()
            let weight = Int(weightString)!
            let name = components[0]
            
            programList.updateValue(Program(name: name, weight: weight), forKey: name)
            if components.count > 3 {
                var childrenNames = [String]()
                for index in 3..<components.count {
                    var name = components[index]
                    if name.hasSuffix(",") {
                        // Removing the last comma
                        name.removeLast()
                    }
                    childrenNames.append(name)
                }
                childrenList.updateValue(childrenNames, forKey: name)
            }
        }
        
        // Assigning childrens
        for (name, childAssociation) in childrenList {
            for childName in childAssociation {
                if let parent = programList[name], let child = programList[childName] {
                    parent.children.append(child)
                    child.parent = parent
                }
            }
        }
        
        // Getting most bottoms programs
        let bottoms = programList.filter({ $1.parent == nil })
        
        // We should only have one program !
        assert(bottoms.count == 1)
        
        return bottoms.values.first!
    }
}

// Get the bottom program
func puzzle7_1(tree: Program) -> String {
    return tree.name
}

let example = """
pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)
"""

assert(puzzle7_1(tree: Program.reconstructTree(input: example)) == "tknk")

print("Bottom program for 6-1: \(puzzle7_1(tree: Program.reconstructTree(input: input)))")
