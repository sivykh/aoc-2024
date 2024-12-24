import Foundation
import Algorithms
import Collections

private final class Node24 {
    var value: Int?
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
            if inputs.count == 2 && inputs[0].calc() != inputs[1].calc() {
                value = 1
            }
        }
        return value!
    }
}

struct Day24: AdventDay {
    var data: String
    
    fileprivate func entities(swapPairs: [[String]] = []) -> [String: Node24] {
        var swaps: [String: String] = [:]
        for swap in swapPairs where swap.count == 2 {
            swaps[swap[0]] = swap[1]
            swaps[swap[1]] = swap[0]
        }
        var res = [String: Node24]()
        let comp = data.components(separatedBy: "\n\n")
        let values = comp[0].components(separatedBy: "\n").map { $0.components(separatedBy: ": ") }
        for value in values {
            let node = Node24()
            node.value = Int(value[1])
            res[value[0]] = node
        }
        
        let equations = comp[1].components(separatedBy: "\n").compactMap { $0.isEmpty ? nil :  $0.components(separatedBy: " -> ") }
        for equation in equations {
            let left = equation[0].components(separatedBy: " ")
            let (first, operation, second) = (left[0], left[1], left[2])
            let right = swaps[equation[1]] ?? equation[1]
            let (n1, n2, n3) = (res[first] ?? Node24(), res[second] ?? Node24(), res[right] ?? Node24())
            
            n3.inputs = [n1, n2]
            n3.operation = operation
            
            res[first] = n1
            res[second] = n2
            res[right] = n3
        }
        
        return res
    }
    
    func part1() -> Any {
        calc(input: entities(), letter: "z")
    }
    
    func part2() -> Any {
        let start = entities()
        let expected = calc(input: start, letter: "x") + calc(input: start, letter: "y")
        print(expected)
        
        // z_n = (x_n-1 & y_n-1) ^ (x_n ^ y_n)
        
        let swaps = [["z06", "ksv"], ["kbs", "nbd"], ["z20", "tqq"], ["z39", "ckb"]]

        return swaps.flatMap({$0}).sorted().joined(separator: ",")
    }
    
    private func calc(input: [String: Node24], letter: Character) -> Int {
        let wires = input.keys.filter({ $0.first == letter }).sorted()
        var res = 0
        for wire in wires {
            let node = input[wire]?.calc() ?? 0
            guard let bits = Int(String(wire.dropFirst())) else {
                continue
            }
            
            res |= (node > 0 ? 1 : 0) << (bits)
        }
        return res
    }
}
