import Algorithms
import Collections

struct Day09: AdventDay {
    var data: String
    // 2333133121414131402
    // 00...111...2...333.44.5555.6666.777.888899
    // 0099811188827773336446555566..............

    var entities: [Int] {
        data.utf8CString.dropLast().map({ Int($0 - 48) })
    }
    
    func part1() -> Any {
        let e = entities
        var input = e.count % 2 == 0 ? e.dropLast() : e
        var lastFileID = input.count / 2
        var lastFileIndex = input.count - 1

        var res = 0, len = 0
        for i in 0..<input.count {
            let thisLen = input[i]
            if i % 2 == 0 {
                for j in 0..<input[i] {
                    res += (len + j) * (i / 2)
                    input[i] -= 1
                }
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
    
    func part2() -> Any {
        let e = entities
        
        return 0
    }
}
