import XCTest
@testable import AdventOfCode

final class Day09Tests: XCTestCase {
    let testData = "2333133121414131402"

    func testPart1() throws {
        let challenge = Day09(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "1928")
    }

    func testPart2() throws {
        let challenge = Day09(data: testData)
        XCTAssertEqual(String(describing: challenge.part2()), "2858")
    }
}
