import Algorithms
import Foundation
import Collections

struct Day03: AdventDay {
    var data: String
    
    var entities: String {
        data.replacingOccurrences(of: "\n", with: "")
    }
    
    func part1() -> Any {
        var string = entities

        var res = 0
        let regex = /mul\((?<a>\d{1,3}),(?<b>\d{1,3})\)/
        
        while let match = try! regex.firstMatch(in: string) {
            if let a = Int(match.output.a), let b = Int(match.output.b) {
                res += a * b
            }
            string = String(string[match.range.upperBound...])
        }
        return res
    }
    
    func part2() -> Any {
        var string = entities
        
        var res = 0
        var enabled = true
        let regex = /mul\((?<a>\d{1,3}),(?<b>\d{1,3})\)|(?<c>do)\(\)|(?<d>don't)\(\)/
        
        while let match = try! regex.firstMatch(in: string) {
            defer {
                string = String(string[match.range.upperBound...])
            }
            guard match.output.c == nil && match.output.d == nil else {
                enabled = match.output.d == nil
                continue
            }
            if enabled, let a = Int(match.output.a!), let b = Int(match.output.b!) {
                res += a * b
            }
        }
        return res
    }
}
