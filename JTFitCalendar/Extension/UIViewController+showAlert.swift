//
//  UIViewController+showAlert.swift
//  JTFitCalendar
//
//  Created by 김진태 on 4/14/24.
//

import UIKit

extension UIViewController {
	
	/// Alert를 띄워주는 함수이다.
	/// - Parameters:
	///   - title: 띄우고자 하는 title을 전달한다. 기본 값은 nil이다.
	///   - message: 띄우고자 하는 message를 전달한다.
	func showAlert(title: String? = nil, message: String?) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "확인", style: .default)
		alertController.addAction(okAction)
		self.present(alertController, animated: true)
	}
}
