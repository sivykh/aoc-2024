import Algorithms
import Collections

struct Day21: AdventDay {
    var data: String
    
    var entities: [[Int]] {
        data.components(separatedBy: "\n").map {
            $0.map({ $0 == "A" ? 10 : Int(String($0))! })
        }
    }
    
    func part1() -> Any {
        let numeric = buildNumeric()
        let directional = buildDirectional()
        let input = entities
        

        return 0
    }
    
    func part2() -> Any {
        0
    }

    private static let numGrid = [
        [7, 8, 9],
        [4, 5, 6],
        [1, 2, 3],
        [-1, 0, 10]
    ]

    private func buildNumeric() -> [[[Direction]]] {
        func findStart(of num: Int) -> Cell {
            for r in 0..<4 {
                for c in 0..<3 where Day21.numGrid[r][c] == num {
                    return Cell(r, c)
                }
            }
            fatalError()
        }
        var res = [[[Direction]]](repeating: .init(repeating: [], count: 11), count: 11)
        for from in 0...10 {
            var queue = [(n: from, cell: findStart(of: from), path: [Direction]())]
            var visited = [Bool](repeating: false, count: 11)
            visited[from] = true
            while !queue.isEmpty {
                var next = queue
                next.removeAll()
                for node in queue {
                    for direction in Direction.allCases {
                        let cell = node.cell + direction.move
                        guard cell.satisfy(4, 3), cell != Cell(3, 0), !visited[Day21.numGrid[cell.r][cell.c]] else {
                            continue
                        }
                        let n = Day21.numGrid[cell.r][cell.c]
                        res[from][n] = node.path + [direction]
                        visited[n] = true
                        next.append((n, cell, res[from][n]))
                    }
                }
                queue = next
            }
        }
        return res
    }

    private static let dirGrid = [
        [-1, Direction.up.index, 4],
        [Direction.left.index, Direction.down.index, Direction.right.index]
    ]

    private func buildDirectional() -> [[[Direction]]] {
        func findStart(of num: Int) -> Cell {
            for r in 0..<2 {
                for c in 0..<3 where Day21.dirGrid[r][c] == num {
                    return Cell(r, c)
                }
            }
            fatalError()
        }
        var res = [[[Direction]]](repeating: .init(repeating: [], count: 5), count: 5)
        for from in 0...4 {
            var queue = [(n: from, cell: findStart(of: from), path: [Direction]())]
            var visited = [Bool](repeating: false, count: 5)
            visited[from] = true
            while !queue.isEmpty {
                var next = queue
                next.removeAll()
                for node in queue {
                    for direction in Direction.allCases {
                        let cell = node.cell + direction.move
                        guard cell.satisfy(2, 3), cell != Cell(0, 0), !visited[Day21.dirGrid[cell.r][cell.c]] else {
                            continue
                        }
                        let n = Day21.dirGrid[cell.r][cell.c]
                        res[from][n] = node.path + [direction]
                        visited[n] = true
                        next.append((n, cell, res[from][n]))
                    }
                }
                queue = next
            }
        }
        return res
    }
}
