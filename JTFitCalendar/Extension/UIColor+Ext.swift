//
//  UIColor+Ext.swift
//  JTFitCalendar
//
//  Created by 김진태 on 4/14/24.
//

import UIKit

extension UIColor {
	
	/// rgb를 0~255 사이의 Int로 표현하여 UIColor를 생성하는 생성자이다.
	/// - Parameters:
	///   - red: 0~255 사이의 r 값을 전달한다.
	///   - green: 0~255 사이의 g 값을 전달한다.
	///   - blue: 0~255 사이의 b 값을 전달한다.
	///   - alpha: 0~1 사이의 alpha 값을 전달한다. 기본값은 1이다.
	convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
		let r = CGFloat(red) / 255.0
		let g = CGFloat(green) / 255.0
		let b = CGFloat(blue) / 255.0
		
		self.init(red: r, green: g, blue: b, alpha: alpha)
	}
	
	/// 앱의 Primary Color이다.
	static let primaryColor = UIColor(red: 255, green: 166, blue: 2)
	/// 비어있는 UIImageView의 backgroundColor이다.
	static let emptyImageBackgroundColor = UIColor(red: 245, green: 239, blue: 232)
	/// Result Text의 Color이다.
	static let resultTextColor = UIColor(red: 144, green: 119, blue: 66)
	/// Fit Calendar 앱의 기본 Gray Color이다.
	static let jtGray = UIColor.systemGray6
	/// Fit Calendar 앱의 기본 Background Color이다.
	static let jtBackgroundColor = UIColor(red: 253, green: 251, blue: 249)
}
