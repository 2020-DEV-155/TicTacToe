import XCTest
@testable import TicTacToe

class GameEngineTests: XCTestCase {

	private var sut: GameEngine!
	private var delegate: MockDelegate!

	override func setUpWithError() throws {
		delegate = MockDelegate()
		sut = GameEngine(delegate: delegate)
	}

    override func tearDownWithError() throws {
		sut = nil
    }

	private func compare(winningCombination: [(Int, Int)]?, with expected: [(Int, Int)]) {
		XCTAssertEqual(winningCombination?[0].0, expected[0].0)
		XCTAssertEqual(winningCombination?[0].1, expected[0].1)
		XCTAssertEqual(winningCombination?[1].0, expected[1].0)
		XCTAssertEqual(winningCombination?[1].1, expected[1].1)
		XCTAssertEqual(winningCombination?[2].0, expected[2].0)
		XCTAssertEqual(winningCombination?[2].1, expected[2].1)
	}

	private func assertGameOverTrueAndDrawFalse() {
		XCTAssertTrue(delegate.isGameoverCalled)
		XCTAssertFalse(delegate.isGameDraw)
	}

	func test_WhenInitialised_ThenPlayer1HasTurn() {
		// given & when - initialised

		// then
		XCTAssertEqual(sut.currentTurn, .first)
	}

	func test_WhenFirstMoveIsPlayed_ThenDelegateIsCalledAndFirstTurnIsCross() {
		// given - initialised

		// when
		sut.play(atRow: 0, column: 0)

		// then
		XCTAssertTrue(delegate.isPlayCalled)
		XCTAssertEqual(delegate.playedRow, 0)
		XCTAssertEqual(delegate.playedColumn, 0)
		XCTAssertEqual(delegate.by, .first)
	}

	func test_WhenTwoMovesArePlayed_ThenSecondTurnIsNought() {
		// given - initialised

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
		// given - initialised

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
		// given - initialised

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

	func test_WhenPlayerMoveInAlreadyFilledBox_ThenTheMoveIsRejected() {
		// given - initialised

		// when
		sut.play(atRow: 0, column: 0) // Cross
		sut.play(atRow: 0, column: 0) // Nought - Should be rejected

		// then
		XCTAssertTrue(delegate.moveRejectedCalled)
		XCTAssertEqual(delegate.rejectedRow, 0)
		XCTAssertEqual(delegate.rejectedColumn, 0)
	}
}
// MARK: - Testing wins for columns
extension GameEngineTests {

	func test_WhenFirstPlayerMarksEntireColumn1_ThenDelegateIsCalled() {
		// given - initialised

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
		assertGameOverTrueAndDrawFalse()
		XCTAssertEqual(delegate.gameWonBy, .first)
		compare(winningCombination: delegate.winningCombination, with: [ (0,0), (1,0), (2,0)])
	}

	func test_WhenSecondPlayerMarksEntireColumn1_ThenDelegateIsCalled() {
		// given - initialised

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
		assertGameOverTrueAndDrawFalse()
		XCTAssertEqual(delegate.gameWonBy, .second)
		compare(winningCombination: delegate.winningCombination, with: [ (0,0), (1,0), (2,0)])
	}

	func test_WhenFirstPlayerMarksEntireColumn2_ThenDelegateIsCalled() {
		// given - initialised

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
		assertGameOverTrueAndDrawFalse()
		XCTAssertEqual(delegate.gameWonBy, .first)
		compare(winningCombination: delegate.winningCombination, with: [ (0,1), (1,1), (2,1)])
	}

	func test_WhenSecondPlayerMarksEntireColumn2_ThenDelegateIsCalled() {
		// given - initialised

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
		assertGameOverTrueAndDrawFalse()
		XCTAssertEqual(delegate.gameWonBy, .second)
		compare(winningCombination: delegate.winningCombination, with: [ (0,1), (1,1), (2,1)])
	}

	func test_WhenFirstPlayerMarksEntireColumn3_ThenDelegateIsCalled() {
		// given - initialised

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
		assertGameOverTrueAndDrawFalse()
		XCTAssertEqual(delegate.gameWonBy, .first)
		compare(winningCombination: delegate.winningCombination, with: [ (0,2), (1,2), (2,2)])
	}

	func test_WhenSecondPlayerMarksEntireColumn3_ThenDelegateIsCalled() {
		// given - initialised

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
		assertGameOverTrueAndDrawFalse()
		XCTAssertEqual(delegate.gameWonBy, .second)
		compare(winningCombination: delegate.winningCombination, with: [ (0,2), (1,2), (2,2)])
	}
}

// MARK: - Testing wins for rows
extension GameEngineTests {

