//: Playground - noun: a place where people can play

import Foundation

let url = Bundle.main.url(forResource: "input", withExtension: "txt")!
let input = try! String(contentsOf: url)

struct Scanner {
    let depth: Int
    let range: Int
    
    init?(string: String) {
        let components = string.components(separatedBy: ": ")
        guard let depth = components.first.flatMap({ Int($0) }) else {
            return nil
        }
        guard let range = components.last.flatMap({ Int($0) }) else {
            return nil
        }
        self.depth = depth
        self.range = range
    }
    
    var period: Int {
        return (range - 1) * 2
    }
    
    func doCatch(with delay: Int) -> Bool {
        return (depth+delay) % period == 0
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
    
    for scanner in firewall where scanner != nil {
        if scanner!.doCatch(with: 0) {
            // We got caught !
            severity += scanner!.depth * scanner!.range
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

func minimumDelay(toGetThrough firewall: [Scanner?]) -> Int {
    var delay = 0
    
    whileLoop: while true  {
        for scanner in firewall where scanner != nil {
            if scanner!.doCatch(with: delay) {
                // Next iteration
                delay += 1
                continue whileLoop
            }
        }
        // We got through!
        break
    }
    
    return delay
}

assert(minimumDelay(toGetThrough: exampleScanners) == 10)
print("Delay to get through for 13-2: \(minimumDelay(toGetThrough: inputScanners))")
