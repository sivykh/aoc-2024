import Foundation
import Algorithms
import Collections

enum Direction: Character, CaseIterable {
    case up = "^"
    case down = "v"
    case left = "<"
    case right = ">"

    var index: Int {
        switch self {
        case .up: 0
        case .down: 1
        case .right: 2
        case .left: 3
        }
    }

    var isVertical: Bool {
        self == .up || self == .down
    }

    var move: Cell {
        switch self {
        case .up: .init(-1, 0)
        case .down: .init(1, 0)
        case .right: .init(0, 1)
        case .left: .init(0, -1)
        }
    }
}

enum WHCellType: Character {
    case empty = "."
    case box = "O"
    case lbox = "["
    case rbox = "]"
    case wall = "#"
    case robot = "@"

    var isBox: Bool {
        self == .box || self == .lbox || self == .rbox
    }

    var console: String {
        switch self {
        case .robot: return "\u{001b}[1m\u{001b}[31m\(rawValue)\u{001b}[0m"
        case .lbox, .rbox: return "\u{001b}[36m\(rawValue)\u{001b}[0m"
        case .wall: return "\u{001b}[40m\u{001b}[37m\(rawValue)\u{001b}[0m"
        case .empty: return "\u{001b}[37m\(rawValue)\u{001b}[0m"
        default: return "\(self.rawValue)"
        }
    }
}

struct Day15: AdventDay {
    var data: String
    
    var entities: (robot: Cell, grid: [[WHCellType]], directions: [Direction]) {
        let splitted = data.components(separatedBy: "\n\n")
        let rawGrid = splitted[0].components(separatedBy: "\n").map({ Array($0) })
        let m = rawGrid.count, n = rawGrid[0].count
        let grid: [[WHCellType]] = rawGrid.map({ $0.compactMap(WHCellType.init(rawValue:)) })
        let directions = splitted[1].compactMap(Direction.init(rawValue:))
        let robot = product(0..<m, 0..<n).first(where: { grid[$0.0][$0.1] == .robot })!
        return (Cell(robot.0, robot.1), grid, directions)
    }

    var entities2: (robot: Cell, grid: [[WHCellType]], directions: [Direction]) {
        let splitted = data.components(separatedBy: "\n\n")
        let rawGrid = splitted[0].components(separatedBy: "\n").map({ Array($0) })
        let m = rawGrid.count, n = 2 * rawGrid[0].count
        var grid: [[WHCellType]] = .init(repeating: .init(repeating: .empty, count: n), count: m)
        for row in 0..<m {
            for col in 0..<(n / 2) {
                switch WHCellType(rawValue: rawGrid[row][col]) {
                case .box:
                    grid[row][2 * col] = .lbox
                    grid[row][2 * col + 1] = .rbox
                case .robot:
                    grid[row][2 * col] = .robot
                case .wall:
                    grid[row][2 * col] = .wall
                    grid[row][2 * col + 1] = .wall
                default:
                    break
                }
            }
        }
        let directions = splitted[1].compactMap(Direction.init(rawValue:))
        let robot = product(0..<m, 0..<n).first(where: { grid[$0.0][$0.1] == .robot })!
        return (Cell(robot.0, robot.1), grid, directions)
    }

    func part1() -> Any {
        var (robot, grid, directions) = entities
        for direction in directions {
            robot = move(cell: robot, direction: direction, grid: &grid)
        }
        printGrid(grid)

        var res = 0
        for row in 0..<grid.count {
            for col in 0..<grid[row].count where grid[row][col] == .box {
                res += 100 * row + col
            }
        }
        return res
    }
    
    func part2() -> Any {
        var (robot, grid, directions) = entities2
        for direction in directions {
            robot = move2(cell: robot, direction: direction, grid: &grid)
            printGrid(grid, last: false)
        }
        printGrid(grid)

        var res = 0
        for row in 0..<grid.count {
            for col in 0..<grid[row].count where grid[row][col] == .lbox {
                res += 100 * row + col
            }
        }
        return res
    }

    private func printGrid(_ grid: [[WHCellType]], last: Bool = true) {
        for row in 0..<grid.count {
            print(grid[row].map({ $0.console }).joined())
        }
        if !last {
            print(String(repeating: "\u{001b}[A", count: grid.count), terminator: "\r")
        }
    }

