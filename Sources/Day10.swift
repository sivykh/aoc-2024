import Algorithms
import Collections

struct Day10: AdventDay {
    var data: String
    
    var entities: [[Int]] {
        data.utf8CString.dropLast().map({ Int($0 - 48) }).split(separator: -38).map { Array($0) }
    }
    
    func part2() -> Any {
        let input = entities

        func dfs(search: Int, row: Int, col: Int) -> Int {
            guard 0..<input.count ~= row, 0..<input[row].count ~= col, search == input[row][col] else {
                return 0
            }
            guard search < 9 else {
                return 1
            }
            return dfs(search: search + 1, row: row + 1, col: col)
                + dfs(search: search + 1, row: row - 1, col: col)
                + dfs(search: search + 1, row: row, col: col + 1)
                + dfs(search: search + 1, row: row, col: col - 1)
        }

        var res = 0
        for row in 0..<input.count {
            for col in 0..<input[row].count {
                res += dfs(search: 0, row: row, col: col)
            }
        }

        return res
    }
    
    func part1() -> Any {
        let input = entities

        func dfs(path: [(Int, Int)], row: Int, col: Int, current: inout Set<Cell>) {
            guard 0..<input.count ~= row, 0..<input[row].count ~= col, path.count == input[row][col] else {
                return
            }
            guard path.count < 9 else {
                current.insert(.init(row, col))
                return
            }
            let path = path + [(row, col)]
            dfs(path: path, row: row + 1, col: col, current: &current)
            dfs(path: path, row: row - 1, col: col, current: &current)
            dfs(path: path, row: row, col: col + 1, current: &current)
            dfs(path: path, row: row, col: col - 1, current: &current)
        }

        var res = 0
        for row in 0..<input.count {
            for col in 0..<input[row].count {
                var ends = Set<Cell>()
                dfs(path: [], row: row, col: col, current: &ends)
                res += ends.count
            }
        }

        return res
    }
}
