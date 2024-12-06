import Algorithms
import Collections

struct Day06: AdventDay {
    var data: String
    
    var entities: (m: Int, n: Int, (row: Int, col: Int), [[Bool]]) {
        let grid = data.split(separator: "\n").map {
            Array($0)
        }
        
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
        
        return (m, n, start, obstructions)
    }
    
    func part1() -> Any {
        let (m, n, start, obstructions) = entities
        return calc(m: m, n: n, start: start, obstructions: obstructions).distinct
    }
    
    func part2() -> Any {
        var (m, n, start, obstructions) = entities
        var res = 0
        let moves = [[-1, 0], [0, 1], [1, 0], [0, -1]]

        for i in 0..<m {
            for j in 0..<n {
                guard !obstructions[i][j] else {
                    continue
                }
                obstructions[i][j] = true
                res += calc(m: m, n: n, start: start, obstructions: obstructions).cycle ? 1 : 0
                obstructions[i][j] = false
            }
        }
        return res
    }
    
    private func calc(m: Int, n: Int, start: (row: Int, col: Int), obstructions: [[Bool]]) -> (distinct: Int, cycle: Bool) {
        var current = start
        var distinct = 0
        var visited = [[[Bool]]](repeating: [[Bool]](repeating: [false, false, false, false], count: n), count: m)
        let moves = [[-1, 0], [0, 1], [1, 0], [0, -1]]
        var moveIndex = 0
        while 0..<m ~= current.row, 0..<n ~= current.col {
            if visited[current.row][current.col][moveIndex] {
                return (distinct, true)
            }
            distinct += visited[current.row][current.col].contains(true) ? 0 : 1
            visited[current.row][current.col][moveIndex] = true
            var next = (row: current.row + moves[moveIndex][0], col: current.col + moves[moveIndex][1])
            while 0..<m ~= next.row && 0..<n ~= next.col && obstructions[next.row][next.col] {
                moveIndex = (moveIndex + 1) % moves.count
                next = (row: current.row + moves[moveIndex][0], col: current.col + moves[moveIndex][1])
            }
            current = next
        }
        return (distinct, false)
    }
}
