import Algorithms
import Foundation
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
        let input = entities
        var wide = 101, tall = 103
        if input[0].px == 0 && input[0].py == 4 {
            wide = 11
            tall = 7
        }
        let total = tall * wide
        var time = 0
        var timeIncrement = 1

        while true {
            func find(second: Int) -> Int {
                var bathroom = [Bool](repeating: false, count: total)
                for robot in input {
                    let x = ((robot.px + second * robot.vx) % wide + wide) % wide
                    let y = ((robot.py + second * robot.vy) % tall + tall) % tall
                    bathroom[y * wide + x] = true
                }

                var visited = [Bool](repeating: false, count: total)
                func dfs(_ r: Int, _ c: Int) -> Int {
                    let index = r * wide + c
                    guard 0..<total ~= index, bathroom[index], !visited[index] else {
                        return 0
                    }
                    visited[index] = true
                    return 1 + dfs(r + 1, c) + dfs(r - 1, c) + dfs(r, c + 1) + dfs(r, c - 1)
                }

                var maximum = 0
                for j in 0..<total where bathroom[j] {
                    maximum = max(maximum, dfs(j / wide, j % wide))
                }
                return maximum
            }

            let maximum = find(second: time)
            if maximum > input.count / 3 {
                break
            } else if timeIncrement == 1 && maximum >= 10 {
                let wm = find(second: time + wide)
                let tm = find(second: time + tall)
                timeIncrement = wm > tm ? wide : tall
            }
            time += timeIncrement
        }
        return time
    }
}
/*
 ❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎
 ❄︎                             ❄︎
 ❄︎                             ❄︎
 ❄︎                             ❄︎
 ❄︎                             ❄︎
 ❄︎              ❄︎              ❄︎
 ❄︎             ❄︎❄︎❄︎             ❄︎
 ❄︎            ❄︎❄︎❄︎❄︎❄︎            ❄︎
 ❄︎           ❄︎❄︎❄︎❄︎❄︎❄︎❄︎           ❄︎
 ❄︎          ❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎          ❄︎
 ❄︎            ❄︎❄︎❄︎❄︎❄︎            ❄︎
 ❄︎           ❄︎❄︎❄︎❄︎❄︎❄︎❄︎           ❄︎
 ❄︎          ❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎          ❄︎
 ❄︎         ❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎         ❄︎
 ❄︎        ❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎        ❄︎
 ❄︎          ❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎          ❄︎
 ❄︎         ❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎         ❄︎
 ❄︎        ❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎        ❄︎
 ❄︎       ❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎       ❄︎
 ❄︎      ❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎      ❄︎
 ❄︎        ❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎        ❄︎
 ❄︎       ❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎       ❄︎
 ❄︎      ❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎      ❄︎
 ❄︎     ❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎     ❄︎
 ❄︎    ❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎    ❄︎
 ❄︎             ❄︎❄︎❄︎             ❄︎
 ❄︎             ❄︎❄︎❄︎             ❄︎
 ❄︎             ❄︎❄︎❄︎             ❄︎
 ❄︎                             ❄︎
 ❄︎                             ❄︎
 ❄︎                             ❄︎
 ❄︎                             ❄︎
 ❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎❄︎
 */
