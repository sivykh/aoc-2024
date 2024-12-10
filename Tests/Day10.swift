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

    func testPart1() async throws {
        let challenge = Day10(data: testData)
        let result = await challenge.part1()
        XCTAssertEqual(String(describing: result), "36")
    }

    func testPart2() async throws {
        let challenge = Day10(data: testData)
        let result = await challenge.part2()
        XCTAssertEqual(String(describing: result), "81")
    }
}
