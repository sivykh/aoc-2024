import Algorithms
import Collections

struct Day10: AdventDay {
    var data: String
    
    func part1() async -> Any {
        await common().part1
    }

    func part2() async -> Any {
        await common().part2
    }
    
    private func common() async -> (part1: Int, part2: Int) {
        let input = data.utf8CString.dropLast().map({ Int($0 - 48) }).split(separator: -38).map { Array($0) }

        @Sendable func dfs(path: [(Int, Int)], row: Int, col: Int, current: inout Set<Cell>) -> Int {
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

        return await withTaskGroup(of: (Int, Int).self, returning: (Int, Int).self) { group in
            for row in 0..<input.count {
                group.addTask {
                    var res1 = 0, res2 = 0
                    for col in 0..<input[row].count {
                        var ends = Set<Cell>()
                        res2 += dfs(path: [], row: row, col: col, current: &ends)
                        res1 += ends.count
                    }
                    return (res1, res2)
                }
            }
            return await group.reduce((0, 0), { ($0.0 + $1.0, $0.1 + $1.1) })
        }
    }
}
