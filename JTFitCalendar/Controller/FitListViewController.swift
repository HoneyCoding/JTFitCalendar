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
	
	var fitnessLogs: [FitnessLogEntity] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		fitnessLogs = DatabaseManager.shared.fetchFitnessLogs()
		tableView.reloadData()
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
		tableView.delegate = self
	}
	
}

extension FitListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return fitnessLogs.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withType: FitRecordTableViewCell.self, for: indexPath)
		let target = fitnessLogs[indexPath.row]
		cell.configure(with: target)
		return cell
	}
}

extension FitListViewController: UITableViewDelegate {
	func tableView(
		_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint
	) -> UIContextMenuConfiguration? {
		return UIContextMenuConfiguration(actionProvider:  { _ in
			let deleteAction = UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
				let target = self.fitnessLogs[indexPath.row]
				self.fitnessLogs.remove(at: indexPath.row)
				DatabaseManager.shared.delete(entity: target)
				tableView.deleteRows(at: [indexPath], with: .automatic)
			}
			
			return UIMenu(title: "", children: [deleteAction])
		})
	}
}
