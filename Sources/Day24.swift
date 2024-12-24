import Algorithms
import Collections

private final class Node24 {
    var value: Int?
    var name: String = ""
    var inputs = [Node24]()
    var operation = ""
    
    func calc() -> Int {
        if let value {
            return value
        }
        value = 0
        switch operation {
        case "AND":
            if inputs[0].calc() == 1 && inputs[1].calc() == 1 {
                value = 1
            }
        case "OR":
            if inputs[0].calc() == 1 || inputs[1].calc() == 1 {
                value = 1
            }
        default: // XOR
            if inputs[0].calc() != inputs[1].calc() {
                value = 1
            }
        }
        return value!
    }
}

struct Day24: AdventDay {
    var data: String
    
    fileprivate var entities: [String: Node24] {
        var res = [String: Node24]()
        let comp = data.components(separatedBy: "\n\n")
        let values = comp[0].components(separatedBy: "\n").map { $0.components(separatedBy: ": ") }
        for value in values {
            let node = Node24()
            node.name = value[0]
            node.value = Int(value[1])
            res[node.name] = node
        }
        
        let equations = comp[1].components(separatedBy: "\n").compactMap { $0.isEmpty ? nil :  $0.components(separatedBy: " -> ") }
        for equation in equations {
            let left = equation[0].components(separatedBy: " ")
            let (first, operation, second) = (left[0], left[1], left[2])
            let right = equation[1]
            let (n1, n2, n3) = (res[first] ?? Node24(), res[second] ?? Node24(), res[right] ?? Node24())
            
            n3.name = right
            n3.inputs = [n1, n2]
            n3.operation = operation
            n1.name = first
            n2.name = second
            
            res[first] = n1
            res[second] = n2
            res[right] = n3
        }
        
        return res
    }
    
    func part1() -> Any {
        let input = entities
        let zwires = input.keys.filter({ $0.starts(with: "z") }).sorted()
        var res = 0
        for zwire in zwires {
            let node = input[zwire]?.calc() ?? 0
            guard let bits = Int(String(zwire.dropFirst())) else {
                continue
            }
            
            res |= (node > 0 ? 1 : 0) << (bits)
        }
        return res
    }
    
    func part2() -> Any {
        0
    }
}
