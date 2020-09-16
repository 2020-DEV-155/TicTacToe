import XCTest
@testable import TicTacToe

class GameEngineTests: XCTestCase {

	var sut: GameEngine!

    override func tearDownWithError() throws {
		sut = nil
    }

	func test_WhenInitialised_ThenPlayer1HasTurn() {
		// given & when
		sut = GameEngine(delegate: MockDelegate())

		// then
		XCTAssertEqual(sut.currentTurn, .player1)
	}

	func test_WhenMoveIsPlayed_ThenDelegateIsCalled() {
		// given
		let delegate = MockDelegate()
		sut = GameEngine(delegate: delegate)

		// when
		sut.play(atRow: 0, column: 0)

		// then
		XCTAssertTrue(delegate.isPlayCalled)
		XCTAssertEqual(delegate.playedColumn, 0)
		XCTAssertEqual(delegate.playedRow, 0)
	}
}

class MockDelegate: GameEngineDelegate {

	private(set) var isPlayCalled = false
	private(set) var playedRow: Int?
	private(set) var playedColumn: Int?

	func played(at row: Int, column: Int) {
		isPlayCalled = true
		playedRow = row
		playedColumn = column
	}
}
