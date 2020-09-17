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

	func gameOver(result: GameEngine.Result)

	func rejected(at row: Int, column: Int)
}

final class GameEngine {

	let delegate: GameEngineDelegate

	private(set) var currentTurn: Player = .first
	private(set) var boxes: [[Symbols]] {
		didSet {
			checkForGameResult()
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

	private func checkForGameResult() {
		let currentPlayerSymbol: Symbols = (currentTurn == .first) ? .cross : .nought

		// Checking if any columns has been marked by a single player, so we can declare as a win
		for column in 0..<boxes.count {
			guard (boxes[0][column] == currentPlayerSymbol &&
				boxes[1][column] == currentPlayerSymbol &&
				boxes[2][column] == currentPlayerSymbol) else { continue }
			return delegate.gameOver(result: .win(currentTurn, [ (0, column), (1, column), (2, column) ]))
		}

		// Checking if any rows has been marked by a single player, so we can declare as a win
		for row in 0..<boxes.count {
			guard (boxes[row][0] == currentPlayerSymbol &&
				boxes[row][1] == currentPlayerSymbol &&
				boxes[row][2] == currentPlayerSymbol) else { continue }
			return delegate.gameOver(result: .win(currentTurn, [ (row, 0), (row, 1), (row, 2) ]))
		}

		// Checking if left to right diagonal sequence is marked
		if (boxes[0][0] == currentPlayerSymbol &&
			boxes[1][1] == currentPlayerSymbol &&
			boxes[2][2] == currentPlayerSymbol) {
			return delegate.gameOver(result: .win(currentTurn, [ (0, 0), (1, 1), (2, 2) ]))
		}

		if (boxes[2][0] == currentPlayerSymbol &&
			boxes[1][1] == currentPlayerSymbol &&
			boxes[0][2] == currentPlayerSymbol) {
			return delegate.gameOver(result: .win(currentTurn, [ (2, 0), (1, 1), (0, 2) ]))
		}
	}
}

extension GameEngine {

	enum Result {
		case win(_ player: Player, _ boxes: [(Int, Int)])
		case draw
	}
}
