import Algorithms
import Collections

struct Day04: AdventDay {
    var data: String
    
    var entities: [[Character]] {
        data.split(separator: "\n").map {
            Array($0)
        }
    }
    
    func part1() -> Any {
        let search = Array("XMAS")
        let grid = entities
        let moves = [[1, 1], [1, 0], [1, -1], [0, 1], [0, -1], [-1, 1], [-1, 0], [-1, -1]]

        var res = 0
        for row in 0..<grid.count {
            for col in 0..<grid[row].count {
                guard grid[row][col] == search.first else {
                    continue
                }
                for move in moves {
                    var build = 1
                    for i in 1..<search.count {
                        let nr = row + move[0] * i
                        let nc = col + move[1] * i
                        guard 0..<grid.count ~= nr, 0..<grid[row].count ~= nc else {
                            break
                        }
                        guard search[i] == grid[nr][nc] else {
                            break
                        }
                        build += 1
                    }
                    res += build == search.count ? 1 : 0
                }
            }
        }
        return res
    }
    
    func part2() -> Any {
        let grid = entities

        var res = 0
        for row in 1..<(grid.count - 1) {
            for col in 1..<(grid[row].count - 1) {
                guard grid[row][col] == "A" else {
                    continue
                }
                let m = [
                    [[-1, -1], [-1, 1]],
                    [[-1, 1], [1, 1]],
                    [[1, 1], [1, -1]],
                    [[1, -1], [-1, -1]]
                ]
                let s = [
                    [[1, -1], [1, 1]],
                    [[1, -1], [-1, -1]],
                    [[-1, -1], [-1, 1]],
                    [[-1, 1], [1, 1]]
                ]
                for j in 0..<4 {
                    guard grid[row + m[j][0][0]][col + m[j][0][1]] == "M",
                          grid[row + m[j][1][0]][col + m[j][1][1]] == "M",
                          grid[row + s[j][0][0]][col + s[j][0][1]] == "S",
                          grid[row + s[j][1][0]][col + s[j][1][1]] == "S"
                    else {
                        continue
                    }
                    res += 1
                }
            }
        }
        return res
    }
}
