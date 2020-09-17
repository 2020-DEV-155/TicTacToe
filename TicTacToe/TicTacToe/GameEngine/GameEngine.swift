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

	func reset() {
		currentTurn = .first
		boxes = Array(repeating: Array(repeating: .empty, count: 3), count: 3)
	}

	private func fill(at row: Int, column: Int) {
		guard boxes[row][column] == .empty else {
			return delegate.rejected(at: row, column: column)
		}
		boxes[row][column] = (currentTurn == .first) ? .cross : .nought
	}

	private func checkForGameResult() {
		let currentPlayerSymbol: Symbols = (currentTurn == .first) ? .cross : .nought

		guard !checkForColumsWin(currentPlayerSymbol) else { return }

		guard !checkForRowsWin(currentPlayerSymbol) else { return }

		guard !checkForLeftToRightDiagonalWin(currentPlayerSymbol) else { return }

		guard !checkForRightToLeftDiagonalWin(currentPlayerSymbol) else { return }

		guard !checkForDrawAfterWinningChecksAreCompleted() else { return }
	}

	private func checkForColumsWin(_ currentPlayerSymbol: Symbols) -> Bool {
		// Checking if any columns has been marked by a single player, so we can declare as a win
		for column in 0..<boxes.count {
			guard (boxes[0][column] == currentPlayerSymbol &&
				boxes[1][column] == currentPlayerSymbol &&
				boxes[2][column] == currentPlayerSymbol) else { continue }
			delegate.gameOver(result: .win(currentTurn, [ (0, column), (1, column), (2, column) ]))
			return true
		}
		return false
	}

	private func checkForRowsWin(_ currentPlayerSymbol: Symbols) -> Bool {
		// Checking if any rows has been marked by a single player, so we can declare as a win
		for row in 0..<boxes.count {
			guard (boxes[row][0] == currentPlayerSymbol &&
				boxes[row][1] == currentPlayerSymbol &&
				boxes[row][2] == currentPlayerSymbol) else { continue }
			delegate.gameOver(result: .win(currentTurn, [ (row, 0), (row, 1), (row, 2) ]))
			return true
		}
		return false
	}

	private func checkForLeftToRightDiagonalWin(_ currentPlayerSymbol: Symbols) -> Bool {
		// Checking if left to right diagonal sequence is marked
		guard (boxes[0][0] == currentPlayerSymbol &&
			boxes[1][1] == currentPlayerSymbol &&
			boxes[2][2] == currentPlayerSymbol) else { return false }
		delegate.gameOver(result: .win(currentTurn, [ (0, 0), (1, 1), (2, 2) ]))
		return true
	}

	private func checkForRightToLeftDiagonalWin(_ currentPlayerSymbol: Symbols) -> Bool {
		// Checking if left to right diagonal sequence is marked
		guard (boxes[2][0] == currentPlayerSymbol &&
			boxes[1][1] == currentPlayerSymbol &&
			boxes[0][2] == currentPlayerSymbol) else { return false }
		delegate.gameOver(result: .win(currentTurn, [ (2, 0), (1, 1), (0, 2) ]))
		return true
	}

	private func checkForDrawAfterWinningChecksAreCompleted() -> Bool {
		guard areAllBoxesFilled() else { return false }
		delegate.gameOver(result: .draw)
		return true
	}

	private func areAllBoxesFilled() -> Bool {
		for column in 0..<boxes.count {
			if (boxes[0][column] == .empty ||
				boxes[1][column] == .empty ||
				boxes[2][column] == .empty) {
				return false
			}
		}
		return true
	}
}

extension GameEngine {

	enum Result {
		case win(_ player: Player, _ boxes: [(Int, Int)])
		case draw
	}
}
