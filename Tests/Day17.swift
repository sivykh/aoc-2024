import XCTest
@testable import AdventOfCode

final class Day17Tests: XCTestCase {
    let testData = """
    Register A: 729
    Register B: 0
    Register C: 0

    Program: 0,1,5,4,3,0
    """

    let testData2 = """
    Register A: 117440
    Register B: 0
    Register C: 0

    Program: 0,3,5,4,3,0
    """

    func testPart1() throws {
        let challenge = Day17(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "4,6,3,5,6,3,5,2,1,0")
    }

    func test2Part1() throws {
        let challenge = Day17(data: testData2)
        XCTAssertEqual(String(describing: challenge.part1()), "0,3,5,4,3,0")
    }

    func testPart2() throws {
        let challenge = Day17(data: testData2)
        XCTAssertEqual(String(describing: challenge.part2()), "117440")
    }
}
