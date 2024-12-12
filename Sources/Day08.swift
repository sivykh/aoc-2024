import Algorithms
import Collections
import Foundation

struct Cell: Hashable {
    let r: Int
    let c: Int
    init(_ r: Int, _ c: Int) { self.r = r; self.c = c }

    static func +(lhs: Self, rhs: Self) -> Self {
        return Cell(lhs.r + rhs.r, lhs.c + rhs.c)
    }

    func satisfy(_ rRange: Range<Int>, _ cRange: Range<Int>) -> Bool {
        rRange ~= self.r && cRange ~= self.c
    }
}

struct Day08: AdventDay {
    var data: String
    
    var entities: (side: Int, data: [Character: [Cell]]) {
        var res = [Character: [Cell]]()
        var row = 0, side = 0
        for l in data.split(separator: "\n") {
            let line = Array(l)
            side = max(side, line.count)
            for col in 0..<line.count {
                guard line[col] != "." else {
                    continue
                }
                res[line[col], default: []].append(Cell(row, col))
            }
            row += 1
        }
        return (side, res)
    }
    
    func part1() async -> Any {
        await common(part2: false)
    }
    
    func part2() async -> Any {
        await common(part2: true)
    }

    func common(part2: Bool) async -> Any {
        let input = entities
        let range = 0..<input.side
        let limit = part2 ? input.side : 2

        return await withTaskGroup(of: Set<Cell>.self, returning: Set<Cell>.self) { group in
            for char in input.data.keys {
                let count = input.data[char]!.count
                group.addTask {
                    var positions: Set<Cell> = []
                    for i in 0..<count {
                        for j in (i + 1)..<count {
                            let cell1 = input.data[char]![i]
                            let cell2 = input.data[char]![j]
                            let dr = (cell2.r - cell1.r)
                            let dc = (cell2.c - cell1.c)
                            for cell in [cell1, cell2] {
                                for sign in [-1, 1] {
                                    for m in 1..<limit {
                                        guard range ~= cell.r + m * sign * dr, range ~= cell.c + m * sign * dc else {
                                            break
                                        }
                                        positions.insert(.init(cell.r + m * sign * dr, cell.c + m * sign * dc))
                                    }
                                }
                            }
                            if !part2 {
                                positions.subtract([cell1, cell2])
                            }
                        }
                    }
                    return positions
                }
            }
            return await group.reduce(into: Set<Cell>(), { $0.formUnion($1) })
        }.count
    }
}
