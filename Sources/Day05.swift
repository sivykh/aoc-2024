import Algorithms
import Collections

struct Day05: AdventDay {
    var data: String
    
    var entities: (order: [[Int]], prints: [[Int]]) {
        let parts = data.split(separator: "\n\n").map {
            $0.split(separator: "\n").map(String.init)
        }
        return (
            parts[0].map({ $0.split(separator: "|").compactMap({ Int(String($0)) }) }),
            parts[1].map({ $0.split(separator: ",").compactMap({ Int(String($0)) }) })
        )
    }
    
    func part1() -> Any {
        partAny(countEquals: true)
    }
    
    func part2() -> Any {
        partAny(countEquals: false)
    }

    func partAny(countEquals: Bool) -> Any {
        let input = entities
        var before = [Int: Set<Int>]()
        for nums in input.order {
            before[nums[0], default: []].insert(nums[1])
        }
        var res = 0
        for line in input.prints {
            let fixed = line.sorted(by: { before[$0]?.contains($1) ?? false })
            if countEquals == (fixed == line) {
                res += fixed[fixed.count / 2]
            }
        }
        return res
    }
}
