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
    
    func reset() {
        currentRange = 0
        goingDown = true
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

func severity(for firewall: [Scanner?], delayedBy delay: Int = 0) -> (severity: Int, gotCaught: Bool) {
    var severity = 0
    var currentDepth = -delay
    var gotCaught = false
    
    // Reset scanners
    firewall.forEach({ $0?.reset() })
    
    while currentDepth < firewall.count {
        // We get in currentDepth
        if currentDepth >= 0, let scanner = firewall[currentDepth], scanner.currentRange == 0 {
            // We got caught !
            severity += scanner.depth * scanner.range
            gotCaught = true
        }
        
        // Scanners move then
        firewall.forEach({ $0?.move() })
        
        // We increment currentDepth
        currentDepth += 1
    }
    
    return (severity, gotCaught)
}

let example = """
0: 3
1: 2
4: 4
6: 4
"""
let exampleScanners = firewall(for: example)
assert(severity(for: exampleScanners).severity == 24)

let inputScanners = firewall(for: input)
print("Severity for 13-1: \(severity(for: inputScanners).severity)")

func minimumDelay(toGetThrough firewall: [Scanner?]) -> Int {
    // Since "0: 3", delay = 0 is not an option
    // As "1: 2", delay = 1 is not an option either
    var delay = 2
    var gotCaught = false
    
    repeat {
        let result = severity(for: firewall, delayedBy: delay)
        gotCaught = result.gotCaught
        print("\(delay) - \(gotCaught) - \(result.severity)")
        if gotCaught {
            // Since "1: 2" for example and input, delay will be pair
            delay += 2
            // Since "0: 3" and "6: 4"
            while delay % 4 == 0 || delay-6 % 12 == 0 {
                delay += 2
            }
        }
    } while gotCaught
    
    return delay
}

assert(minimumDelay(toGetThrough: exampleScanners) == 10)
print("Delay to get through for 13-2: \(minimumDelay(toGetThrough: inputScanners))")
