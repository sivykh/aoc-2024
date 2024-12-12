import Foundation
import Collections

struct Day12: AdventDay {
    var data: String
    
    var entities: [[Int]] {
        data.utf8CString.dropLast().map({ Int($0 - 65) }).split(separator: -55).map { Array($0) }
    }
    
    func part1() -> Any {
        let input = entities
        let m = input.count, n = input[0].count
        let mR = 0..<m, nR = 0..<n
        var visited = [[Bool]](repeating: [Bool](repeating: false, count: n), count: m)
        
        func dfs(_ r: Int, _ c: Int) -> (square: Int, perimeter: Int) {
            let type = input[r][c]
            var s = 1, p = 0
            for move in [[1, 0], [-1, 0], [0, 1], [0, -1]] {
                let newr = r + move[0], newc = c + move[1]
                guard mR ~= newr, nR ~= newc else {
                    p += 1
                    continue
                }
                if !visited[newr][newc], input[newr][newc] == type {
                    visited[newr][newc] = true
                    let result = dfs(newr, newc)
                    s += result.square
                    p += result.perimeter
                } else {
                    p += input[newr][newc] == type ? 0 : 1
                }
            }
            return (s, p)
        }
        
        var res = 0
        for row in 0..<m {
            for col in 0..<n where !visited[row][col] {
                visited[row][col] = true
                let result = dfs(row, col)
                res += result.perimeter * result.square
            }
        }
        return res
    }
    
    func part2() -> Any {
        let input = entities
        let m = input.count, n = input[0].count
        let mR = 0..<m, nR = 0..<n
        let moves = [Cell(1, 0), Cell(-1, 0), Cell(0, 1), Cell(0, -1)]
        let havingCheck = [[3, 4], [3, 4], [1, 2], [1, 2]]

        // first bit - visited OR not
        // second - has a bound at the bottom OR not
        // third - top bound, fourth - right bound, fifth - left bound
        var visited = [[Int]](repeating: [Int](repeating: 0, count: n), count: m)
        
        func bfs(_ row: Int, _ column: Int) -> (square: Int, perimeter: Int) {
            let type = input[row][column]
            var s = 0, p = 0
            var queue = [Cell(row, column)]

            while !queue.isEmpty {
                var next = [Cell]()
                for cell in queue {
                    s += 1

                    // detect which bounds we've already had from neighbours:
                    var having = 0
                    for i in 0..<moves.count where (cell + moves[i]).satisfy(mR, nR) {
                        let new = cell + moves[i]
                        for j in havingCheck[i] where (visited[new.r][new.c] >> j) & 1 == 1 && input[new.r][new.c] == type {
                            having |= 1 << j
                        }
                    }

                    for i in 0..<moves.count {
                        let new = cell + moves[i]
                        if !new.satisfy(mR, nR) || input[new.r][new.c] != type {
                            visited[cell.r][cell.c] |= 1 << (i + 1)
                            // add a new perimeters side only if it's not presented in neighbours:
                            p += 1 - ((having >> (i + 1)) & 1)
                        }
                    }

                    for i in 0..<moves.count where (cell + moves[i]).satisfy(mR, nR) {
                        let new = cell + moves[i]
                        if visited[new.r][new.c] == 0, input[new.r][new.c] == type {
                            visited[new.r][new.c] = 1
                            next.append(new)
                        }
                    }
                }
                queue = next
            }

            return (s, p)
        }
        
        var res = 0
        for row in 0..<m {
            for col in 0..<n where visited[row][col] == 0 {
                visited[row][col] = 1
                let result = bfs(row, col)
                res += result.perimeter * result.square
            }
        }
        return res
    }
}
