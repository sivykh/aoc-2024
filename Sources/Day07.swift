import Algorithms
import Collections
import Foundation

struct Day07: AdventDay {
    var data: String
    
    var entities: [(result: Int, numbers: [Int])] {
        data.split(separator: "\n").map {
            let splitted = $0.split(separator: ":")
            return (
                Int(splitted[0])!,
                splitted[1]
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .split(separator: " ")
                    .compactMap({ Int(String($0)) })
            )
        }
    }
    
    func part1() -> Any {
        entities.reduce(0, { $0 + (isGood(value: $1.result, numbers: $1.numbers, concat: false) ? $1.result : 0) })
    }
    
    func part2() -> Any {
        entities.reduce(0, { $0 + (isGood(value: $1.result, numbers: $1.numbers, concat: true) ? $1.result : 0) })
    }

    private func isGood(value: Int, numbers: [Int], concat: Bool) -> Bool {
        if numbers[0] > value {
            return false
        }
        guard numbers.count > 2 else {
            return value == numbers[0] + numbers[1]
                || value == numbers[0] * numbers[1]
                || (concat && value == Int(pow(10, floor(1 + log10(Double(numbers[1]))))) * numbers[0] + numbers[1])
        }
        let tail = Array(numbers[2...])
        if isGood(value: value, numbers: [numbers[0] * numbers[1]] + tail, concat: concat) {
            return true
        }
        if isGood(value: value, numbers: [numbers[0] + numbers[1]] + tail, concat: concat) {
            return true
        }
        if concat {
            return isGood(value: value, 
                          numbers: [Int(pow(10, floor(1 + log10(Double(numbers[1]))))) * numbers[0] + numbers[1]] + tail,
                          concat: concat)
        }
        return false
    }
}
