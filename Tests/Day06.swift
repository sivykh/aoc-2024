import XCTest
@testable import AdventOfCode

final class Day06Tests: XCTestCase {
    let testData = """
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    """

    func testPart1() throws {
        let challenge = Day06(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "41")
    }

    func testPart2() throws {
        let challenge = Day06(data: testData)
        XCTAssertEqual(String(describing: challenge.part2()), "6")
    }
}
