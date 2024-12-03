import Algorithms
import Foundation
import Collections

struct Day03: AdventDay {
    var data: String
    
    var entities: String {
        data.replacingOccurrences(of: "\n", with: "")
    }
    
    func part1() -> Any {
        calc(string: entities)
    }
    
    func part2() -> Any {
        let string = entities
        var validRanges = [Range<String.Index>]()
        
        let regexDo = try! NSRegularExpression(pattern: "do\\(\\)")
        let regexDont = try! NSRegularExpression(pattern: "don\\'t\\(\\)")
        
        let resultsDo = regexDo.matches(in: string, range: NSRange(string.startIndex..., in: string))
        let resultsDont = regexDont.matches(in: string, range: NSRange(string.startIndex..., in: string))
        
        let doRanges = resultsDo.compactMap({ Range($0.range, in: string) })
        let dontRanges = resultsDont.compactMap({ Range($0.range, in: string) })
        
        if dontRanges.isEmpty {
            validRanges = [Range(uncheckedBounds: (string.startIndex, string.endIndex))]
        } else {
            var start = string.startIndex
            var i = 0, j = 0
            while j < dontRanges.count {
                let up = dontRanges[j].upperBound
                defer {
                    j += 1
                }
                guard up > start else {
                    continue
                }
                validRanges.append(Range(uncheckedBounds: (start, up)))
                while i < doRanges.count, doRanges[i].lowerBound < up {
                    i += 1
                }
                if i == doRanges.count {
                    j -= 1
                    break
                }
                start = doRanges[i].lowerBound
            }
            if j == dontRanges.count {
                validRanges.append(Range(uncheckedBounds: (start, string.endIndex)))
            }
        }
        return calc(string: string, validRanges: validRanges)
    }

    func calc(string: String, validRanges: [Range<String.Index>]? = nil) -> Int {
        let validRanges = validRanges ?? [Range(uncheckedBounds: (string.startIndex, string.endIndex))]
        
        var res = 0
        let regex = try! NSRegularExpression(pattern: "mul\\(\\d{1,3},\\d{1,3}\\)")
        let results = regex.matches(in: string, range: NSRange(string.startIndex..., in: string))
        
        for r in results {
            guard let subRange = Range(r.range, in: string) else {
                continue
            }
            guard validRanges
                .contains(where: { $0.lowerBound <= subRange.lowerBound && $0.upperBound >= subRange.upperBound })
            else {
                continue
            }
            let sub = String(string[Range(r.range, in: string)!])
                .replacingOccurrences(of: "mul(", with: "")
                .dropLast()
                .components(separatedBy: ",")
            if sub.count > 1, let a = Int(sub[0]), let b = Int(sub[1]) {
                res += a * b
            }
        }
        
        return res
    }
}
