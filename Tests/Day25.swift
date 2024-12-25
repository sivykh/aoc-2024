import XCTest
@testable import AdventOfCode

final class Day25Tests: XCTestCase {
    let testData = """
    #####
    .####
    .####
    .####
    .#.#.
    .#...
    .....

    #####
    ##.##
    .#.##
    ...##
    ...#.
    ...#.
    .....

    .....
    #....
    #....
    #...#
    #.#.#
    #.###
    #####

    .....
    .....
    #.#..
    ###..
    ###.#
    ###.#
    #####

    .....
    .....
    .....
    #....
    #.#..
    #.#.#
    #####
    """

    func testPart1() throws {
        let challenge = Day25(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "3")
    }

    func testPart2() throws {
        let challenge = Day25(data: testData)
        XCTAssertEqual(String(describing: challenge.part2()), "0")
    }
}
