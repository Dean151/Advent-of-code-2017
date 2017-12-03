//: Playground - noun: a place where people can play

let input = 347991

/**
 37d  36l  35l  34l  33l  32l  31l
 38d  17d  16l  15l  14l  13l  30u
 39d  18d   5d   4l   3l  12u  29u  ^
 40d  19d   6d   1r   2u  11u  28u  |
 41d  20d   7r   8r   9r  10u  27u ...
 42d  21r  22r  23r  24r  25r  26u ...
 43r  44r  45r  46r  47r  48r   -> ...
 */

enum Direction {
    case right, up, left, down
    
    func move(from coordinates: (x: Int, y: Int)) -> (x: Int, y: Int) {
        switch self {
        case .right:
            return (x: coordinates.x + 1, y: coordinates.y)
        case .up:
            return (x: coordinates.x, y: coordinates.y + 1)
        case .left:
            return (x: coordinates.x - 1, y: coordinates.y)
        case .down:
            return (x: coordinates.x, y: coordinates.y - 1)
        }
    }
    
    static func from(turns: Int) -> Direction {
        switch turns % 4 {
        case 0:
            return .right
        case 1:
            return .up
        case 2:
            return .left
        case 3:
            return .down
        default:
            fatalError("cannot append")
        }
    }
}

func coordinate(for number: Int) -> (x: Int, y:Int) {
    guard number > 0 else {
        fatalError("number cannot be under 1")
    }
    
    var position = (x: 0, y: 0)
    var n = 0
    var turns = 0
    
    while n < number-1 {
        let length = (turns / 2) + 1
        for _ in 0..<length {
            if n == number-1 {
                break
            }
            n += 1
            position = Direction.from(turns: turns).move(from: position)
        }
        turns += 1
    }
    
    return position
}

func puzzle3_1(input: Int) -> Int {
    let coordinates = coordinate(for: input)
    return abs(coordinates.x) + abs(coordinates.y)
}

assert(puzzle3_1(input: 1) == 0)
assert(puzzle3_1(input: 12) == 3)
assert(puzzle3_1(input: 23) == 2)
assert(puzzle3_1(input: 1024) == 31)

print("Distance for 3-1: \(puzzle3_1(input: input))")
