//
//  UIColor+Ext.swift
//  JTFitCalendar
//
//  Created by 김진태 on 4/14/24.
//

import UIKit

extension UIColor {
	convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
		let r = CGFloat(red) / 255.0
		let g = CGFloat(green) / 255.0
		let b = CGFloat(blue) / 255.0
		
		self.init(red: r, green: g, blue: b, alpha: alpha)
	}
	
	static let primaryColor = UIColor(red: 255, green: 166, blue: 2)
	static let emptyImageBackgroundColor = UIColor(red: 245, green: 239, blue: 232)
	static let resultTextColor = UIColor(red: 144, green: 119, blue: 66)
	static let jtGray = UIColor.systemGray6
	static let jtBackgroundColor = UIColor(red: 253, green: 251, blue: 249)
}