	func test_WhenFirstPlayerMarksEntireRow1_ThenDelegateIsCalled() {
		// given - initialised

		// when
		/*
		X | X | X
		0 | - | -
		0 | - | -
		*/
		sut.play(atRow: 0, column: 0) // Cross
		sut.play(atRow: 1, column: 0) // Nought
		sut.play(atRow: 0, column: 1) // Cross
		sut.play(atRow: 2, column: 0) // Nought
		sut.play(atRow: 0, column: 2) // Cross

		// then
		assertGameOverTrueAndDrawFalse()
		XCTAssertEqual(delegate.gameWonBy, .first)
		compare(winningCombination: delegate.winningCombination, with: [ (0,0), (0,1), (0,2)])
	}

	func test_WhenSecondPlayerMarksEntireRow1_ThenDelegateIsCalled() {
		// given - initialised

		// when
		/*
		0 | 0 | 0
		- | X | X
		X | - | -
		*/
		sut.play(atRow: 2, column: 0) // Cross
		sut.play(atRow: 0, column: 0) // Nought
		sut.play(atRow: 1, column: 1) // Cross
		sut.play(atRow: 0, column: 1) // Nought
		sut.play(atRow: 1, column: 2) // Cross
		sut.play(atRow: 0, column: 2) // Nought

		// then
		assertGameOverTrueAndDrawFalse()
		XCTAssertEqual(delegate.gameWonBy, .second)
		compare(winningCombination: delegate.winningCombination, with: [ (0,0), (0,1), (0,2)])
	}

	func test_WhenFirstPlayerMarksEntireRow2_ThenDelegateIsCalled() {
		// given - initialised

		// when
		/*
		- | 0 | -
		X | X | X
		- | 0 | -
		*/
		sut.play(atRow: 1, column: 0) // Cross
		sut.play(atRow: 0, column: 1) // Nought
		sut.play(atRow: 1, column: 1) // Cross
		sut.play(atRow: 2, column: 1) // Nought
		sut.play(atRow: 1, column: 2) // Cross

		// then
		assertGameOverTrueAndDrawFalse()
		XCTAssertEqual(delegate.gameWonBy, .first)
		compare(winningCombination: delegate.winningCombination, with: [ (1,0), (1,1), (1,2)])
	}

	func test_WhenSecondPlayerMarksEntireRow2_ThenDelegateIsCalled() {
		// given - initialised

		// when
		/*
		- | X | -
		0 | 0 | 0
		X | X | -
		*/
		sut.play(atRow: 0, column: 1) // Cross
		sut.play(atRow: 1, column: 0) // Nought
		sut.play(atRow: 2, column: 0) // Cross
		sut.play(atRow: 1, column: 1) // Nought
		sut.play(atRow: 2, column: 1) // Cross
		sut.play(atRow: 1, column: 2) // Nought

		// then
		assertGameOverTrueAndDrawFalse()
		XCTAssertEqual(delegate.gameWonBy, .second)
		compare(winningCombination: delegate.winningCombination, with: [ (1,0), (1,1), (1,2)])
	}

	func test_WhenFirstPlayerMarksEntireRow3_ThenDelegateIsCalled() {
		// given - initialised

		// when
		/*
		0 | - | -
		0 | - | -
		X | X | X
		*/
		sut.play(atRow: 2, column: 0) // Cross
		sut.play(atRow: 0, column: 0) // Nought
		sut.play(atRow: 2, column: 1) // Cross
		sut.play(atRow: 1, column: 0) // Nought
		sut.play(atRow: 2, column: 2) // Cross

		// then
		assertGameOverTrueAndDrawFalse()
		XCTAssertEqual(delegate.gameWonBy, .first)
		compare(winningCombination: delegate.winningCombination, with: [ (2,0), (2,1), (2,2)])
	}

	func test_WhenSecondPlayerMarksEntireRow3_ThenDelegateIsCalled() {
		// given - initialised

		// when
		/*
		X | X | -
		X | - | -
		0 | 0 | 0
		*/
		sut.play(atRow: 0, column: 0) // Cross
		sut.play(atRow: 2, column: 0) // Nought
		sut.play(atRow: 0, column: 1) // Cross
		sut.play(atRow: 2, column: 1) // Nought
		sut.play(atRow: 1, column: 0) // Cross
		sut.play(atRow: 2, column: 2) // Nought

		// then
		assertGameOverTrueAndDrawFalse()
		XCTAssertEqual(delegate.gameWonBy, .second)
		compare(winningCombination: delegate.winningCombination, with: [ (2,0), (2,1), (2,2)])
	}
}

// MARK: - Testing diagonal wins
extension GameEngineTests {

