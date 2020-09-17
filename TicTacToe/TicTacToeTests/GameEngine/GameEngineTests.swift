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
		XCTAssertEqual(sut.currentTurn, .cross)
	}

	func test_WhenFirstMoveIsPlayed_ThenDelegateIsCalledAndFirstTurnIsCross() {
		// given
		let delegate = MockDelegate()
		sut = GameEngine(delegate: delegate)

		// when
		sut.play(atRow: 0, column: 0)

		// then
		XCTAssertTrue(delegate.isPlayCalled)
		XCTAssertEqual(delegate.playedRow, 0)
		XCTAssertEqual(delegate.playedColumn, 0)
		XCTAssertEqual(delegate.by, .cross)
	}

	func test_WhenTwoMovesArePlayed_ThenSecondTurnIsIsNought() {
		// given
		let delegate = MockDelegate()
		sut = GameEngine(delegate: delegate)

		// when
		sut.play(atRow: 0, column: 1)
		sut.play(atRow: 1, column: 1)

		// then
		XCTAssertTrue(delegate.isPlayCalled)
		XCTAssertEqual(delegate.playedRow, 1)
		XCTAssertEqual(delegate.playedColumn, 1)
		XCTAssertEqual(delegate.by, .nought)
	}
}

class MockDelegate: GameEngineDelegate {

	private(set) var isPlayCalled = false
	private(set) var playedRow: Int?
	private(set) var playedColumn: Int?
	private(set) var by: Player?

	func played(at row: Int, column: Int, by player: Player) {
		isPlayCalled = true
		playedRow = row
		playedColumn = column
		by = player
	}
}
