import XCTest
@testable import AdventOfCode

final class Day10Tests: XCTestCase {
    let testData = """
    89010123
    78121874
    87430965
    96549874
    45678903
    32019012
    01329801
    10456732
    """

    func testPart1() throws {
        let challenge = Day10(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "36")
    }

    func testPart2() throws {
        let challenge = Day10(data: testData)
        XCTAssertEqual(String(describing: challenge.part2()), "81")
    }
}