	func test_WhenFirstPlayerMarksLeftToRightDiagonalSequence_ThenDelegateIsCalled() {
		// given - initialised

		// when
		/*
		X | - | -
		0 | X | -
		0 | - | X
		*/
		sut.play(atRow: 0, column: 0) // Cross
		sut.play(atRow: 1, column: 0) // Nought
		sut.play(atRow: 1, column: 1) // Cross
		sut.play(atRow: 2, column: 0) // Nought
		sut.play(atRow: 2, column: 2) // Cross

		// then
		assertGameOverTrueAndDrawFalse()
		XCTAssertEqual(delegate.gameWonBy, .first)
		compare(winningCombination: delegate.winningCombination, with: [ (0,0), (1,1), (2,2)])
	}

	func test_WhenSecondPlayerMarksLeftToRightDiagonalSequence_ThenDelegateIsCalled() {
		// given - initialised

		// when
		/*
		0 | - | -
		X | 0 | -
		X | X | 0
		*/
		sut.play(atRow: 1, column: 0) // Cross
		sut.play(atRow: 0, column: 0) // Nought
		sut.play(atRow: 2, column: 0) // Cross
		sut.play(atRow: 1, column: 1) // Nought
		sut.play(atRow: 2, column: 1) // Cross
		sut.play(atRow: 2, column: 2) // Nought

		// then
		assertGameOverTrueAndDrawFalse()
		XCTAssertEqual(delegate.gameWonBy, .second)
		compare(winningCombination: delegate.winningCombination, with: [ (0,0), (1,1), (2,2)])
	}

	func test_WhenFirstPlayerMarksRightToLeftDiagonalSequence_ThenDelegateIsCalled() {
		// given - initialised

		// when
		/*
		0 | - | X
		- | X | -
		X | - | 0
		*/
		sut.play(atRow: 2, column: 0) // Cross
		sut.play(atRow: 0, column: 0) // Nought
		sut.play(atRow: 1, column: 1) // Cross
		sut.play(atRow: 2, column: 2) // Nought
		sut.play(atRow: 0, column: 2) // Cross

		// then
		assertGameOverTrueAndDrawFalse()
		XCTAssertEqual(delegate.gameWonBy, .first)
		compare(winningCombination: delegate.winningCombination, with: [ (2,0), (1,1), (0,2)])
	}

	func test_WhenSecondPlayerMarksRightToLeftDiagonalSequence_ThenDelegateIsCalled() {
		// given - initialised

		// when
		/*
		X | - | 0
		X | 0 | -
		0 | X | 0
		*/
		sut.play(atRow: 0, column: 0) // Cross
		sut.play(atRow: 0, column: 2) // Nought
		sut.play(atRow: 1, column: 0) // Cross
		sut.play(atRow: 1, column: 1) // Nought
		sut.play(atRow: 2, column: 1) // Cross
		sut.play(atRow: 2, column: 0) // Nought

		// then
		assertGameOverTrueAndDrawFalse()
		XCTAssertEqual(delegate.gameWonBy, .second)
		compare(winningCombination: delegate.winningCombination, with: [ (2,0), (1,1), (0,2)])
	}
}

class MockDelegate: GameEngineDelegate {

	private(set) var isPlayCalled = false
	private(set) var playedRow: Int?
	private(set) var playedColumn: Int?
	private(set) var by: Player?

	private(set) var isGameoverCalled = false
	private(set) var isGameDraw = false
	private(set) var gameWonBy: Player?
	private(set) var winningCombination: [(Int, Int)]?

	private(set) var moveRejectedCalled = false
	private(set) var rejectedRow: Int?
	private(set) var rejectedColumn: Int?

	func played(at row: Int, column: Int, by player: Player) {
		isPlayCalled = true
		playedRow = row
		playedColumn = column
		by = player
	}

	func gameOver(result: GameEngine.Result) {
		isGameoverCalled = true
		switch result {
		case .win(let player, let boxes):
			gameWonBy = player
			winningCombination = boxes
		case .draw:
			isGameDraw = true
		}
	}

	func rejected(at row: Int, column: Int) {
		moveRejectedCalled = true
		rejectedRow = row
		rejectedColumn = column
	}
}
