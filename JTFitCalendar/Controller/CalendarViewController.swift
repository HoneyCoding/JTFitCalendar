//
//  HomeViewController.swift
//  JTFitCalendar
//
//  Created by 김진태 on 4/13/24.
//

import FSCalendar
import SnapKit
import Then
import UIKit

class CalendarViewController: UIViewController {
	private lazy var calendarView: FSCalendar = FSCalendar().then {
		$0.scope = .month
		$0.locale = Locale(identifier: "ko_KR")
		$0.scrollEnabled = true
		$0.scrollDirection = .horizontal
		$0.weekdayHeight = 36
		$0.headerHeight = 0
		$0.delegate = self
		$0.appearance.titleDefaultColor = UIColor.label
		$0.appearance.todayColor = UIColor.systemMint
		$0.appearance.selectionColor = UIColor.primaryColor
		$0.appearance.weekdayTextColor = UIColor.secondaryLabel
		$0.appearance.titleTodayColor = UIColor.white
	}
	
	private let navigationBarTitleDateFormatter = DateFormatter().then {
		$0.dateFormat = "yyyy년 MM월"
		$0.locale = Locale(identifier: "ko_kr")
		$0.timeZone = TimeZone(identifier: "KST")
	}
	
	private lazy var fitListView: UITableView = UITableView().then {
		$0.delegate = self
		$0.dataSource = self
		$0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
		$0.separatorStyle = .none
		$0.backgroundColor = UIColor.jtBackgroundColor
	}
	
	private let addFitItemFloatingButton: UIButton = UIButton(type: .system).then {
		$0.tintColor = UIColor.white
		$0.backgroundColor = UIColor.primaryColor
		$0.setImage(UIImage(systemName: "plus"), for: .normal)
	}
	
	private let addItemMessageLabel: UILabel = UILabel().then {
		$0.text = "피트 기록을 추가해보세요."
		$0.textColor = UIColor.secondaryLabel
		$0.font = UIFont.systemFont(ofSize: 14)
	}
	
	var selectedIndexPath: IndexPath?
	var selectedDate: Date = Calendar.current.startOfDay(for: Date.now)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		fitListView.reloadData()
	}
	
	private func setupViews() {
		view.backgroundColor = UIColor.jtBackgroundColor
		setupCalendarView()
		setupFitListView()
		setupNavigationBar()
		setupAddFitItemFloatingButton()
	}
	
	private func setupCalendarView() {
		view.addSubview(calendarView)
		calendarView.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
			make.height.equalTo(300)
		}
		
		calendarView.select(Date.now)
	}
	
	private func setupFitListView() {
		view.addSubview(fitListView)
		fitListView.snp.makeConstraints { make in
			make.top.equalTo(calendarView.snp.bottom)
			make.leading.trailing.equalToSuperview()
			make.bottom.equalToSuperview()
		}
		
		fitListView.addSubview(addItemMessageLabel)
		addItemMessageLabel.snp.makeConstraints { make in
			make.center.equalToSuperview()
		}
		
		fitListView.register(withType: FitRecordTableViewCell.self)
		
		fitListView.reloadData()
	}
	
	private func setupNavigationBar() {
		navigationItem.title = navigationBarTitleDateFormatter.string(from: calendarView.currentPage)
	}
	
	private func setupAddFitItemFloatingButton() {
		view.addSubview(addFitItemFloatingButton)
		addFitItemFloatingButton.snp.makeConstraints { make in
			make.width.height.equalTo(48)
			make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
		}
		addFitItemFloatingButton.layer.cornerRadius = 48 / 2
		addFitItemFloatingButton.clipsToBounds = true
		addFitItemFloatingButton.addTarget(
			self, action: #selector(pushToAddFitItemViewController), for: .touchUpInside
		)
	}
	
	@objc private func pushToAddFitItemViewController(_ sender: UIButton) {
		let mainTabBarController = parent?.parent
		guard let selectedDate = calendarView.selectedDate else {
			self.showAlert(message: "운동 기록을 남길 날짜를 선택해주세요.")
			return
		}
		let composeFitRecordVC = ComposeFitRecordViewController(date: selectedDate)
		composeFitRecordVC.delegate = self
		mainTabBarController?.navigationController?.pushViewController(
			composeFitRecordVC,
			animated: true
		)
	}
}

extension CalendarViewController: FSCalendarDelegate {
	func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
		let currentPage = calendar.currentPage
		
		navigationItem.title = navigationBarTitleDateFormatter.string(from: currentPage)
	}
	
	func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
		selectedDate = date
		fitListView.reloadData()
	}
}

extension CalendarViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let count = DatabaseManager.shared.rowCount(forDate: selectedDate)
		if count > 0 {
			addItemMessageLabel.isHidden = true
		} else {
			addItemMessageLabel.isHidden = false
		}
		return count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withType: FitRecordTableViewCell.self, for: indexPath)
		if let target = DatabaseManager.shared.fitnessLogs(for: selectedDate)?[indexPath.row] {
			cell.configure(with: target)
		}
		return cell
	}
}

extension CalendarViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.selectedIndexPath = indexPath
		let target = DatabaseManager.shared.fitnessLog(for: indexPath)
		let mainTabBarController = parent?.parent
		guard let date = target?.date else { return }
		let composeFitRecordVC = ComposeFitRecordViewController(date: date)
		composeFitRecordVC.delegate = self
		composeFitRecordVC.fitnessLogEntity = target
		mainTabBarController?.navigationController?.pushViewController(
			composeFitRecordVC,
			animated: true
		)
	}
	
	func tableView(
		_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint
	) -> UIContextMenuConfiguration? {
		return UIContextMenuConfiguration(actionProvider:  { _ in
			let deleteAction = UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
				if let target = DatabaseManager.shared.fitnessLog(for: indexPath) {
					DatabaseManager.shared.deleteRow(fitnessLog: target)
					DatabaseManager.shared.deleteSectionIfNeeded(forSection: indexPath.section)
					tableView.deleteRows(at: [indexPath], with: .automatic)
				}
			}
			
			return UIMenu(title: "", children: [deleteAction])
		})
	}
}

extension CalendarViewController: ComposeFitRecordViewControllerDelegate {
	func composeFitRecordViewController(
		_ viewController: ComposeFitRecordViewController, didTapSaveButton: UIBarButtonItem
	) {
		if let selectedIndexPath {
			fitListView.reloadRows(at: [selectedIndexPath], with: .automatic)
			self.selectedIndexPath = nil
		}
	}
}

