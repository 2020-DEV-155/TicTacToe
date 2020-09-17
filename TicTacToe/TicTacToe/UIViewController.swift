import UIKit

extension UIViewController {

	func showAlertWithOKButton(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(.init(title: "OK", style: .default, handler: nil))
		present(alert, animated: true, completion: nil)
	}
}
