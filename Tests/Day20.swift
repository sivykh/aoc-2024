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

    func testPart1() async throws {
        let challenge = Day20(data: testData, isTest: true)
        let result = await challenge.part1()
        XCTAssertEqual(String(describing: result), "10")
    }

    func testPart2() async throws {
        let challenge = Day20(data: testData, isTest: true)
        let result = await challenge.part2()
        XCTAssertEqual(String(describing: result), "41")
    }
}
