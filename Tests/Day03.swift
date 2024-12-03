import XCTest
@testable import AdventOfCode

final class Day03Tests: XCTestCase {
    let testData = """
    xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
    """

    func testPart1() throws {
        let challenge = Day03(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "161")
    }

    func testPart2() throws {
        let challenge = Day03(data: testData)
        XCTAssertEqual(String(describing: challenge.part2()), "48")
    }
}
