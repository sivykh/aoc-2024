import XCTest
@testable import AdventOfCode

final class Day11Tests: XCTestCase {
    let testData = """
    125 17
    """

    func testPart1() throws {
        let challenge = Day11(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "55312")
    }

    func testPart2() throws {
        let challenge = Day11(data: testData)
        XCTAssertEqual(String(describing: challenge.part2()), "0")
    }
}
