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
	
	var fitnessLogRepresentation: FitnessLogRepresentation = FitnessLogRepresentation()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		let fitnessLogs = DatabaseManager.shared.fetchFitnessLogs()
		fitnessLogRepresentation = FitnessLogRepresentation()
		fitnessLogRepresentation.append(fitnessLogList: fitnessLogs)
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
	func numberOfSections(in tableView: UITableView) -> Int {
		return fitnessLogRepresentation.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return fitnessLogRepresentation.rowCount(forSection: section)
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return fitnessLogRepresentation.sectionDate(forSection: section).formatted(date: .numeric, time: .omitted)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withType: FitRecordTableViewCell.self, for: indexPath)
		if let target = fitnessLogRepresentation.fitnessLog(for: indexPath) {
			cell.configure(with: target)
		}
		return cell
	}
}

extension FitListViewController: UITableViewDelegate {
	func tableView(
		_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint
	) -> UIContextMenuConfiguration? {
		return UIContextMenuConfiguration(actionProvider:  { _ in
			let deleteAction = UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
				if let target = self.fitnessLogRepresentation.fitnessLog(for: indexPath) {
					self.fitnessLogRepresentation.removeFitnessLog(at: indexPath)
					DatabaseManager.shared.delete(entity: target)
					if self.fitnessLogRepresentation.rowCount(forSection: indexPath.section) == 0 {
						self.fitnessLogRepresentation.removeSection(forSection: indexPath.section)
						tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
					} else {
						tableView.deleteRows(at: [indexPath], with: .automatic)
					}
				}
			}
			
			return UIMenu(title: "", children: [deleteAction])
		})
	}
}
