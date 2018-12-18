//
//  Day7.swift
//  AdventOfCode2017
//
//  Created by Thomas DURAND on 18/12/2018.
//  Copyright © 2018 Thomas DURAND. All rights reserved.
//

import Foundation

class Day7: Day {
    
    class Program: Equatable, Hashable {
        let name: String
        let weight: Int
        
        var parent: Program?
        var children = [Program]()
        
        var totalWeight: Int {
            return children.reduce(weight, { $0 + $1.totalWeight })
        }
        
        var isBalanced: Bool {
            let weight = children.map({ $0.totalWeight }).sorted()
            return weight.first == weight.last
        }
        
        var findUnbalanced: Program? {
            if isBalanced {
                return nil
            }
            let unbalanced = children.first(where: { !$0.isBalanced })
            return unbalanced?.findUnbalanced ?? children.filter({ $0.totalWeight != expectedChildrenWeight }).first
        }
        
        var expectedChildrenWeight: Int {
            return children.map({ $0.totalWeight }).sorted()[1]
        }
        
        var expectedWeight: Int {
            return parent!.expectedChildrenWeight - children.map({ $0.totalWeight }).reduce(0, +)
        }
        
        init(name: String, weight: Int) {
            self.name = name
            self.weight = weight
        }
        
        static func tree(from lines: [String]) -> Program {
            
            // Recreating all of the programs
            var childrenList = [String: [String]]()
            let programs = lines.compactMap({ line -> Program? in
                let components = line.components(separatedBy: .whitespaces)
                guard components.count >= 2 else {
                    return nil
                }
                
                guard let weight = Int(components[1].dropFirst().dropLast()) else {
                    return nil
                }
                
                let name = components[0]
                
                if components.count > 3 {
                    let children = components.dropFirst(3).map({ return $0.hasSuffix(",") ? String($0.dropLast()) : $0 })
                    childrenList.updateValue(children, forKey: name)
                }
                
                return Program(name: name, weight: weight)
            })
            
            let programList = Dictionary(grouping: programs, by: { $0.name }).mapValues({ $0.first! })
            
            // Assigning childrens
            for (name, childrenNames) in childrenList {
                for childName in childrenNames {
                    if let parent = programList[name], let child = programList[childName] {
                        parent.children.append(child)
                        child.parent = parent
                    }
                }
            }
            
            // Getting most bottoms programs
            let roots = programList.filter({ $1.parent == nil })
            
            // We should only have one program !
            if roots.count != 1 {
                fatalError("More than one program found")
            }
            
            return roots.values.first!
        }
        
        var hashValue: Int {
            return name.hashValue
        }
        
        static func == (lhs: Program, rhs: Program) -> Bool {
            return lhs.name == rhs.name
        }
    }
    
    static func run(input: String) {
        let lines = input.components(separatedBy: .newlines).filter({ !$0.isEmpty })
        
        let example = "pbga (66)\nxhth (57)\nebii (61)\nhavc (66)\nktlj (57)\nfwft (72) -> ktlj, cntj, xhth\nqoyq (66)\npadx (45) -> pbga, havc, qoyq\ntknk (41) -> ugml, padx, fwft\njptl (61)\nugml (68) -> gyxo, ebii, jptl\ngyxo (61)\ncntj (57)"
        assert(Program.tree(from: example.components(separatedBy: .newlines)).name == "tknk")
        
        let tree = Program.tree(from: lines)
        print("Root tree name for Day 7-1 is \(tree.name)")
        
        assert(Program.tree(from: example.components(separatedBy: .newlines)).findUnbalanced?.expectedWeight == 60)
        
        print("Balanced weight for 7-2: \(tree.findUnbalanced!.expectedWeight)")
    }
}
