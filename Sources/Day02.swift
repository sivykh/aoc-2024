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
        let input = entities
        var res = 0
        for row in input {
            if !(1...3 ~= abs(row[0] - row[1])) {
                continue
            }
            let d = row[0] > row[1]
            res += 1
            for j in 2..<row.count where d != (row[j - 1] > row[j]) || !(1...3 ~= abs(row[j - 1] - row[j])) {
                res -= 1
                break
            }
        }

        return res
    }

    func part2() -> Any {
        let input = entities
        var res = 0
        for row in input {
            var good = 1
            if good >= 0 {
                res += 1
            }
        }

        return res
    }
}
