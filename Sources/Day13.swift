import Algorithms
import Collections

struct Machine {
    let a: Cell, b: Cell, prize: Cell
}

struct Day13: AdventDay {
    var data: String

    var entities: [Machine] {
        let r = /Button A: X\+(?<ax>\d+), Y\+(?<ay>\d+)\nButton B: X\+(?<bx>\d+), Y\+(?<by>\d+)\nPrize: X=(?<px>\d+), Y=(?<py>\d+)/
        return data.split(separator: "\n\n").map {
            let m = (try! r.firstMatch(in: String($0)))!.output
            return Machine(a: .init(Int(m.ax)!, Int(m.ay)!),
                           b: .init(Int(m.bx)!, Int(m.by)!),
                           prize: .init(Int(m.px)!, Int(m.py)!))
        }
    }

    func part1() -> Any {
        print(entities)
        return 0
    }

    func part2() -> Any {
        0
    }
}
