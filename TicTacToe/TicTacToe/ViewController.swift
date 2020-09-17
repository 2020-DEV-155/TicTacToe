import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var mainStackView: UIStackView!
	@IBOutlet weak var player1Label: UILabel!
	@IBOutlet weak var player2Label: UILabel!

	private lazy var game = GameEngine(delegate: self)

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		animatePlayerViewLabels()
	}

	@IBAction func buttonTapped(_ sender: UIButton) {
		guard let superview = sender.superview as? UIStackView,
			let row = superview.arrangedSubviews.firstIndex(of: sender),
			let column = mainStackView.arrangedSubviews.firstIndex(of: superview) else { return }
		game.play(atRow: row, column: column)
	}

	@IBAction func startOverButtonTapped(_ sender: UIButton) {
		reset()
	}

	private func animatePlayerViewLabels() {
		UIView.animate(withDuration: 0.27) {
			switch self.game.currentTurn {
			case .first:
				self.player1Label.transform = .init(scaleX: 1.5, y: 1.5)
				self.player2Label.transform = .identity
			case .second:
				self.player1Label.transform = .identity
				self.player2Label.transform = .init(scaleX: 1.5, y: 1.5)
			}
		}
	}

	private func reset() {
		game.reset()
		animatePlayerViewLabels()
		mainStackView.arrangedSubviews.forEach { (view) in
			guard let stackView = view as? UIStackView else { return }
			stackView.arrangedSubviews.forEach { (view) in
				guard let button = view as? UIButton else { return }
				button.setImage(nil, for: .normal)
			}
		}
	}
}

extension ViewController: GameEngineDelegate {

	func played(at row: Int, column: Int, by player: Player, symbol: Symbols) {
		guard let stackView = mainStackView.arrangedSubviews[column] as? UIStackView,
			let button = stackView.arrangedSubviews[row] as? UIButton
			else { return }

		let cross = UIImage(named: "cross")
		let nought = UIImage(named: "nought")
		button.setImage((symbol == .cross) ? cross : nought, for: .normal)

		animatePlayerViewLabels()
	}

	func gameOver(result: GameEngine.Result) {
		switch result {
		case .win(let player, _):
			let playerName: String!
			switch player {
			case .first: playerName = "Player1"
			case .second: playerName = "Player2"
			}
			showAlertWithOKButton(title: "Game over", message: playerName + " has won!")
		case .draw:
			showAlertWithOKButton(title: "Game over", message: "It was a draw!")
		}
	}

	func rejected(at row: Int, column: Int) {
		showAlertWithOKButton(title: "Error", message: "Invalid move")
	}
}
