//
//  SettingsViewController.swift
//  JTFitCalendar
//
//  Created by 김진태 on 4/13/24.
//

import SnapKit
import Then
import UIKit

// Tab Bar의 세 번째 화면인 Settings 화면에 대한 ViewController이다.
class SettingsViewController: UIViewController {
	
	// MARK: - View Properties
	// 화면 전체를 덮는 TableView이다.
	private let tableView: UITableView = UITableView(frame: .zero, style: .plain)
	
	// MARK: - View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
	}
	
	/// View에 대한 Constraint 및 속성을 설정하는 함수이다.
	private func setupViews() {
		view.backgroundColor = UIColor.jtBackgroundColor
		setupTableView()
	}
	
	/// TableView에 대한 Constraint 설정을 하는 함수이다.
	private func setupTableView() {
		view.addSubview(tableView)
		tableView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
}