    private func shell(_ command: String) -> String {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", command]

        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String

        return output
    }

    private func move(cell: Cell, direction: Direction, grid: inout [[WHCellType]]) -> Cell {
        let step = direction.move
        let nextRobotCandidate = cell + step
        var candidate = nextRobotCandidate

        if grid[candidate.r][candidate.c] == .wall {
            return cell
        } else if grid[candidate.r][candidate.c] == .empty {
            grid[cell.r][cell.c] = .empty
            grid[candidate.r][candidate.c] = .robot
            return candidate
        }

        var movePossible = false
        while candidate.satisfy(grid.count, grid[0].count) {
            if grid[candidate.r][candidate.c] == .box {
                candidate = candidate + step
            } else {
                movePossible = grid[candidate.r][candidate.c] == .empty
                break
            }
        }
        if movePossible {
            grid[cell.r][cell.c] = .empty
            grid[candidate.r][candidate.c] = .box
            grid[nextRobotCandidate.r][nextRobotCandidate.c] = .robot

            return nextRobotCandidate
        }
        return cell
    }

    private func horizontalMove2(cell: Cell, direction: Direction, grid: inout [[WHCellType]]) -> Cell {
        let step = direction.move
        let nextRobotCandidate = cell + step
        var candidate = nextRobotCandidate
        var movePossible = false
        while candidate.satisfy(grid.count, grid[0].count) {
            if grid[candidate.r][candidate.c].isBox {
                candidate = candidate + step
            } else {
                movePossible = grid[candidate.r][candidate.c] == .empty
                break
            }
        }
        if movePossible {
            while candidate != cell {
                let prev = candidate - step
                grid[candidate.r][candidate.c] = grid[prev.r][prev.c]
                candidate = prev
            }
            grid[cell.r][cell.c] = .empty
            return nextRobotCandidate
        }
        return cell
    }

    private func move2(cell: Cell, direction: Direction, grid: inout [[WHCellType]]) -> Cell {
        let step = direction.move
        let nextRobotCandidate = cell + step

        if grid[nextRobotCandidate.r][nextRobotCandidate.c] == .wall {
            return cell
        } else if grid[nextRobotCandidate.r][nextRobotCandidate.c] == .empty {
            grid[cell.r][cell.c] = .empty
            grid[nextRobotCandidate.r][nextRobotCandidate.c] = .robot
            return nextRobotCandidate
        }

        guard direction.isVertical else {
            return horizontalMove2(cell: cell, direction: direction, grid: &grid)
        }

        var candidates: [Set<Cell>] = grid[nextRobotCandidate.r][nextRobotCandidate.c] == .lbox ?
            [[nextRobotCandidate, nextRobotCandidate + Cell(0, 1)]] :
            [[nextRobotCandidate + Cell(0, -1), nextRobotCandidate]]

        var movePossible = true
        while !candidates.last!.isEmpty, movePossible, candidates.last!.reduce(true, { $0 && $1.satisfy(grid.count, grid[0].count) }) {
            var next: Set<Cell> = []
            for candidate in candidates.last! {
                let nextCandidate = candidate + step
                if grid[nextCandidate.r][nextCandidate.c].isBox {
                    next.insert(nextCandidate)
                    next.insert(nextCandidate + Cell(0, grid[nextCandidate.r][nextCandidate.c] == .lbox ? 1 : -1))
                } else {
                    movePossible = movePossible && grid[nextCandidate.r][nextCandidate.c] == .empty
                }
            }
            candidates.append(next)
        }
        if movePossible {
            var copy = grid
            for candidatesLine in candidates.reversed() {
                for candidate in candidatesLine {
                    let next = candidate + step
                    copy[next.r][next.c] = grid[candidate.r][candidate.c]
                    copy[candidate.r][candidate.c] = .empty
                }
            }
            copy[cell.r][cell.c] = .empty
            copy[nextRobotCandidate.r][nextRobotCandidate.c] = .robot
            grid = copy
            return nextRobotCandidate
        }
        return cell
    }
}
