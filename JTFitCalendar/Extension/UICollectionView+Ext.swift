//
//  UICollectionView+Ext.swift
//  JTFitCalendar
//
//  Created by 김진태 on 4/13/24.
//

import UIKit

extension UICollectionView {
	func register<T: UICollectionViewCell>(withType type: T.Type) {
		self.register(T.self, forCellWithReuseIdentifier: type.identifier)
	}
	
	func dequeueReusableCell<T: UICollectionViewCell>(withType type: T.Type, for indexPath: IndexPath) -> T {
		return self.dequeueReusableCell(withReuseIdentifier: type.identifier, for: indexPath) as! T
	}
}
