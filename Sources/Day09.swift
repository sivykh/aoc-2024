import Algorithms
import Collections

struct Day09: AdventDay {
    var data: String

    var entities: [Int] {
        data.utf8CString.dropLast().map({ Int($0 - 48) })
    }
    
    // 2333133121414131402
    // 00...111...2...333.44.5555.6666.777.888899
    // 0099811188827773336446555566..............
    func part1() -> Any {
        var input = entities
        var lastFileID = input.count / 2
        var lastFileIndex = input.count - 1

        var res = 0, len = 0
        for i in 0..<input.count where input[i] > 0 {
            let thisLen = input[i]
            if i % 2 == 0 {
                res += (0..<input[i]).reduce(0, { $0 + (len + $1) * (i / 2) })
                input[i] = 0
            } else {
                for j in 0..<input[i] {
                    guard input[lastFileIndex] > 0 else {
                        break
                    }
                    res += (len + j) * lastFileID
                    input[lastFileIndex] -= 1
                    if input[lastFileIndex] == 0 {
                        lastFileIndex -= 2
                        lastFileID -= 1
                    }
                }
            }
            len += thisLen
        }
        return res
    }
    
    // 2333133121414131402
    // 00...111...2...333.44.5555.6666.777.888899
    // 00992111777.44.333....5555.6666.....8888..
    func part2() -> Any {
        let input = entities
        var copy = input
        var res = 0, len = 0

        for i in 0..<copy.count {
            let thisLen = input[i]
            if i % 2 == 0 && copy[i] > 0 {
                res += (0..<copy[i]).reduce(0, { $0 + (len + $1) * (i / 2) })
                copy[i] = 0
            } else {
                var work = true
                var index = 0
                copy[i] = i % 2 != 0 ? copy[i] : input[i]
                while work {
                    work = false
                    for j in stride(from: copy.count - 1, to: i, by: -2) where copy[j] > 0 {
                        if copy[j] <= copy[i] {
                            copy[i] -= copy[j]
                            work = copy[i] > 0
                            res += (0..<copy[j]).reduce(0, { $0 + (len + index + $1) * (j / 2) })
                            index += copy[j]
                            copy[j] = 0
                            break
                        }
                    }
                }
                copy[i] = i % 2 != 0 ? copy[i] : 0
            }
            len += thisLen
        }
        return res
    }
}
