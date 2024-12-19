import Algorithms
import Collections

struct Day19: AdventDay {
    var data: String
    
    var entities: [[Int]] {
        data.split(separator: "\n\n").map {
            $0.split(separator: "\n").compactMap { Int($0) }
        }
    }
    
    func part1() -> Any {
        0
    }
    
    func part2() -> Any {
        0
    }
}
