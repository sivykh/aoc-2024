import Algorithms
import Collections

enum Direction: Character {
    case up = "^"
    case down = "v"
    case left = "<"
    case right = ">"

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
    case wall = "#"
    case robot = "@"
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
        0
    }

    private func printGrid(_ grid: [[WHCellType]]) {
        for row in 0..<grid.count {
            for col in 0..<grid[row].count {
                print(grid[row][col].rawValue, terminator: "")
            }
            print()
        }
        print()
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
}
