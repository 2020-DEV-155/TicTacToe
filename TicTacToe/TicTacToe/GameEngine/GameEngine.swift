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

		var winningCombinationFound = false
		var winningCombination = [(Int, Int)]()

		// Checking if any columns has been marked by a single player, so we can declare as a win
		for column in 0..<boxes.count {
			guard (boxes[0][column] == currentPlayerSymbol &&
				boxes[1][column] == currentPlayerSymbol &&
				boxes[2][column] == currentPlayerSymbol) else { continue }
			winningCombinationFound = true
			winningCombination = [ (0, column), (1, column), (2, column) ]
			break
		}

		// Checking if any rows has been marked by a single player, so we can declare as a win
		for row in 0..<boxes.count {
			guard (boxes[row][0] == currentPlayerSymbol &&
				boxes[row][1] == currentPlayerSymbol &&
				boxes[row][2] == currentPlayerSymbol) else { continue }
			winningCombinationFound = true
			winningCombination = [ (row, 0), (row, 1), (row, 2) ]
			break
		}

		if winningCombinationFound {
			delegate.gameOver(result: .win(currentTurn, winningCombination))
		}
	}
}

extension GameEngine {

	enum Result {
		case win(_ player: Player, _ boxes: [(Int, Int)])
		case draw
	}
}
