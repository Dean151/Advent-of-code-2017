//
//  Day4.swift
//  AdventOfCode2017
//
//  Created by Thomas DURAND on 18/12/2018.
//  Copyright © 2018 Thomas DURAND. All rights reserved.
//

import Foundation

class Day4: Day {
    
    static func isPhraseValid(_ phrase: String, excludeAnagrams: Bool = false) -> Bool {
        var words = Set<String>()
        for word in phrase.components(separatedBy: .whitespaces) {
            let comparer = excludeAnagrams ? String(word.sorted()) : word
            if words.contains(comparer) {
                return false
            }
            words.insert(comparer)
        }
        return true
    }
    
    static func run(input: String) {
        let phrases = input.components(separatedBy: .newlines).filter({ !$0.isEmpty })
        
        assert(isPhraseValid("aa bb cc dd ee"))
        assert(isPhraseValid("aa bb cc dd aa") == false)
        assert(isPhraseValid("aa bb cc dd aaa"))
        
        print("Number of phrases valid for 4-1: \(phrases.filter({ isPhraseValid($0) }).count)")
        
        assert(isPhraseValid("abcde fghij", excludeAnagrams: true))
        assert(isPhraseValid("abcde xyz ecdab", excludeAnagrams: true) == false)
        assert(isPhraseValid("a ab abc abd abf abj", excludeAnagrams: true))
        assert(isPhraseValid("iiii oiii ooii oooi oooo", excludeAnagrams: true))
        assert(isPhraseValid("oiii ioii iioi iiio", excludeAnagrams: true) == false)
        
        print("Number of phrases valid for 4-2: \(phrases.filter({ isPhraseValid($0, excludeAnagrams: true) }).count)")
    }
}
