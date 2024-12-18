import XCTest
@testable import AdventOfCode

final class Day18Tests: XCTestCase {
    let testData = """
    5,4
    4,2
    4,5
    3,0
    2,1
    6,3
    2,4
    1,5
    0,6
    3,3
    2,6
    5,1
    1,2
    5,5
    2,5
    6,5
    1,4
    0,4
    6,4
    1,1
    6,1
    1,0
    0,5
    1,6
    2,0
    """

    func testPart1() throws {
        var challenge = Day18(data: testData)
        challenge.testBound = [
            Cell(7, 0), Cell(7, 1), Cell(7, 2), Cell(7, 3), Cell(7, 4), Cell(7, 5), Cell(7, 6), Cell(7, 7),
            Cell(0, 7), Cell(1, 7), Cell(2, 7), Cell(3, 7), Cell(4, 7), Cell(5, 7),
        ]
        XCTAssertEqual(String(describing: challenge.part1()), "150")
    }

    func testPart2() throws {
        var challenge = Day18(data: testData)
        challenge.testBound = [
            Cell(7, 0), Cell(7, 1), Cell(7, 2), Cell(7, 3), Cell(7, 4), Cell(7, 5), Cell(7, 6), Cell(7, 7),
            Cell(0, 7), Cell(1, 7), Cell(2, 7), Cell(3, 7), Cell(4, 7), Cell(5, 7),
        ]
        XCTAssertEqual(String(describing: challenge.part2()), "6,1")
    }
}
