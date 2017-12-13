//: Playground - noun: a place where people can play

import Foundation

let url = Bundle.main.url(forResource: "input", withExtension: "txt")!
let input = try! String(contentsOf: url)

class Scanner {
    let depth: Int
    let range: Int
    
    var currentRange = 0
    var goingDown = true
    
    func move() {
        if currentRange == range-1 {
            goingDown = false
        }
        if currentRange == 0 {
            goingDown = true
        }
        
        if goingDown {
            currentRange += 1
        } else {
            currentRange -= 1
        }
    }
    
    init(depth: Int, range: Int) {
        self.depth = depth
        self.range = range
    }
    
    convenience init?(string: String) {
        let components = string.components(separatedBy: ": ")
        guard let depth = components.first.flatMap({ Int($0) }) else {
            return nil
        }
        guard let range = components.last.flatMap({ Int($0) }) else {
            return nil
        }
        self.init(depth: depth, range: range)
    }
}

func firewall(for input: String) -> [Scanner?] {
    var scanners = [Scanner]()
    var max = 0
    for line in input.components(separatedBy: .newlines) {
        if let scanner = Scanner(string: line) {
            scanners.append(scanner)
            max = Swift.max(max, scanner.depth)
        }
    }
    
    var firewall = [Scanner?](repeating: nil, count: max + 1)
    for scanner in scanners {
        firewall[scanner.depth] = scanner
    }
    
    return firewall
}

func severity(for firewall: [Scanner?]) -> Int {
    var severity = 0
    var currentDepth = 0
    
    while true {
        // We get in currentDepth
        if let scanner = firewall[currentDepth], scanner.currentRange == 0 {
            // We got caught !
            severity += scanner.depth * scanner.range
        }
        
        // Scanners move then
        firewall.forEach({ $0?.move() })
        
        // We increment currentDepth
        currentDepth += 1
        
        if currentDepth >= firewall.count {
            break
        }
    }
    
    return severity
}

let example = """
0: 3
1: 2
4: 4
6: 4
"""
let exampleScanners = firewall(for: example)
assert(severity(for: exampleScanners) == 24)

let inputScanners = firewall(for: input)
print("Severity for 13-1: \(severity(for: inputScanners))")
