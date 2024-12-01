import Algorithms

struct Day01: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    var entities: [[Int]] {
        data.split(separator: "\n").map {
            $0.split(separator: "   ").compactMap { Int($0) }
        }
    }

    func part1() -> Any {
        let input = entities
        var firstColumn = [Int](repeating: 0, count: input.count)
        var secondColumn = firstColumn
        for i in 0..<input.count {
            firstColumn[i] = input[i][0]
            secondColumn[i] = input[i][1]
        }
        firstColumn.sort()
        secondColumn.sort()

        return zip(firstColumn, secondColumn).reduce(0, { $0 + abs($1.0 - $1.1) })
    }

    func part2() -> Any {
        let input = entities
        var freq = [Int: Int]()
        for row in input {
            freq[row[1], default: 0] += 1
        }

        return input.reduce(0, { $0 + $1[0] * freq[$1[0], default: 0] })
    }
}
