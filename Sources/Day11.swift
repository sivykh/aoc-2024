import Foundation
import Collections

struct Day11: AdventDay {
    var data: String
    
    var entities: [Int: Int] {
        let all = data.components(separatedBy: " ").compactMap({ Int($0) })
        return all.reduce(into: [:], { $0[$1, default: 0] += 1 })
    }
    
    func part1() -> Any {
        common(blinks: 25)
    }
    
    func part2() -> Any {
        common(blinks: 75)
    }
    
    private func common(blinks: Int) -> Int {
        var input = entities
        for _ in 0..<blinks {
            var new = [Int: Int]()
            for pair in input {
                let (n, count) = pair
                guard n > 0 else {
                    new[1, default: 0] += count
                    continue
                }
                let digits = Int(floor(1 + log10(Double(n))))
                if digits % 2 == 0 {
                    let base = (0..<(digits / 2)).reduce(1, { x, _ in 10 * x })
                    new[n / base, default: 0] += count
                    new[n % base, default: 0] += count
                } else {
                    new[2024 * n, default: 0] += count
                }
            }
            input = new
        }
        return input.reduce(0, { $0 + $1.value })
    }
}
