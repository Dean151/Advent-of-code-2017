//: Playground - noun: a place where people can play

import Foundation

let input = "hxtvlmkl"

extension Character {
    func hexToBinary() -> String {
        switch self {
        case "0":
            return "...."
        case "1":
            return "...#"
        case "2":
            return "..#."
        case "3":
            return "..##"
        case "4":
            return ".#.."
        case "5":
            return ".#.#"
        case "6":
            return ".##."
        case "7":
            return ".###"
        case "8":
            return "#..."
        case "9":
            return "#..#"
        case "a":
            return "#.#."
        case "b":
            return "#.##"
        case "c":
            return "##.."
        case "d":
            return "##.#"
        case "e":
            return "###."
        case "f":
            return "####"
        default:
            return ""
        }
    }
}

extension String {
    func hexToBinary() -> String {
        var binary = ""
        
        for character in self {
            binary += character.hexToBinary()
        }
        
        return binary
    }
}

assert("a0c2017".hexToBinary() == "#.#.....##....#........#.###")

func numberSquareUsed(for input: String) -> Int {
    var squares = 0
    
    for row in 0..<128 {
        squares += knotHash(for: input.appending("-\(row)")).hexToBinary().reduce(0, { $0 + ($1 == "#" ? 1 : 0) })
    }
    
    return squares
}

let example = "flqrgnkx"
assert(numberSquareUsed(for: example) == 8108)

print("Number of squares used for 14-1: \(numberSquareUsed(for: input))")
