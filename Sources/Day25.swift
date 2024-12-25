import Algorithms
import Collections

struct Lock25 {
    let rows: Int
    let cols: Int
    let heights: [Int]
}

struct Key25 {
    let rows: Int
    let cols: Int
    let heights: [Int]
}

struct Day25: AdventDay {
    var data: String
    
    var entities: (locks: [Lock25], keys: [Key25]) {
        var (locks, keys) = ([Lock25](), [Key25]())
        
        let schematics = data.components(separatedBy: "\n\n")
        for schematic in schematics {
            let grid = schematic.components(separatedBy: "\n").compactMap({ $0.isEmpty ? nil : Array($0) })
            let (rows, cols) = (grid.count, grid[0].count)
            let isLock = grid[0].filter({ $0 == "#" }).count == grid[0].count
            let rowsRange = isLock ? stride(from: 1, to: rows, by: 1) : stride(from: rows - 2, to: 0, by: -1)
            var heights: [Int] = []
            for col in 0..<cols {
                var count = 0
                for row in rowsRange {
                    if grid[row][col] != "#" {
                        break
                    }
                    count += 1
                }
                heights.append(count)
            }
            if isLock {
                locks.append(Lock25(rows: rows, cols: cols, heights: heights))
            } else {
                keys.append(Key25(rows: rows, cols: cols, heights: heights))
            }
        }
        
        return (locks, keys)
    }
    
    func part1() -> Any {
        let input = entities
        var res = 0
        for key in input.keys {
            for lock in input.locks where key.rows == lock.rows && key.cols == lock.cols {
                res += 1
                for j in 0..<lock.cols {
                    if lock.rows - 2 < lock.heights[j] + key.heights[j] {
                        res -= 1
                        break
                    }
                }
            }
        }
        return res
    }
    
    func part2() -> Any {
        0
    }
}
