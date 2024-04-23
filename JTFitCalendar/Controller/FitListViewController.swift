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
	
	private let tableView: UITableView = UITableView(frame: .zero, style: .grouped).then {
		$0.separatorStyle = .none
		$0.backgroundColor = UIColor.jtBackgroundColor
	}
	
	var selectedIndexPath: IndexPath?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
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
		return DatabaseManager.shared.sectionCount
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return DatabaseManager.shared.rowCount(forSection: section)
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let date = DatabaseManager.shared.sectionDate(forSection: section)
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy.MM.dd"
		
		let dateTitle = formatter.string(from: date)
		
		return createHeaderView(title: dateTitle)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withType: FitRecordTableViewCell.self, for: indexPath)
		if let target = DatabaseManager.shared.fitnessLog(for: indexPath) {
			cell.configure(with: target)
		}
		return cell
	}
	
	fileprivate func createHeaderView(title: String) -> UIView? {
		let headerView = UIView()
		// titleLabel 생성 및 font 설정
		let titleLabel = UILabel()
		titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
		
		// View Hierarchy 및 Constraints 설정
		headerView.addSubview(titleLabel)
		titleLabel.snp.makeConstraints { make in
			make.horizontalEdges.equalTo(headerView).inset(18)
			make.centerY.equalTo(headerView)
		}
		titleLabel.text = title
		return headerView
	}
}

extension FitListViewController: UITableViewDelegate {
	func tableView(
		_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint
	) -> UIContextMenuConfiguration? {
		return UIContextMenuConfiguration(actionProvider:  { _ in
			let deleteAction = UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
				if let target = DatabaseManager.shared.fitnessLog(for: indexPath) {
					DatabaseManager.shared.deleteRow(fitnessLog: target)
					if DatabaseManager.shared.rowCount(forSection: indexPath.section) == 0 {
						DatabaseManager.shared.deleteSection(forSection: indexPath.section)
						tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
					} else {
						tableView.deleteRows(at: [indexPath], with: .automatic)
					}
				}
			}
			
			return UIMenu(title: "", children: [deleteAction])
		})
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		self.selectedIndexPath = indexPath
		let target = DatabaseManager.shared.fitnessLog(for: indexPath)
		guard let date = target?.date else { return }
		let composeFitRecordVC = ComposeFitRecordViewController(date: date)
		composeFitRecordVC.delegate = self
		composeFitRecordVC.fitnessLogEntity = target
		navigationController?.pushViewController(
			composeFitRecordVC,
			animated: true
		)
	}
}

extension FitListViewController: ComposeFitRecordViewControllerDelegate {
	func composeFitRecordViewController(_ viewController: ComposeFitRecordViewController, didTapSaveButton: UIBarButtonItem) {
		if let selectedIndexPath {
			tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
			self.selectedIndexPath = nil
		}
	}
}
