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
        OOO
        OXO
        OOO
        """

    let testData3 =
        """
        OOOOO
        OXOXO
        OOOOO
        OXOXO
        OOOOO
        """

    let testData4 =
        """
        EEEEE
        EXXXX
        EEEEE
        EXXXX
        EEEEE
        """

    let testData5 =
        """
        AAAAAA
        AAABBA
        AAABBA
        ABBAAA
        ABBAAA
        AAAAAA
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
        XCTAssertEqual(String(describing: challenge.part2()), "68")
    }

    func test3Part2() throws {
        let challenge = Day12(data: testData3)
        XCTAssertEqual(String(describing: challenge.part2()), "436")
    }

    func test4Part2() throws {
        let challenge = Day12(data: testData4)
        XCTAssertEqual(String(describing: challenge.part2()), "236")
    }

    func test5Part2() throws {
        let challenge = Day12(data: testData5)
        XCTAssertEqual(String(describing: challenge.part2()), "368")
    }
}
