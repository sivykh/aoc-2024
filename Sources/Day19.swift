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

private let newlineCode: Int8 = 10 // "\n"
private let commaCode: Int8 = 44 // ","
private let whitespaceCode: Int8 = 32 // " "

struct Day19: AdventDay {
    var data: String
    
    fileprivate var entities: Input19 {
        let input = data.utf8CString
        var i = 0, j = 0
        var patterns: [[Int8]] = [[]]
        while input[i] != newlineCode {
            if input[i] != whitespaceCode && input[i] != commaCode {
                patterns[j].append(input[i])
            } else if input[i] != commaCode {
                patterns.append([])
                j += 1
            }
            i += 1
        }
        i += 2 // two newlines
        j = 0
        var towels: [[Int8]] = [[]]
        while input[i] != 0 {
            if input[i] != newlineCode {
                towels[j].append(input[i])
            } else {
                towels.append([])
                j += 1
            }
            i += 1
        }
        if towels.last?.isEmpty == true {
            towels.removeLast()
        }
        return Input19(patterns: patterns.map(Pattern19.init(colors:)), towels: towels.map(Towel19.init(pattern:)))
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
        var res = 0
        for towel in input.towels {
            var dp = [Int](repeating: 0, count: towel.pattern.count + 1)
            dp[0] = 1
            for i in 1...towel.pattern.count {
                for pattern in input.patterns where i >= pattern.colors.count {
                    var good = true
                    let offset = i - pattern.colors.count
                    for j in 0..<pattern.colors.count where towel.pattern[offset + j] != pattern.colors[j] {
                        good = false
                        break
                    }
                    if good {
                        dp[i] += dp[offset]
                    }
                }
            }
            res += dp[towel.pattern.count]
        }
        return res
    }
}
