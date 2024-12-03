import Algorithms
import Foundation
import Collections

struct Day03: AdventDay {
    var data: String
    
    var entities: [String] {
        data.split(separator: "\n").map({ String($0) })
    }
    
    func part1() -> Any {
        let input = entities

        var res = 0
        for string in input {
            do {
                let regex = try NSRegularExpression(pattern: "mul\\(\\d{1,3},\\d{1,3}\\)")
                let results = regex.matches(in: string, range: NSRange(string.startIndex..., in: string))
                for r in results {
                    let sub = String(string[Range(r.range, in: string)!])
                        .replacingOccurrences(of: "mul(", with: "")
                        .dropLast()
                        .components(separatedBy: ",")
                    if sub.count > 1, let a = Int(sub[0]), let b = Int(sub[1]) {
                        res += a * b
                    }
                }
            } catch let error {
                print("invalid regex: \(error.localizedDescription)")
            }
        }
        return res
    }
    
    func part2() -> Any {
        let input = entities

        var res = 0
        var enable = true
        for string in input {
            do {
                let regex = try NSRegularExpression(pattern: "mul\\(\\d{1,3},\\d{1,3}\\)")
                let regexDo = try NSRegularExpression(pattern: "do\\(\\)")
                let regexDont = try NSRegularExpression(pattern: "don\\'t\\(\\)")

                let results = regex.matches(in: string, range: NSRange(string.startIndex..., in: string))
                let resultsDo = regexDo.matches(in: string, range: NSRange(string.startIndex..., in: string))
                let resultsDont = regexDont.matches(in: string, range: NSRange(string.startIndex..., in: string))

                let doRanges = resultsDo.compactMap({ Range($0.range, in: string) })
                let dontRanges = resultsDont.compactMap({ Range($0.range, in: string) })
                var validRanges = [Range<String.Index>]()

                if dontRanges.isEmpty {
                    validRanges = [Range(uncheckedBounds: (string.startIndex, string.endIndex))]
                } else {
                    var start = enable ? string.startIndex : (doRanges.isEmpty ? string.endIndex : doRanges[0].lowerBound)
                    var i = enable ? 0 : 1, j = 0
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
                    enable = j == dontRanges.count
                    if enable {
                        validRanges.append(Range(uncheckedBounds: (start, string.endIndex)))
                    }
                }

                for r in results {
                    guard let subRange = Range(r.range, in: string) else {
                        continue
                    }
                    guard validRanges
                        .contains(where: { $0.lowerBound <= subRange.lowerBound && $0.upperBound >= subRange.upperBound })
                    else {
                        continue
                    }
                    let sub = String(string[subRange])
                        .replacingOccurrences(of: "mul(", with: "")
                        .dropLast()
                        .components(separatedBy: ",")
                    if sub.count > 1, let a = Int(sub[0]), let b = Int(sub[1]) {
                        res += a * b
                    }
                }
            } catch let error {
                print("invalid regex: \(error.localizedDescription)")
            }
        }
        return res
    }
}
