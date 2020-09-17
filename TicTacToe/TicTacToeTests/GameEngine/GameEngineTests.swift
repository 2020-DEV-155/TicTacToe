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
		XCTAssertEqual(sut.currentTurn, .first)
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
		XCTAssertEqual(delegate.by, .first)
	}

	func test_WhenTwoMovesArePlayed_ThenSecondTurnIsNought() {
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
		XCTAssertEqual(delegate.by, .second)
	}

	func test_WhenNoMovesArePlayed_ThenTheBoxesAreEmpty() {
		// given
		sut = GameEngine(delegate: MockDelegate())

		// when - no moves are played

		// then
		XCTAssertEqual(sut.boxes[0][0], .empty)
		XCTAssertEqual(sut.boxes[0][1], .empty)
		XCTAssertEqual(sut.boxes[0][2], .empty)
		XCTAssertEqual(sut.boxes[1][0], .empty)
		XCTAssertEqual(sut.boxes[1][1], .empty)
		XCTAssertEqual(sut.boxes[1][2], .empty)
		XCTAssertEqual(sut.boxes[2][0], .empty)
		XCTAssertEqual(sut.boxes[2][1], .empty)
		XCTAssertEqual(sut.boxes[2][2], .empty)
	}

	func test_WhenFirstMoveIsPlayed_ThenOnlyTheSpecifiedBoxIsFilled() {
		// given
		sut = GameEngine(delegate: MockDelegate())

		// when
		sut.play(atRow: 0, column: 1)

		// then
		XCTAssertEqual(sut.boxes[0][0], .empty)
		XCTAssertEqual(sut.boxes[0][1], .cross)
		XCTAssertEqual(sut.boxes[0][2], .empty)
		XCTAssertEqual(sut.boxes[1][0], .empty)
		XCTAssertEqual(sut.boxes[1][1], .empty)
		XCTAssertEqual(sut.boxes[1][2], .empty)
		XCTAssertEqual(sut.boxes[2][0], .empty)
		XCTAssertEqual(sut.boxes[2][1], .empty)
		XCTAssertEqual(sut.boxes[2][2], .empty)
	}

	func test_WhenFirstPlayerMarksEntireColumn1_ThenDelegateIsCalled() {
		// given
		let delegate = MockDelegate()
		sut = GameEngine(delegate: delegate)

		// when
		/*
		X | 0 | -
		X | 0 | -
		X | - | -
		*/
		sut.play(atRow: 0, column: 0) // Cross
		sut.play(atRow: 0, column: 1) // Nought
		sut.play(atRow: 1, column: 0) // Cross
		sut.play(atRow: 1, column: 1) // Nought
		sut.play(atRow: 2, column: 0) // Cross

		// then
		XCTAssertTrue(delegate.isGameoverCalled)
		XCTAssertEqual(delegate.gameWonBy, .first)
	}

	func test_WhenSecondPlayerMarksEntireColumn1_ThenDelegateIsCalled() {
		// given
		let delegate = MockDelegate()
		sut = GameEngine(delegate: delegate)

		// when
		/*
		0 | X | -
		0 | X | X
		0 | - | -
		*/
		sut.play(atRow: 1, column: 2) // Cross
		sut.play(atRow: 0, column: 0) // Nought
		sut.play(atRow: 0, column: 1) // Cross
		sut.play(atRow: 1, column: 0) // Nought
		sut.play(atRow: 1, column: 1) // Cross
		sut.play(atRow: 2, column: 0) // Nought

		// then
		XCTAssertTrue(delegate.isGameoverCalled)
		XCTAssertEqual(delegate.gameWonBy, .second)
	}

	func test_WhenFirstPlayerMarksEntireColumn2_ThenDelegateIsCalled() {
		// given
		let delegate = MockDelegate()
		sut = GameEngine(delegate: delegate)

		// when
		/*
		0 | X | -
		0 | X | -
		- | X | -
		*/
		sut.play(atRow: 0, column: 1) // Cross
		sut.play(atRow: 0, column: 0) // Nought
		sut.play(atRow: 1, column: 1) // Cross
		sut.play(atRow: 1, column: 0) // Nought
		sut.play(atRow: 2, column: 1) // Cross

		// then
		XCTAssertTrue(delegate.isGameoverCalled)
		XCTAssertEqual(delegate.gameWonBy, .first)
	}

	func test_WhenSecondPlayerMarksEntireColumn2_ThenDelegateIsCalled() {
		// given
		let delegate = MockDelegate()
		sut = GameEngine(delegate: delegate)

		// when
		/*
		X | 0 | X
		X | 0 | -
		- | 0 | -
		*/
		sut.play(atRow: 0, column: 0) // Cross
		sut.play(atRow: 0, column: 1) // Nought
		sut.play(atRow: 1, column: 0) // Cross
		sut.play(atRow: 1, column: 1) // Nought
		sut.play(atRow: 0, column: 2) // Cross
		sut.play(atRow: 2, column: 1) // Nought

		// then
		XCTAssertTrue(delegate.isGameoverCalled)
		XCTAssertEqual(delegate.gameWonBy, .second)
	}

	func test_WhenFirstPlayerMarksEntireColumn3_ThenDelegateIsCalled() {
		// given
		let delegate = MockDelegate()
		sut = GameEngine(delegate: delegate)

		// when
		/*
		0 | - | X
		0 | - | X
		- | - | X
		*/
		sut.play(atRow: 0, column: 2) // Cross
		sut.play(atRow: 0, column: 0) // Nought
		sut.play(atRow: 1, column: 2) // Cross
		sut.play(atRow: 1, column: 0) // Nought
		sut.play(atRow: 2, column: 2) // Cross

		// then
		XCTAssertTrue(delegate.isGameoverCalled)
		XCTAssertEqual(delegate.gameWonBy, .first)
	}

	func test_WhenSecondPlayerMarksEntireColumn3_ThenDelegateIsCalled() {
		// given
		let delegate = MockDelegate()
		sut = GameEngine(delegate: delegate)

		// when
		/*
		X | X | 0
		X | - | 0
		- | - | 0
		*/
		sut.play(atRow: 0, column: 0) // Cross
		sut.play(atRow: 0, column: 2) // Nought
		sut.play(atRow: 1, column: 0) // Cross
		sut.play(atRow: 1, column: 2) // Nought
		sut.play(atRow: 0, column: 1) // Cross
		sut.play(atRow: 2, column: 2) // Nought

		// then
		XCTAssertTrue(delegate.isGameoverCalled)
		XCTAssertEqual(delegate.gameWonBy, .second)
	}
}

class MockDelegate: GameEngineDelegate {

	private(set) var isPlayCalled = false
	private(set) var playedRow: Int?
	private(set) var playedColumn: Int?
	private(set) var by: Player?

	private(set) var isGameoverCalled = false
	private(set) var gameWonBy: Player?

	func played(at row: Int, column: Int, by player: Player) {
		isPlayCalled = true
		playedRow = row
		playedColumn = column
		by = player
	}

	func gameOver(by player: Player) {
		isGameoverCalled = true
		gameWonBy = player
	}
}
