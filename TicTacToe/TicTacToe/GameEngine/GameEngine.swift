import Foundation

enum Player {
	case cross
	case nought
}

protocol GameEngineDelegate {

	func played(at row: Int, column: Int, by player: Player)
}

final class GameEngine {

	let delegate: GameEngineDelegate

	private(set) var currentTurn: Player = .cross

	init(delegate: GameEngineDelegate) {
		self.delegate = delegate
	}

	func play(atRow row: Int, column: Int) {
		delegate.played(at: row, column: column, by: currentTurn)

		switch currentTurn {
		case .cross: currentTurn = .nought
		case .nought: currentTurn = .cross
		}
	}
}
