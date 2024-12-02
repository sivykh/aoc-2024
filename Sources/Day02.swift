import Algorithms

struct Day02: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    var entities: [[Int]] {
        data.split(separator: "\n").map {
            $0.split(separator: " ").compactMap { Int($0) }
        }
    }

    func part1() -> Any {
        entities.reduce(0, { $0 + (badIndices(row: $1).isEmpty ? 1 : 0) })
    }

    func part2() -> Any {
        let input = entities
        var res = 0
        for row in input {
            let indices = badIndices(row: row)
            if indices.isEmpty {
                res += 1
                continue
            }
            for j in indices {
                var row = row
                row.remove(at: j)
                if badIndices(row: row).isEmpty {
                    res += 1
                    break
                }
            }
        }

        return res
    }

    private func badIndices(row: [Int]) -> [Int] {
        guard 1...3 ~= abs(row[0] - row[1]) else {
            return [0, 1]
        }

        let order = row[0] > row[1]
        guard order == (row[1] > row[2]) else {
            return [0, 1, 2]
        }

        for j in 2..<row.count where order != (row[j - 1] > row[j]) || !(1...3 ~= abs(row[j - 1] - row[j])) {
            return [j - 1, j]
        }
        return []
    }
}
