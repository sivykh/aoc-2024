import Algorithms

struct Day06: AdventDay {
    var data: String
    
    var entities: (m: Int, n: Int, (row: Int, col: Int), obstructions: [Bool]) {
        let grid = data.split(separator: "\n").map {
            Array($0)
        }
        
        let m = grid.count
        let n = grid[0].count

        var obstructions = [Bool](repeating: false, count: m * n)
        var start = (row: 0, col: 0)
        for ij in product(0..<m, 0..<n) {
            obstructions[ij.0 * n + ij.1] = grid[ij.0][ij.1] == "#"
            if grid[ij.0][ij.1] == "^" {
                start = ij
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
        for ij in product(0..<m, 0..<n) {
            guard !obstructions[ij.0 * n + ij.1] else {
                continue
            }
            obstructions[ij.0 * n + ij.1] = true
            res += calc(m: m, n: n, start: start, obstructions: obstructions).cycle ? 1 : 0
            obstructions[ij.0 * n + ij.1] = false
        }
        return res
    }
    
    private func calc(m: Int, n: Int, start: (row: Int, col: Int), obstructions: [Bool]) -> (distinct: Int, cycle: Bool) {
        let moves = [[-1, 0], [0, 1], [1, 0], [0, -1]]
        var current = start
        var distinct = 0
        var visited = [Bool](repeating: false, count: m * n * moves.count)
        var moveIndex = 0
        while 0..<m ~= current.row, 0..<n ~= current.col {
            let visitedIndex0 = current.row * n * moves.count + current.col * moves.count
            let visitedIndex = visitedIndex0 + moveIndex
            if visited[visitedIndex] {
                return (distinct, true)
            }
            distinct += visited[visitedIndex0..<(visitedIndex0 + moves.count)].contains(true) ? 0 : 1
            visited[visitedIndex] = true
            var next = (row: current.row + moves[moveIndex][0], col: current.col + moves[moveIndex][1])
            while 0..<m ~= next.row && 0..<n ~= next.col && obstructions[next.row * n + next.col] {
                moveIndex = (moveIndex + 1) % moves.count
                next = (row: current.row + moves[moveIndex][0], col: current.col + moves[moveIndex][1])
            }
            current = next
        }
        return (distinct, false)
    }
}
