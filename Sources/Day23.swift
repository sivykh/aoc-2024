import Algorithms
import Collections

struct Day23: AdventDay {
    var data: String
    
    var entities: [[String]] {
        data.split(separator: "\n").map {
            $0.split(separator: "-").map({ String($0) })
        }
    }
    
    func part1() -> Any {
        var connected = [String: Set<String>]()
        var startsWithT = Set<String>()
        for connection in entities {
            connected[connection[0], default: []].insert(connection[1])
            connected[connection[1], default: []].insert(connection[0])
            if connection[0].first == "t" {
                startsWithT.insert(connection[0])
            }
            if connection[1].first == "t" {
                startsWithT.insert(connection[1])
            }
        }
        var res = 0
        for tj in startsWithT {
            let c = Array(connected[tj, default: []])
            for i in 0..<c.count {
                for k in (i + 1)..<c.count {
                    guard !((c[i].first == "t" && c[i].last! < tj.last!) ||
                            (c[k].first == "t" && c[k].last! < tj.last!)) else {
                        continue
                    }
                    if connected[c[i], default: []].contains(c[k]) {
                        res += 1
                    }
                }
            }
        }
        return res
    }
    
    func part2() -> Any {
        var connected = [String: Set<String>]()
        var all = Set<String>()
        for connection in entities {
            connected[connection[0], default: []].insert(connection[1])
            connected[connection[1], default: []].insert(connection[0])
            all.formUnion(connection)
        }
        
        var compsub: Set<String> = []
        var record: Set<String> = []
        func find(candidates: Set<String>, not: Set<String>) {
            var candidates = candidates
            while !candidates.isEmpty {
                var stop = false
                for node in not {
                    if connected[node, default: []].isSuperset(of: candidates) {
                        stop = true
                        break
                    }
                }
                guard !stop else {
                    break
                }
                let v = candidates.popFirst()!
                
                var newCandidates = candidates
                var newNot = not
                
                for node in candidates where !connected[node, default: []].contains(v) { newCandidates.remove(node) }
                for node in not where !connected[node, default: []].contains(v) { newNot.remove(node) }
                
                compsub.insert(v)
                if newCandidates.isEmpty, newNot.isEmpty {
                    if compsub.count > record.count {
                        record = compsub
                    }
                } else {
                    find(candidates: newCandidates, not: newNot)
                }
                compsub.remove(v)
            }
        }
        
        find(candidates: all, not: [])
        
        return record.sorted().joined(separator: ",")
    }
}
