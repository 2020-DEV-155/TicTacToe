import Foundation

enum Turn {
	case player1
	case player2
}

final class GameEngine {

	private(set) var currentTurn: Turn = .player1
}
