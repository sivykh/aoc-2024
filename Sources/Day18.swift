import Foundation
import Algorithms
import Collections

enum Cell18Type: Character {
    case wall = "#"
    case empty = "."

    var console: String {
        switch self {
        case .wall: return "\u{001b}[40m\u{001b}[37m\(rawValue)\u{001b}[0m"
        case .empty: return "\u{001b}[37m\(rawValue)\u{001b}[0m"
        }
    }
}
private let visited = "\u{001b}[1m\u{001b}[41m\("  ")\u{001b}[0m"

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


struct Day18: AdventDay {
    var data: String
    
    var entities: [Cell] {
        data.split(separator: "\n").map {
            let sub = $0.split(separator: ",")
            return Cell(Int(sub[1])!, Int(sub[0])!)
        }
    }

    private func dist(_ cell: Cell, _ end: Cell) -> Int { abs(cell.r - end.r) + abs(cell.c - end.c) }

    func part1() -> Any {
        common(cells: entities.prefix(1024))!
    }

    func part2() -> Any {
        let cells = entities
        for steps in 1024... {
            if common(cells: cells.prefix(steps), prints: true) == nil {
                let cell = cells[steps]
                return "\(cell.c),\(cell.r)"
            }
        }
        return 0
    }

    private func common(cells: ArraySlice<Cell>, prints: Bool = false) -> Int? {
        let m = 71
        let n = 71
        var grid: [[Cell18Type]] = .init(repeating: .init(repeating: .empty, count: n), count: m)
        for cell in cells where cell.satisfy(m, n) {
            grid[cell.r][cell.c] = .wall
        }
        let start = Cell(0, 0)
        let end = Cell(m - 1, n - 1)

        var heap = Heap<Point>()
        heap.insert(Point(cell: start, g: 0, h: dist(start, end)))
        var closed: [[Bool]] = .init(repeating: .init(repeating: false, count: n), count: m)

        while let popped = heap.popMin() {
            closed[popped.cell.r][popped.cell.c] = true
            if popped.cell == end {
                if prints { printGrid(grid, vis: closed) }
                return popped.g
            }
            for direction in Direction.allCases {
                let move = direction.move
                let cell = popped.cell + move
                guard cell.satisfy(m, n), grid[cell.r][cell.c] != .wall, !closed[cell.r][cell.c] else {
                    continue
                }
                let g = popped.g + 1
                heap.insert(Point(cell: cell, g: g, h: dist(cell, end)))
            }
        }
        if prints { printGrid(grid, vis: closed, last: true) }
        return nil
    }

    private func printGrid(_ grid: [[Cell18Type]], vis: [[Bool]], last: Bool = false) {
        fflush(stdout)
        let m = grid.count, n = grid[0].count
        for row in 0..<m {
            for col in 0..<n {
                if vis[row][col] {
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
}
