//
//  UICollectionViewCell+Ext.swift
//  JTFitCalendar
//
//  Created by 김진태 on 4/13/24.
//

import UIKit

extension UICollectionViewCell {
	/// Cell의 identifier이다.
	static var identifier: String {
		return String(describing: Self.self)
	}
}
