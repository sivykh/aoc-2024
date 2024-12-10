import Algorithms
import Collections

struct Day10: AdventDay {
    var data: String
    
    func part1() -> Any {
        common().part1
    }

    func part2() -> Any {
        common().part2
    }
    
    private func common() -> (part1: Int, part2: Int) {
        let input = data.utf8CString.dropLast().map({ Int($0 - 48) }).split(separator: -38).map { Array($0) }

        func dfs(path: [(Int, Int)], row: Int, col: Int, current: inout Set<Cell>) -> Int {
            guard 0..<input.count ~= row, 0..<input[row].count ~= col, path.count == input[row][col] else {
                return 0
            }
            guard path.count < 9 else {
                current.insert(.init(row, col))
                return 1
            }
            let path = path + [(row, col)]
            return dfs(path: path, row: row + 1, col: col, current: &current)
                + dfs(path: path, row: row - 1, col: col, current: &current)
                + dfs(path: path, row: row, col: col + 1, current: &current)
                + dfs(path: path, row: row, col: col - 1, current: &current)
        }

        var res1 = 0, res2 = 0
        for row in 0..<input.count {
            for col in 0..<input[row].count {
                var ends = Set<Cell>()
                res2 += dfs(path: [], row: row, col: col, current: &ends)
                res1 += ends.count
            }
        }

        return (res1, res2)
    }
}
