//
//  UITableView+Ext.swift
//  JTFitCalendar
//
//  Created by 김진태 on 4/13/24.
//

import UIKit

extension UITableView {
	func register<T: UITableViewCell>(withType type: T.Type) {
		self.register(T.self, forCellReuseIdentifier: type.identifier)
	}
	
	func dequeueReusableCell<T: UITableViewCell>(withType type: T.Type, for indexPath: IndexPath) -> T {
		return self.dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as! T
	}
}
