import Foundation
import Algorithms
import Collections

enum Cell16Type: Character {
    case start = "S"
    case end = "E"
    case wall = "#"
    case empty = "."

    var console: String {
        switch self {
        case .start: return "\u{001b}[1m\u{001b}[31m\(rawValue)\u{001b}[0m"
        case .end: return "\u{001b}[1m\u{001b}[32m\(rawValue)\u{001b}[0m"
        case .wall: return "\u{001b}[40m\u{001b}[37m\(rawValue)\u{001b}[0m"
        case .empty: return "\u{001b}[37m\(rawValue)\u{001b}[0m"
        }
    }
}

private let visited = "\u{001b}[1m\u{001b}[41m\("  ")\u{001b}[0m"
private let complete = "\u{001b}[37m\u{001b}[42m\("  ")\u{001b}[0m"

private struct Point: Comparable, Hashable, CustomStringConvertible {
    static func < (lhs: Point, rhs: Point) -> Bool {
        lhs.f < rhs.f
    }

    var description: String {
        "<\(cell.r), \(cell.c), \(dir.rawValue)>"
    }

    let cell: Cell
    let dir: Direction

    /// distance from the start
    let g: Int
    /// estimated distance left
    let h: Int
    /// Sum of `g` and `h`
    var f: Int { g + h }
}


struct Day16: AdventDay {
    var data: String
    
    var entities: (start: Cell, end: Cell, grid: [[Cell16Type]] ){
        let grid = data.components(separatedBy: "\n").map { $0.compactMap(Cell16Type.init(rawValue:)) }
        let m = grid.count, n = grid[0].count
        let start = product(0..<m, 0..<n).first(where: { grid[$0.0][$0.1] == .start })!
        let end = product(0..<m, 0..<n).first(where: { grid[$0.0][$0.1] == .end })!
        return (Cell(start.0, start.1), Cell(end.0, end.1), grid)
    }

    func dist(_ cell: Cell, _ end: Cell) -> Int {
        let l = abs(cell.r - end.r) + abs(cell.c - end.c)
        if cell.r != end.r && cell.c != end.c {
            return l + 1000
        }
        return l
    }

    func part1() -> Any {
        let (start, end, grid) = entities
        let m = grid.count
        let n = grid[0].count

        var heap = Heap<Point>()
        heap.insert(Point(cell: start, dir: Direction.right, g: 0, h: dist(start, end)))
        var closed: [[[Bool]]] = .init(repeating: .init(repeating: [false,false,false,false], count: n), count: m)

        while let popped = heap.popMin() {
            if popped.cell == end {
                return popped.g
            }
            guard !closed[popped.cell.r][popped.cell.c][popped.dir.index] else {
                continue
            }
            closed[popped.cell.r][popped.cell.c][popped.dir.index] = true
            for newDirection in popped.dir.allButReversed {
                let move = newDirection.move
                let nextCell = popped.cell + move
                guard nextCell.satisfy(m, n), grid[nextCell.r][nextCell.c] != .wall else {
                    continue
                }
                let g = popped.g + 1 + (newDirection == popped.dir ? 0 : 1000)
                heap.insert(Point(cell: nextCell, dir: newDirection, g: g, h: dist(nextCell, end)))
            }
        }
        return 0
    }

    private func printGrid(_ grid: [[Cell16Type]], vis: [[[Int]]], total: Set<Cell>, last: Bool = false) {
        fflush(stdout)
        let m = grid.count, n = grid[0].count
        for row in 0..<m {
            for col in 0..<n {
                if grid[row][col] == .start || grid[row][col] == .end {
                    print(grid[row][col].console, terminator: "")
                } else if total.contains(Cell(row, col)) {
                    print(complete, terminator: "")
                } else if !vis[row][col].filter({ $0 != Int.max }).isEmpty {
                    print(visited, terminator: "")
                } else {
                    print(grid[row][col].console, terminator: "")
                    print(grid[row][col].console, terminator: "")
                }
            }
            print()
        }
        if !last {
            print(String(repeating: "\u{001b}[A", count: m), terminator: "\r")
        }
    }

    func part2() -> Any {
        let (start, end, grid) = entities
        let m = grid.count
        let n = grid[0].count
        var record = Int.max

        var heap = Heap<Point>()
        heap.insert(Point(cell: start, dir: Direction.right, g: 0, h: dist(start, end)))
        var vis: [[[Int]]] = .init(repeating: .init(repeating: (0..<4).map { _ in Int.max }, count: n), count: m)
        vis[start.r][start.c] = [0,0,0,0]

        while let popped = heap.popMin() {
            if popped.cell == end {
                record = min(record, popped.g)
            }
            for direction in popped.dir.allButReversed {
                let move = direction.move
                let cell = popped.cell + move
                guard cell.satisfy(m, n), grid[cell.r][cell.c] != .wall else {
                    continue
                }
                let g = popped.g + 1 + (direction == popped.dir ? 0 : 1000)
                guard g <= record else {
                    continue
                }
                let point = Point(cell: cell, dir: direction, g: g, h: dist(cell, end))
                if vis[cell.r][cell.c][direction.index] > g {
                    vis[cell.r][cell.c][direction.index] = g
                    heap.insert(point)
                }
            }
        }

        var total: Set<Cell> = []
        var queue: Set<Point> = Set(vis[end.r][end.c].enumerated().compactMap( { index, g in
            if g != record {
                return nil
            }
            return Point(cell: end, dir: Direction(index: index), g: g, h: 0)
        }))
        while !queue.isEmpty {
            var next: Set<Point> = []
            for point in queue {
                total.insert(point.cell)
                for direction in point.dir.allButReversed {
                    let move = direction.reversed.move
                    let cell = point.cell + move
                    guard cell.satisfy(m, n), grid[cell.r][cell.c] != .wall else {
                        continue
                    }
                    for dir in direction.allButReversed {
                        let expected = point.g - 1 - (dir == point.dir ? 0 : 1000)
                        guard vis[cell.r][cell.c][dir.index] == expected else {
                            continue
                        }
                        next.insert(Point(cell: cell, dir: dir, g: expected, h: 0))
                    }
                }
            }
            queue = next
        }
        return total.count
    }
}
