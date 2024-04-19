//
//  FitListViewController.swift
//  JTFitCalendar
//
//  Created by 김진태 on 4/13/24.
//

import SnapKit
import Then
import UIKit

class FitListViewController: UIViewController {
	
	private let tableView: UITableView = UITableView().then {
		$0.separatorStyle = .none
		$0.backgroundColor = UIColor.jtBackgroundColor
	}
	
	var fitnessLogEntities: [FitnessLogEntity] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
	}
	
	private func setupViews() {
		view.backgroundColor = UIColor.jtBackgroundColor
		setupTableView()
	}
	
	private func setupTableView() {
		view.addSubview(tableView)
		tableView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		
		tableView.register(withType: FitRecordTableViewCell.self)
		tableView.dataSource = self
		fitnessLogEntities = DatabaseManager.shared.fetchFitnessLogs()
		tableView.reloadData()
	}
	
}

extension FitListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return fitnessLogEntities.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withType: FitRecordTableViewCell.self, for: indexPath)
		let target = fitnessLogEntities[indexPath.row]
		cell.configure(with: target)
		return cell
	}
}
