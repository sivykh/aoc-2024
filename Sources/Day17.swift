import Foundation
import Algorithms
import Collections

enum Command17: Int {
    case adv, bxl, bst, jnz, bxc, out, bdv, cdv
}

struct Operation17 {
    let command: Command17
    let operand: Int
}

struct Computer17 {
    var a: Int, b: Int, c: Int
    let bit3: [Int]
    let program: [Operation17]

    var output: [Int] = []

    init(a: Int, b: Int, c: Int, bit3: [Int], program: [Operation17]) {
        self.a = a
        self.b = b
        self.c = c
        self.bit3 = bit3
        self.program = program
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
        case 4: return a
        case 5: return b
        case 6: return c
        default:
            return nil
        }
    }

    mutating func work() -> [Int] {
        var pointer = 0
        while pointer < program.count {
            let instruction = program[pointer]
            let comboValue = combo(operand: instruction.operand)
            var nextPointer = pointer + 1
            switch instruction.command {
            case .adv: a = a / Int(pow(2, Double(comboValue!)))
            case .bxl: b = b ^ instruction.operand
            case .bst: b = comboValue! % 8
            case .jnz: nextPointer = a != 0 ? instruction.operand / 2 : nextPointer
            case .bxc: b = b ^ c
            case .out: output.append(comboValue! % 8)
            case .bdv: b = a / Int(pow(2, Double(comboValue!)))
            case .cdv: c = a / Int(pow(2, Double(comboValue!)))
            }
            pointer = nextPointer
        }
        return output
    }
}

struct Day17: AdventDay {
    var data: String
    
    var entity: Computer17 {
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
        var computer = entity
        return computer.work().map({"\($0)"}).joined(separator: ",")
    }
    
    func part2() -> Any {
        let input = entity
        var degrees = [1]
        for j in 1..<input.bit3.count {
            degrees.append(degrees[j - 1] * 8)
        }
        
        func find(a: Int, j: Int) -> Int? {
            if j < 0 {
                return a
            }
            for i in 0..<8 where a > 0 || i > 0 {
                let initial = a + i * degrees[j]
                var computer = input
                computer.a = initial
                if computer.work()[j] == computer.bit3[j] {
                    if let found = find(a: initial, j: j - 1) {
                        return found
                    }
                }
            }
            return nil
        }

        return find(a: 0, j: input.bit3.count - 1) ?? -1
        
//        let computer = entity
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
