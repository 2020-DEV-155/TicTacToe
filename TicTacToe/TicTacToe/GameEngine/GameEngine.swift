import Foundation

enum Player: Int {
	case first = 0
	case second = 1
}

enum Symbols {
	case empty
	case nought
	case cross
}

protocol GameEngineDelegate {

	func played(at row: Int, column: Int, by player: Player)

	func gameOver(by player: Player)
}

final class GameEngine {

	let delegate: GameEngineDelegate

	private(set) var currentTurn: Player = .first
	private(set) var boxes: [[Symbols]] {
		didSet {
			if isGameOver() {
				delegate.gameOver(by: currentTurn)
			}
		}
	}

	init(delegate: GameEngineDelegate) {
		self.delegate = delegate
		boxes = Array(repeating: Array(repeating: .empty, count: 3), count: 3)
	}

	func play(atRow row: Int, column: Int) {

		// Make the move
		boxes[row][column] = (currentTurn == .first) ? .cross : .nought

		// Update the delegate
		delegate.played(at: row, column: column, by: currentTurn)

		// Switch the turn
		switch currentTurn {
		case .first: currentTurn = .second
		case .second: currentTurn = .first
		}
	}

	private func isGameOver() -> Bool {
		let currentPlayerSymbol: Symbols!
		switch currentTurn {
		case .first: currentPlayerSymbol = .cross
		case .second: currentPlayerSymbol = .nought
		}

		if boxes[0][0] == currentPlayerSymbol,
			boxes[1][0] == currentPlayerSymbol,
			boxes[2][0] == currentPlayerSymbol {
			// First column
			return true
		}
		return false
	}
}
