import Foundation
import Collections

struct Machine {
    // Cell is {x, y}
    let a: Cell, b: Cell, prize: Cell
}

struct Day13: AdventDay {
    var data: String

    func entities(add: Int = 0) -> [Machine] {
        let r = /Button A: X\+(?<ax>\d+), Y\+(?<ay>\d+)\nButton B: X\+(?<bx>\d+), Y\+(?<by>\d+)\nPrize: X=(?<px>\d+), Y=(?<py>\d+)/
        return data.split(separator: "\n\n").map {
            let m = (try! r.firstMatch(in: String($0)))!.output
            return Machine(a: .init(Int(m.ax)!, Int(m.ay)!),
                           b: .init(Int(m.bx)!, Int(m.by)!),
                           prize: .init(Int(m.px)! + add, Int(m.py)! + add))
        }
    }

    func part1() -> Any {
        common(limit: 101)
    }

    func part2() -> Any {
        common(add: 10000000000000)
    }
    
    private func common(add: Int = 0, limit: Int = Int.max) -> Int {
        var res = 0
        for m in entities(add: add) {
            let base = m.a.y * m.b.x - m.a.x * m.b.y
            guard base != 0 else {
                continue
            }
            let bTimesDouble = Double(m.a.y * m.prize.x - m.a.x * m.prize.y) / Double(base)
            guard bTimesDouble >= 0, bTimesDouble == floor(bTimesDouble) else {
                continue
            }
            let bTimes = Int(bTimesDouble)
            let aTimesDouble = Double(m.prize.x - m.b.x * bTimes) / Double(m.a.x)
            guard aTimesDouble >= 0, aTimesDouble == floor(aTimesDouble) else {
                continue
            }
            let aTimes = Int(aTimesDouble)
            guard bTimes < limit, aTimes < limit else {
                continue
            }
            res += 3 * aTimes + bTimes
        }
        return res
    }
}
