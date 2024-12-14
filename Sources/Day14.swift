import Algorithms
import Collections

struct Data14 {
    let px: Int, py: Int, vx: Int, vy: Int
}

struct Day14: AdventDay {
    var data: String
    
    var entities: [Data14] {
        let r = /p=(?<px>-*\d+),(?<py>-*\d+) v=(?<vx>-*\d+),(?<vy>-*\d+)/
        return data.split(separator: "\n").map {
            let d = (try! r.firstMatch(in: String($0)))!.output
            return Data14(px: Int(d.px)!, py: Int(d.py)!, vx: Int(d.vx)!, vy: Int(d.vy)!)
        }
    }
    
    func part1() -> Any {
        let input = entities
        var quadrant = [0, 0, 0, 0]
        var wide = 101, tall = 103
        if input[0].px == 0 && input[0].py == 4 {
            wide = 11
            tall = 7
        }
        for data in input {
            let x = ((data.px + 100 * data.vx) % wide + wide) % wide
            let y = ((data.py + 100 * data.vy) % tall + tall) % tall
            guard x != wide / 2 && y != tall / 2 else {
                continue
            }
            let i = 2 * (2 * x / wide) + (2 * y / tall)
            quadrant[i] += 1
        }
        return quadrant.reduce(1, *)
    }
    
    func part2() -> Any {
        0
    }
}
