import Foundation

enum Turn {
	case player1
	case player2
}

protocol GameEngineDelegate {

	func played(at row: Int, column: Int)
}

final class GameEngine {

	let delegate: GameEngineDelegate

	private(set) var currentTurn: Turn = .player1

	init(delegate: GameEngineDelegate) {
		self.delegate = delegate
	}

	func play(atRow row: Int, column: Int) {
		delegate.played(at: row, column: column)
	}
}
