import Algorithms

struct Day06: AdventDay {
    var data: String
    
    var entities: (m: Int, n: Int, (row: Int, col: Int), obstructions: [Bool]) {
        let grid = data.utf8CString.dropLast().split(separator: 10).map {
            Array($0)
        }

        let m = grid.count
        let n = grid[0].count

        var obstructions = [Bool](repeating: false, count: m * n)
        var start = (row: 0, col: 0)
        for ij in product(0..<m, 0..<n) {
            obstructions[ij.0 * n + ij.1] = grid[ij.0][ij.1] == 35
            if grid[ij.0][ij.1] == 94 {
                start = ij
            }
        }
        
        return (m, n, start, obstructions)
    }
    
    func part1() -> Any {
        let (m, n, start, obstructions) = entities
        return calc(m: m, n: n, start: start, obstructions: obstructions).distinct.count
    }

    func part2() async -> Any {
        var (m, n, start, obstructions) = entities
        let res = await withTaskGroup(of: Int.self, returning: Int.self) { group in
            for ij in calc(m: m, n: n, start: start, obstructions: obstructions).distinct {
                obstructions[ij.0 * n + ij.1] = true
                group.addTask { [m, n, start, obstructions] in
                    calc(m: m, n: n, start: start, obstructions: obstructions).cycle ? 1 : 0
                }
                obstructions[ij.0 * n + ij.1] = false
            }
            return await group.reduce(0, +)
        }
        return res
    }

    private func calc(m: Int, n: Int, start: (row: Int, col: Int),
                      obstructions: [Bool]) -> (distinct: [(row: Int, col: Int)], cycle: Bool) {
        let moves = [[-1, 0], [0, 1], [1, 0], [0, -1]]
        var current = start
        var distinct = [(row: Int, col: Int)]()
        var visited = [Int](repeating: 0, count: m * n)
        var moveIndex = 0
        while 0..<m ~= current.row, 0..<n ~= current.col {
            let visitedIndex = current.row * n + current.col
            if visited[visitedIndex] & (1 << moveIndex) > 0 {
                return (distinct, true)
            }
            if visited[visitedIndex] == 0 {
                distinct.append(current)
            }
            visited[visitedIndex] |= (1 << moveIndex)
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
