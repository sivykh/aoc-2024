import XCTest
@testable import AdventOfCode

final class Day12Tests: XCTestCase {
    let testData = 
        """
        AAAA
        BBCD
        BBCC
        EEEC
        """
    
    let testData2 =
        """
        OOOOO
        OXOXO
        OOOOO
        OXOXO
        OOOOO
        """

    func testPart1() throws {
        let challenge = Day12(data: testData)
        XCTAssertEqual(String(describing: challenge.part1()), "140")
    }

    func testPart2() throws {
        let challenge = Day12(data: testData)
        XCTAssertEqual(String(describing: challenge.part2()), "80")
    }
    
    func test2Part2() throws {
        let challenge = Day12(data: testData2)
        XCTAssertEqual(String(describing: challenge.part2()), "436")
    }
}
