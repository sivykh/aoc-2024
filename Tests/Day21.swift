import XCTest
@testable import AdventOfCode

final class Day21Tests: XCTestCase {
    let testData = """
    029A
    980A
    179A
    456A
    379A
    """

    func testPart1() throws {
        let challenge = Day21(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "126384")
    }

    func testPart2() throws {
        let challenge = Day21(data: testData)
        XCTAssertEqual(String(describing: challenge.part2()), "0")
    }
}
