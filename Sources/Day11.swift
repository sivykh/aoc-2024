import Foundation
import Collections

struct Day11: AdventDay {
    var data: String
    
    var entities: [Int] {
        data.components(separatedBy: " ").compactMap({ Int($0) })
    }
    
    func part1() -> Any {
        var input = entities
        for _ in 0..<25 {
            var new = [Int]()
            for j in 0..<input.count {
                let n = input[j]
                guard n > 0 else {
                    new.append(1)
                    continue
                }
                let digits = Int(floor(1 + log10(Double(n))))
                if digits % 2 == 0 {
                    let base = Int(pow(10, Double(digits / 2)))
                    new.append(n / base)
                    new.append(n % base)
                } else {
                    new.append(n * 2024)
                }
            }
            input = new
        }
        return input.count
    }
    
    func part2() -> Any {
        var input = entities
        for _ in 0..<75 {
            var new = [Int]()
            for j in 0..<input.count {
                let n = input[j]
                guard n > 0 else {
                    new.append(1)
                    continue
                }
                let digits = Int(floor(1 + log10(Double(n))))
                if digits % 2 == 0 {
                    let base = Int(pow(10, Double(digits / 2)))
                    new.append(n / base)
                    new.append(n % base)
                } else {
                    new.append(n * 2024)
                }
            }
            input = new
        }
        return input.count
    }
}
