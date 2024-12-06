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
        var oLines = [[Int]](repeating: [], count: m)
        var oCols = [[Int]](repeating: [], count: n)
        var current = (row: 0, col: 0)
        for i in 0..<m {
            for j in 0..<n {
                obstructions[i][j] = grid[i][j] == "#"
                if grid[i][j] == "^" {
                    current = (i, j)
                }
                if obstructions[i][j] {
                    oLines[i].append(j)
                    oCols[j].append(i)
                }
            }
        }

        var res = 0
        let moves = [[-1, 0], [0, 1], [1, 0], [0, -1]]
        var moveIndex = 0
        while 0..<m ~= current.row, 0..<n ~= current.col {
            var next = (row: current.row + moves[moveIndex][0], col: current.col + moves[moveIndex][1])
            while 0..<m ~= next.row && 0..<n ~= next.col && obstructions[next.row][next.col] {
                moveIndex = (moveIndex + 1) % moves.count
                next = (row: current.row + moves[moveIndex][0], col: current.col + moves[moveIndex][1])
            }
            var cycle = true
            if current != next {

            }
            current = next
        }
        return res
    }

    func bsearch(x: Int, in array: [Int]) -> Int {
        var l = 0, r = array.count
        if x < array[0] { return 0 }
        if x > array.last! { return array.count }
        while l <= r {
            let m = (l + r) / 2
            if array[m] < x {
                l = m + 1
            } else {
                r = m - 1
            }
        }
        return l
    }
}
