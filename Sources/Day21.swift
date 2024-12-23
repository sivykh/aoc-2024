import Algorithms
import Collections

private struct CacheKey21: Hashable {
    let depth: Int
    let buttons: [Int]
}

struct Day21: AdventDay {
    var data: String
    
    var entities: [[Int]] {
        data.components(separatedBy: "\n").compactMap {
            $0.isEmpty ? nil : $0.utf8CString.dropLast().map({ Int($0 - 48) })
        }
    }
    
    func part1() -> Any {
        common(robotsNumber: 3, multiplyByLength: true)
    }
    
    func part2() -> Any {
        common(robotsNumber: 26, multiplyByLength: true)
    }
    
    private func common(robotsNumber: Int, multiplyByLength: Bool) -> Int {
        let paths = buildPaths()
        var cache: [CacheKey21: Int] = [:]
        
        func count(depth: Int, buttons: [Int]) -> Int {
            guard depth > 0 else {
                return buttons.count
            }
            let cacheKey = CacheKey21(depth: depth, buttons: buttons)
            if let cachedValue = cache[cacheKey] {
                return cachedValue
            }
            let buttonACode = 17
            var prev = buttonACode
            var res = 0
            for charCode in buttons {
                var minimum = Int.max
                for path in paths[prev][charCode] {
                    minimum = min(minimum, count(depth: depth - 1, buttons: path + [buttonACode]))
                }
                res += minimum
                prev = charCode
            }
            cache[cacheKey] = res
            return res
        }
        
        var res = 0
        for code in entities {
            let length = count(depth: robotsNumber, buttons: code)
            let number = code[0] * 100 + code[1] * 10 + code[2]
            res += length * (multiplyByLength ? number : 1)
        }
        return res
    }
    
    private func buildPaths() -> [[[[Int]]]] {
        var res: [[[[Int]]]] = .init(
            repeating: .init(
                repeating: [],
                count: 47
            ),
            count: 47
        )
        let nums: [[Int8]] = [
            "789".utf8CString.dropLast().map { $0 - 48 },
            "456".utf8CString.dropLast().map { $0 - 48 },
            "123".utf8CString.dropLast().map { $0 - 48 },
            " 0A".utf8CString.dropLast().map { $0 - 48 }
        ]
        let arrows: [[Int8]] = [
            " ^A".utf8CString.dropLast().map { $0 - 48 },
            "<V>".utf8CString.dropLast().map { $0 - 48 }
        ]
        for pad in [nums, arrows] {
            for r1 in 0..<pad.count {
                for c1 in 0..<pad[r1].count where pad[r1][c1] >= 0 {
                    for r2 in 0..<pad.count {
                        for c2 in 0..<pad[r2].count where pad[r2][c2] >= 0 {
                            let horizontal = [Direction](repeating: c1 < c2 ? .right : .left, count: abs(c2 - c1))
                            let vertical = [Direction](repeating: r1 < r2 ? .down : .up, count: abs(r2 - r1))
                            var current: [[Direction]] = [
                                horizontal + vertical,
                                vertical + horizontal
                            ]
                            for j in stride(from: 1, through: 0, by: -1) {
                                var cell = Cell(r1, c1)
                                for dir in current[j] {
                                    cell = cell + dir.move
                                    if pad[cell.r][cell.c] < 0 {
                                        current.remove(at: j)
                                        break
                                    }
                                }
                            }
                            res[Int(pad[r1][c1])][Int(pad[r2][c2])] = current.map({ $0.map({ $0.code }) })
                        }
                    }
                }
            }
        }
        return res
    }
}

private extension Direction {
    var code: Int {
        Int(String(self.rawValue).utf8CString[0] - 48)
    }
}
