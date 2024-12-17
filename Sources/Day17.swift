import Foundation
import Algorithms
import Collections

enum Command17: Int {
    case adv = 0
    case bxl = 1
    case bst = 2
    case jnz = 3
    case bxc = 4
    case out = 5
    case bdv = 6
    case cdv = 7
}

struct Operation17 {
    let command: Command17
    let operand: Int
}

final class Computer17 {
    var a: Int
    var b: Int
    var c: Int

    let program: [Operation17]
    let rawProgram: String
    let bit3: [Int]

    var output: [Int] = []

    init(a: Int, b: Int, c: Int, bit3: [Int], program: [Operation17]) {
        self.a = a
        self.b = b
        self.c = c
        self.bit3 = bit3
        self.program = program
        self.rawProgram = program.flatMap({ [$0.command.rawValue, $0.operand] }).map({ "\($0)" }).joined(separator: ",")
    }

    /// The value of a combo operand can be found as follows:
    /// Combo operands 0 through 3 represent literal values 0 through 3.
    /// Combo operand 4 represents the value of register A.
    /// Combo operand 5 represents the value of register B.
    /// Combo operand 6 represents the value of register C.
    /// Combo operand 7 is reserved and will not appear in valid programs.
    private func combo(operand: Int) -> Int? {
        switch operand {
        case 0...3: return operand
        case 4: return self.a
        case 5: return self.b
        case 6: return self.c
        default:
            return nil
        }
    }

    func work() {
        var pointer = 0
        while pointer < self.program.count {
            let instruction = self.program[pointer]
            let comboValue = combo(operand: instruction.operand)
            var nextPointer = pointer + 1
            switch instruction.command {
            case .adv:
                let denominator = Int(pow(2, Double(comboValue!)))
                self.a = self.a / denominator
            case .bxl:
                self.b = self.b ^ instruction.operand
            case .bst:
                self.b = comboValue! % 8
            case .jnz:
                if self.a != 0 {
                    nextPointer = instruction.operand / 2
                }
            case .bxc:
                self.b = self.b ^ self.c
            case .out:
                self.output.append(comboValue! % 8)
            case .bdv:
                let denominator = Int(pow(2, Double(comboValue!)))
                self.b = self.a / denominator
            case .cdv:
                let denominator = Int(pow(2, Double(comboValue!)))
                self.c = self.a / denominator
            }
            pointer = nextPointer
        }
    }
}

struct Day17: AdventDay {
    var data: String
    
    var entities: Computer17 {
        let splitted = data.components(separatedBy: "\n\n")
        let registers = splitted[0].components(separatedBy: "\n")
        let a = registers[0].components(separatedBy: ": ")[1]
        let b = registers[1].components(separatedBy: ": ")[1]
        let c = registers[2].components(separatedBy: ": ")[1]
        let bit3 = splitted[1].components(separatedBy: ": ")[1].components(separatedBy: ",").compactMap({ Int($0) })
        var program = [Operation17]()
        for i in stride(from: 0, to: bit3.count, by: 2) {
            program.append(Operation17(command: Command17(rawValue: bit3[i])!, operand: bit3[i + 1]))
        }
        return Computer17(a: Int(a)!, b: Int(b)!, c: Int(c)!, bit3: bit3, program: program)
    }

    func part1() -> Any {
        let computer = entities
        computer.work()
        return computer.output.map({"\($0)"}).joined(separator: ",")
    }
    
    func part2() -> Any {
        let computer = entities
        let b = computer.b, c = computer.c
        func find(a: Int = 0, depth: Int = 0) -> Int {
            if depth == computer.bit3.count {
                return a
            }
            for i in 0..<8 {
                let initial = 8 * a + i
                computer.a = initial
                computer.b = b
                computer.c = c
                computer.output = []
                computer.work()
                if computer.output[0] == computer.bit3[computer.bit3.count - 1 - depth] {
                    let found = find(a: initial, depth: depth + 1)
                    if found != 0 {
                        return found
                    }
                }
            }
            return 0
        }
        
        return find()
        
//        let computer = entities
//        print(computer.bit3, "\n")
//        let b = computer.b, c = computer.c
//        var degrees = [1]
//        for j in 1..<computer.bit3.count {
//            degrees.append(degrees[j - 1] * 8)
//        }
//        var initial = degrees[15] * 3
//        initial += degrees[14] * 0 // 0 | 7
//        initial += degrees[13] * 7
//        initial += degrees[12] * 4 // 2 | 4
//        initial += degrees[11] * 1
//        initial += degrees[10] * 0 // 0 || 5
//        initial += degrees[9] * 3
//        initial += degrees[8] * 3 // 2 3 5
//        initial += degrees[7] * 1 // 1 | 5
//        initial += degrees[6] * 3
//        initial += degrees[5] * 3
//        initial += degrees[4] * 2
//        initial += degrees[3] * 2
//        initial += degrees[2] * 3
//        initial += degrees[1] * 4 // 109685330781408
//
//        for j in 0..<8 {
//            computer.a = initial
//            computer.b = b
//            computer.c = c
//            computer.output = []
//            computer.work()
//            
//            print(computer.output)
//            initial += degrees[1]
//        }
//        
//        return 0
    }
}
