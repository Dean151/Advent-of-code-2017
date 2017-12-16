//: Playground - noun: a place where people can play

import Foundation

enum Move {
    case spin(size: Int)
    case exchange(a: Int, b: Int)
    case partner(a: Character, b: Character)
    
    func perform(on string: String) -> String {
        switch self {
        case .spin(size: let size):
            let index = string.index(string.startIndex, offsetBy: string.count - size)
            return String(string[index..<string.endIndex]) + String(string[string.startIndex..<index])
        case .exchange(a: let a, b: let b):
            return Move.partner(a: string[string.index(string.startIndex, offsetBy: a)], b: string[string.index(string.startIndex, offsetBy: b)]).perform(on: string)
        case .partner(a: let a, b: let b):
            return string.map({ c -> Character in
                if c == a { return b }
                if c == b { return a }
                return c
            }).reduce("", { return $0.appending("\($1)") })
        }
    }
    
    static func from(string: String) -> Move? {
        guard let type = string.first else { return nil }
        
        let nextIndex = string.index(after: string.startIndex)
        let orders = string[nextIndex..<string.endIndex]
        
        switch type {
        case "s":
            guard let size = Int(orders) else { return nil }
            return .spin(size: size)
        case "x":
            let components = orders.components(separatedBy: "/")
            if components.count != 2 { return nil }
            guard let a = Int(components.first!), let b = Int(components.last!) else { return nil }
            return .exchange(a: a, b: b)
        case "p":
            let components = orders.components(separatedBy: "/")
            if components.count != 2 { return nil }
            return .partner(a: components.first!.first!, b: components.last!.first!)
        default:
            return nil
        }
    }
}

func initialString(size: Int) -> String {
    var string = ""
    for i in 0..<size {
        string += Character(Unicode.Scalar(UInt8(97+i))).description
    }
    return string
}

func moves(from input: String) -> [Move] {
    return input.components(separatedBy: ",").flatMap({ Move.from(string: $0.trimmingCharacters(in: .whitespacesAndNewlines)) })
}

extension String {
    func danced(with moves: [Move]) -> String {
        var string = self
        for move in moves {
            string = move.perform(on: string)
        }
        return string
    }
}

assert(initialString(size: 5).danced(with: moves(from: "s1")) == "eabcd", "spin is badly implemented")
assert(initialString(size: 5).danced(with: moves(from: "s1,x3/4")) == "eabdc", "exchange is badly implemented")
assert(initialString(size: 5).danced(with: moves(from: "s1,x3/4,pe/b")) == "baedc", "partners is badly implemented")

let uri = Bundle.main.url(forResource: "input", withExtension: "txt")!
let input = try! String(contentsOf: uri)
let afterDance = initialString(size: 16).danced(with: moves(from: input))
print("String after performing dance for 16-1: \(afterDance)")
