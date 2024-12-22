import XCTest
@testable import AdventOfCode

final class Day22Tests: XCTestCase {
    func testPart1() throws {
        let challenge = Day22(data: """
            1
            10
            100
            2024
            """
        )
        XCTAssertEqual(String(describing: challenge.part1()), "37327623")
    }

    func testPart2() throws {
        let challenge = Day22(data: """
            1
            2
            3
            2024
            """)
        XCTAssertEqual(String(describing: challenge.part2()), "23")
    }
}
