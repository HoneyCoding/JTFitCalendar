//
//  UIViewController+showAlert.swift
//  JTFitCalendar
//
//  Created by 김진태 on 4/14/24.
//

import UIKit

extension UIViewController {
	func showAlert(title: String? = nil, message: String?) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "확인", style: .default)
		alertController.addAction(okAction)
		self.present(alertController, animated: true)
	}
}
