//
//  FitListViewController.swift
//  JTFitCalendar
//
//  Created by 김진태 on 4/13/24.
//

import SnapKit
import Then
import UIKit

// Tab Bar의 두 번째 화면인 피트 리스트 화면에 대한 ViewController이다.
class FitListViewController: UIViewController {
	
	// 화면 전체를 덮는 TableView이다.
	private let tableView: UITableView = UITableView(frame: .zero, style: .grouped).then {
		$0.separatorStyle = .none
		$0.backgroundColor = UIColor.jtBackgroundColor
	}
	
	// 마지막으로 선택된 cell의 indexPath이다.
	var selectedIndexPath: IndexPath?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		// 화면이 보여질 때마다 tableView를 reload한다.
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
		
		// tableView에 cell을 등록한다.
		tableView.register(withType: FitRecordTableViewCell.self)
		// tableView에 delegate와 dataSource를 등록한다.
		tableView.dataSource = self
		tableView.delegate = self
	}
}

// MARK: - UITableViewDataSource
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
	
	// Header View의 Constraint를 설정해주고, Header View를 생성해주는 메서드이다.
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

// MARK: - UITableViewDelegate
extension FitListViewController: UITableViewDelegate {
	func tableView(
		_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint
	) -> UIContextMenuConfiguration? {
		// Cell과 연결된 FitnessLogEntity를 삭제하는 메뉴 추가
		return UIContextMenuConfiguration(actionProvider:  { _ in
			let deleteAction = UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
				if let target = DatabaseManager.shared.fitnessLog(for: indexPath) {
					DatabaseManager.shared.deleteRow(fitnessLog: target)
					if DatabaseManager.shared.rowCount(forSection: indexPath.section) == 0 {
						DatabaseManager.shared.deleteSectionIfNeeded(forSection: indexPath.section)
						tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
					} else {
						tableView.deleteRows(at: [indexPath], with: .automatic)
					}
				}
			}
			
			return UIMenu(title: "", children: [deleteAction])
		})
	}
	
	// Cell을 터치하면 터치한 Cell의 FitnessLogEntity의 수정 화면으로 이동하도록 기능 구현
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

// MARK: - ComposeFitRecordViewControllerDelegate
extension FitListViewController: ComposeFitRecordViewControllerDelegate {
	// ComposeFitRecordViewController에서 save 버튼이 눌린 이후 마지막으로 선택된 cell이 reload되는 기능 구현
	func composeFitRecordViewController(_ viewController: ComposeFitRecordViewController, didTapSaveButton: UIBarButtonItem) {
		if let selectedIndexPath {
			tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
			self.selectedIndexPath = nil
		}
	}
}
