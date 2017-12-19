//: Playground - noun: a place where people can play

import Foundation

let input = 328

func spinlock(steps: Int, iterations: Int = 2017) -> Int {
    var memory = [0]
    var index = 0
    for iteration in 1...iterations {
        index = ((index + steps) % iteration) + 1
        memory.insert(iteration, at: index)
    }
    return memory[index+1 % memory.count]
}

assert(spinlock(steps: 3) == 638)
print("Value right after 2017 for 17-1: \(spinlock(steps: input))")

func firstValueAfter0(steps: Int, iterations: Int = 50000000) -> Int? {
    var index = 0
    var value: Int?
    for iteration in 1...iterations {
        index = ((index + steps) % iteration) + 1
        if index == 1 {
            value = iteration
        }
    }
    return value
}

print("Value right after 0 for 17-2: \(firstValueAfter0(steps: input))")
