import Algorithms

struct Day02: AdventDay {
    // Save your data in a corresponding text file in the `Data` directory.
    var data: String

    var entities: [[Int]] {
        data.split(separator: "\n").map {
            $0.split(separator: "   ").compactMap { Int($0) }
        }
    }

    func part1() -> Any {
        let input = entities


        return 0
    }

    func part2() -> Any {
        let input = entities


        return 0
    }
}
