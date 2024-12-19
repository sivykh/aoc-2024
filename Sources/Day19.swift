import Foundation
import Collections

private struct Pattern19 {
    let colors: [Int8]
}

private struct Towel19 {
    let pattern: [Int8]
}

private struct Input19 {
    let patterns: [Pattern19]
    let towels: [Towel19]
}


struct Day19: AdventDay {
    var data: String
    
    fileprivate var entities: Input19 {
        let splitted = data.components(separatedBy: "\n\n")
        let patterns = splitted[0].components(separatedBy: ", ").map { Pattern19(colors: $0.utf8CString.dropLast()) }
        let towels = splitted[1].components(separatedBy: "\n").map { Towel19(pattern: $0.utf8CString.dropLast()) }
        return Input19(patterns: patterns, towels: towels)
    }
    
    func part1() -> Any {
        let input = entities

        func backtrack(towel i: Int, from position: Int) -> Bool {
            let towelPattern = input.towels[i].pattern
            for pattern in input.patterns {
                guard towelPattern.count - position >= pattern.colors.count else {
                    continue
                }
                var good = true
                for j in 0..<pattern.colors.count where input.towels[i].pattern[position + j] != pattern.colors[j] {
                    good = false
                    break
                }
                guard good else {
                    continue
                }
                if towelPattern.count - position == pattern.colors.count {
                    return true
                }
                if backtrack(towel: i, from: position + pattern.colors.count) {
                    return true
                }
            }
            return false
        }

        var res = 0
        for towel in input.towels.enumerated() where backtrack(towel: towel.offset, from: 0) {
            res += 1
        }
        return res
    }
    
    func part2() -> Any {
        let input = entities
        return input.towels.count
    }
}
