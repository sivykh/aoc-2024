import XCTest
@testable import AdventOfCode

final class Day20Tests: XCTestCase {
    let testData = """
    ###############
    #...#...#.....#
    #.#.#.#.#.###.#
    #S#...#.#.#...#
    #######.#.#.###
    #######.#.#...#
    #######.#.###.#
    ###..E#...#...#
    ###.#######.###
    #...###...#...#
    #.#####.#.###.#
    #.#...#.#.#...#
    #.#.#.#.#.#.###
    #...#...#...###
    ###############
    """

    func testPart1() throws {
        let challenge = Day20(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "0")
    }

    func testPart2() throws {
        let challenge = Day20(data: testData)
        XCTAssertEqual(String(describing: challenge.part2()), "0")
    }
}
