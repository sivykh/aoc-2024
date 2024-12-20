import Algorithms
import Collections

typealias Cell20Type = Cell16Type

private struct Point: Comparable, Hashable, CustomStringConvertible {
    static func < (lhs: Point, rhs: Point) -> Bool {
        lhs.f < rhs.f
    }

    var description: String {
        "<\(cell.r), \(cell.c)>"
    }

    let cell: Cell

    /// distance from the start
    let g: Int
    /// estimated distance left
    let h: Int
    /// Sum of `g` and `h`
    var f: Int { g + h }
}

struct Day20: AdventDay {
    var data: String
    var isTest = false
    init(data: String) {
        self.data = data
    }
    init(data: String, isTest: Bool) {
        self.data = data
        self.isTest = isTest
    }

    var entities: (start: Cell, end: Cell, grid: [[Cell20Type]]) {
        let grid = data.components(separatedBy: "\n").map { $0.compactMap(Cell16Type.init(rawValue:)) }
        let m = grid.count, n = grid[0].count
        let start = product(0..<m, 0..<n).first(where: { grid[$0.0][$0.1] == .start })!
        let end = product(0..<m, 0..<n).first(where: { grid[$0.0][$0.1] == .end })!
        return (Cell(start.0, start.1), Cell(end.0, end.1), grid)
    }

    func dist(_ cell: Cell, _ end: Cell) -> Int {
        abs(cell.r - end.r) + abs(cell.c - end.c)
    }

    private func solve(start: Cell, end: Cell, grid: [[Cell20Type]]) -> [Cell] {
        let m = grid.count
        let n = grid[0].count
        var record = Int.max

        var heap = Heap<Point>()
        heap.insert(Point(cell: start, g: 0, h: dist(start, end)))
        var vis: [[Int]] = .init(repeating: .init(repeating: Int.max, count: n), count: m)
        vis[start.r][start.c] = 0

        while let popped = heap.popMin() {
            if popped.cell == end {
                record = min(record, popped.g)
            }
            for direction in Direction.allCases {
                let move = direction.move
                let cell = popped.cell + move
                guard cell.satisfy(m, n), grid[cell.r][cell.c] != .wall else {
                    continue
                }
                let g = popped.g + 1
                guard g <= record else {
                    continue
                }
                let point = Point(cell: cell, g: g, h: dist(cell, end))
                if vis[cell.r][cell.c] > g {
                    vis[cell.r][cell.c] = g
                    heap.insert(point)
                }
            }
        }

        var total: [Cell] = .init(repeating: end, count: record + 1)
        var queue: Set<Point> = [Point(cell: end, g: record, h: 0)]
        while !queue.isEmpty {
            var next: Set<Point> = []
            for point in queue {
                total[point.g] = point.cell

                for direction in Direction.allCases {
                    let move = direction.reversed.move
                    let cell = point.cell + move
                    guard cell.satisfy(m, n), grid[cell.r][cell.c] != .wall else {
                        continue
                    }

                    let expected = point.g - 1
                    guard vis[cell.r][cell.c] == expected else {
                        continue
                    }
                    next.insert(Point(cell: cell, g: expected, h: 0))
                }
            }
            queue = next
        }
        return total
    }

    private func commonPart(start: Cell, end: Cell, grid: [[Cell20Type]], up: Int, atLeast: Int) async -> Int {
        let path = solve(start: start, end: end, grid: grid)
        return await withTaskGroup(of: Int.self, returning: Int.self) { group in
            for from in 0..<(path.count - atLeast - 1) {
                group.addTask {
                    var res = 0
                    for to in (from + atLeast)..<path.count where dist(path[from], path[to]) <= up {
                        let distance = to - from
                        let newDistance = dist(path[from], path[to])
                        if distance - newDistance > atLeast {
                            res += 1
                        }
                    }
                    return res
                }
            }
            return await group.reduce(0, +)
        }
    }

    func part1() async -> Any {
        let (start, end, grid) = entities
        if !isTest {
            return await commonPart(start: start, end: end, grid: grid, up: 2, atLeast: 99)
        }
        return await commonPart(start: start, end: end, grid: grid, up: 2, atLeast: 9)
    }
    
    func part2() async -> Any {
        let (start, end, grid) = entities
        if !isTest {
            return await commonPart(start: start, end: end, grid: grid, up: 20, atLeast: 99)
        }
        return await commonPart(start: start, end: end, grid: grid, up: 20, atLeast: 69)
    }
}
