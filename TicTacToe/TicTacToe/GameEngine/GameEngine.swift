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

	func rejected(at row: Int, column: Int)
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
		fill(at: row, column: column)

		// Update the delegate
		delegate.played(at: row, column: column, by: currentTurn)

		// Switch the turn
		currentTurn = (currentTurn == .first) ? .second : .first
	}

	private func fill(at row: Int, column: Int) {
		guard boxes[row][column] == .empty else {
			return delegate.rejected(at: row, column: column)
		}
		boxes[row][column] = (currentTurn == .first) ? .cross : .nought
	}

	private func isGameOver() -> Bool {
		let currentPlayerSymbol: Symbols = (currentTurn == .first) ? .cross : .nought

		// Checking if any columns or rows has been marked by a single player, so we can declare as a win
		for column in 0..<boxes.count {
			for row in 0..<boxes.count {
				guard (boxes[row][column] == currentPlayerSymbol &&
					boxes[row][column] == currentPlayerSymbol &&
					boxes[row][column] == currentPlayerSymbol) else { continue }
				return true
			}
		}

		return false
	}
}
