import Algorithms
import Collections

enum Cell16Type: Character {
    case start = "S"
    case end = "E"
    case wall = "#"
    case empty = "."
}

private struct Point: Comparable, CustomStringConvertible {
    static func < (lhs: Point, rhs: Point) -> Bool {
        lhs.f < rhs.f
    }

    var description: String {
        "<\(cell.r), \(cell.c), \(dir.rawValue)>"
    }

    let cell: Cell
    let dir: Direction

    /// Расстояние от начального узла до текущего узла
    let g: Int
    /// Примерное расстояние от текущего узла до конечного узла
    let h: Int
    /// Сумма g и h
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
    
    func part1() -> Any {
        let (start, end, grid) = entities
        let m = grid.count
        let n = grid[0].count

        func dist(_ anyCell: Cell) -> Int { abs(anyCell.r - end.r) + abs(anyCell.c - end.c) }

        let possibleDirections = Direction.allCases
        var heap = Heap<Point>()
        heap.insert(Point(cell: start, dir: Direction.right, g: 0, h: dist(start)))
        var closed: [[[Bool]]] = .init(repeating: .init(repeating: [false,false,false,false], count: n), count: m)

        while let popped = heap.popMin() {
            if popped.cell == end {
                return popped.g
            }
            guard !closed[popped.cell.r][popped.cell.c][popped.dir.index] else {
                continue
            }
            closed[popped.cell.r][popped.cell.c][popped.dir.index] = true
            for newDirection in possibleDirections {
                let move = newDirection.move
                let nextCell = popped.cell + move
                guard nextCell.satisfy(m, n), grid[nextCell.r][nextCell.c] != .wall else {
                    continue
                }
                let g = popped.g + 1 + (newDirection == popped.dir ? 0 : 1000)
                heap.insert(Point(cell: nextCell, dir: newDirection, g: g, h: dist(nextCell)))
            }
        }
        return 0
    }
    
    func part2() -> Any {
        0
    }
}
