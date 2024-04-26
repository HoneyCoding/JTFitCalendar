//
//  UITableView+Ext.swift
//  JTFitCalendar
//
//  Created by 김진태 on 4/13/24.
//

import UIKit

extension UITableView {
	/// Cell로 사용할 UITableViewCell의 클래스를 등록하는 함수이다.
	/// - Parameter type: 등록하고자 하는 Cell의 타입을 전달한다. 예) UITableViewCell.Self
	func register<T: UITableViewCell>(withType type: T.Type) {
		self.register(T.self, forCellReuseIdentifier: type.identifier)
	}
	
	/// UITableViewCell의 타입에 따라 재사용 가능한 Cell을 dequeue하는 메서드이다.
	/// - Parameters:
	///   - type: 재사용하려는 UITableViewCell의 타입
	///   - indexPath: cell의 위치를 표현하는 indexPath
	/// - Returns: 전달받은 UITableViewCell의 타입과 일치하는 cell
	func dequeueReusableCell<T: UITableViewCell>(withType type: T.Type, for indexPath: IndexPath) -> T {
		return self.dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as! T
	}
}
