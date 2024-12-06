import Algorithms
import Collections

struct Day06: AdventDay {
    var data: String
    
    var entities: [[Character]] {
        data.split(separator: "\n").map {
            Array($0)
        }
    }
    
    func part1() -> Any {
        let grid = entities
        let m = grid.count
        let n = grid[0].count

        var obstructions = [[Bool]](repeating: [Bool](repeating: false, count: n), count: m)
        var visited = [[Bool]](repeating: [Bool](repeating: false, count: n), count: m)
        var current = (row: 0, col: 0)
        for i in 0..<m {
            for j in 0..<n {
                obstructions[i][j] = grid[i][j] == "#"
                if grid[i][j] == "^" {
                    current = (i, j)
                }
            }
        }
        var res = 0
        let moves = [[-1, 0], [0, 1], [1, 0], [0, -1]]
        var moveIndex = 0
        while 0..<m ~= current.row, 0..<n ~= current.col {
            res += visited[current.row][current.col] ? 0 : 1
            visited[current.row][current.col] = true
            var next = (row: current.row + moves[moveIndex][0], col: current.col + moves[moveIndex][1])
            while 0..<m ~= next.row && 0..<n ~= next.col && obstructions[next.row][next.col] {
                moveIndex = (moveIndex + 1) % moves.count
                next = (row: current.row + moves[moveIndex][0], col: current.col + moves[moveIndex][1])
            }
            current = next
        }
        return res
    }
    
    func part2() -> Any {
        let grid = entities
        let m = grid.count
        let n = grid[0].count

        var obstructions = [[Bool]](repeating: [Bool](repeating: false, count: n), count: m)
        var start = (row: 0, col: 0)
        for i in 0..<m {
            for j in 0..<n {
                obstructions[i][j] = grid[i][j] == "#"
                if grid[i][j] == "^" {
                    start = (i, j)
                }
            }
        }
        var res = 0
        let moves = [[-1, 0], [0, 1], [1, 0], [0, -1]]

        for i in 0..<m {
            for j in 0..<n {
                guard !obstructions[i][j] else {
                    continue
                }
                var current = start
                var visited = [[[Int]]](repeating: [[Int]](repeating: [], count: n), count: m)
                obstructions[i][j] = true
                var moveIndex = 0
                while 0..<m ~= current.row, 0..<n ~= current.col {
                    if visited[current.row][current.col].contains(moveIndex) {
                        res += 1
                        break
                    }
                    visited[current.row][current.col].append(moveIndex)
                    var next = (row: current.row + moves[moveIndex][0], col: current.col + moves[moveIndex][1])
                    while 0..<m ~= next.row && 0..<n ~= next.col && obstructions[next.row][next.col] {
                        moveIndex = (moveIndex + 1) % moves.count
                        next = (row: current.row + moves[moveIndex][0], col: current.col + moves[moveIndex][1])
                    }
                    current = next
                }
                obstructions[i][j] = false
            }
        }
        return res
    }

}
