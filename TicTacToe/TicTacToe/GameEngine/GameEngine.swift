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

	func played(at row: Int, column: Int, by player: Player, symbol: Symbols)

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
	private(set) var result: Result?

	init(delegate: GameEngineDelegate) {
		self.delegate = delegate
		boxes = Array(repeating: Array(repeating: .empty, count: 3), count: 3)
	}

	func play(atRow row: Int, column: Int) {

		// If game is already over then do not proceed
		guard result == nil else {
			delegate.rejected(at: row, column: column)
			return
		}

		// Make the move
		guard let symbol = fill(at: row, column: column) else { return }

		// Update the delegate
		delegate.played(at: row, column: column, by: currentTurn, symbol: symbol)

		// Switch the turn
		currentTurn = (currentTurn == .first) ? .second : .first
	}

	func reset() {
		currentTurn = .first
		boxes = Array(repeating: Array(repeating: .empty, count: 3), count: 3)
		result = nil
	}

	private func fill(at row: Int, column: Int) -> Symbols? {
		guard boxes[row][column] == .empty else {
			delegate.rejected(at: row, column: column)
			return nil
		}
		boxes[row][column] = (currentTurn == .first) ? .cross : .nought
		return boxes[row][column]
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

			let result = Result.win(currentTurn, [ (0, column), (1, column), (2, column) ])
			self.result = result
			delegate.gameOver(result: result)
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
			let result = Result.win(currentTurn, [ (row, 0), (row, 1), (row, 2) ])
			self.result = result
			delegate.gameOver(result: result)
			return true
		}
		return false
	}

	private func checkForLeftToRightDiagonalWin(_ currentPlayerSymbol: Symbols) -> Bool {
		// Checking if left to right diagonal sequence is marked
		guard (boxes[0][0] == currentPlayerSymbol &&
			boxes[1][1] == currentPlayerSymbol &&
			boxes[2][2] == currentPlayerSymbol) else { return false }
		let result = Result.win(currentTurn, [ (0, 0), (1, 1), (2, 2) ])
		self.result = result
		delegate.gameOver(result: result)
		return true
	}

	private func checkForRightToLeftDiagonalWin(_ currentPlayerSymbol: Symbols) -> Bool {
		// Checking if left to right diagonal sequence is marked
		guard (boxes[2][0] == currentPlayerSymbol &&
			boxes[1][1] == currentPlayerSymbol &&
			boxes[0][2] == currentPlayerSymbol) else { return false }
		let result = Result.win(currentTurn, [ (2, 0), (1, 1), (0, 2) ])
		self.result = result
		delegate.gameOver(result: result)
		return true
	}

	private func checkForDrawAfterWinningChecksAreCompleted() -> Bool {
		guard areAllBoxesFilled() else { return false }
		delegate.gameOver(result: .draw)
		result = .draw
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
