import XCTest
@testable import AdventOfCode

final class Day16Tests: XCTestCase {
    let testData = """
    #################
    #...#...#...#..E#
    #.#.#.#.#.#.#.#.#
    #.#.#.#...#...#.#
    #.#.#.#.###.#.#.#
    #...#.#.#.....#.#
    #.#.#.#.#.#####.#
    #.#...#.#.#.....#
    #.#.#####.#.###.#
    #.#.#.......#...#
    #.#.###.#####.###
    #.#.#...#.....#.#
    #.#.#.#####.###.#
    #.#.#.........#.#
    #.#.#.#########.#
    #S#.............#
    #################
    """
    
    let testData2 = """
    ###############
    #.......#....E#
    #.#.###.#.###.#
    #.....#.#...#.#
    #.###.#####.#.#
    #.#.#.......#.#
    #.#.#####.###.#
    #...........#.#
    ###.#.#####.#.#
    #...#.....#.#.#
    #.#.#.###.#.#.#
    #.....#...#.#.#
    #.###.#.#.#.#.#
    #S..#.....#...#
    ###############
    """

    func testPart1() throws {
        let challenge = Day16(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "11048")
    }

    func testPart2() throws {
        let challenge = Day16(data: testData)
        XCTAssertEqual(String(describing: challenge.part2()), "64")
    }
    
    func test2Part2() throws {
        let challenge = Day16(data: testData2)
        XCTAssertEqual(String(describing: challenge.part2()), "45")
    }
    
    func test3Part2() throws {
        let challenge = Day16(data: """
        ######
        ##..E#
        #...##
        #S#..#
        ######
        """)
        XCTAssertEqual(String(describing: challenge.part2()), "7")
    }
}
