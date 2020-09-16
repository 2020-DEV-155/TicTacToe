import XCTest
@testable import TicTacToe

class GameEngineTests: XCTestCase {

	var sut: GameEngine!

    override func tearDownWithError() throws {
		sut = nil
    }

	func test_WhenInitialised_ThenPlayer1HasTurn() {
		// given & when
		sut = GameEngine()

		// then
		XCTAssertEqual(sut.currentTurn, .player1)
	}
}
