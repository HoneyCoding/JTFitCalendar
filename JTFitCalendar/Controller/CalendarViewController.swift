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

// TabBar의 첫번째 화면에 대한 ViewController이다.
class CalendarViewController: UIViewController {
	// MARK: - View Properties
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
	
	// Navigation Bar에 올 Title의 format을 지정한 dateFormatter이다.
	private let navigationBarTitleDateFormatter = DateFormatter().then {
		$0.dateFormat = "yyyy년 MM월"
		$0.locale = Locale(identifier: "ko_kr")
		$0.timeZone = TimeZone(identifier: "KST")
	}
	
	private lazy var fitListView: UITableView = UITableView().then {
		$0.delegate = self
		$0.dataSource = self
		// Floating Button의 크기(높이)만큼 아래에 contentInset을 준다.
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
	
	// MARK: - Properties
	var selectedIndexPath: IndexPath?
	var selectedDate: Date = Calendar.current.startOfDay(for: Date.now)
	
	// MARK: - View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		fitListView.reloadData()
	}

	/// View에 대한 Constraint를 설정하고 View의 배치 및 크기를 조절하는 함수이다.
	private func setupViews() {
		view.backgroundColor = UIColor.jtBackgroundColor
		setupCalendarView()
		setupFitListView()
		setupNavigationBar()
		setupAddFitItemFloatingButton()
	}
	
	/// Calendar에 대한 Constraint를 설정하고 View의 배치 및 크기를 조절하는 함수이다. Calendar에 선택된 날짜를 오늘로 설정한다.
	private func setupCalendarView() {
		view.addSubview(calendarView)
		calendarView.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
			make.height.equalTo(300)
		}
		
		calendarView.select(Date.now)
	}
	
	/// fitListView에 대한 Constraint를 설정하고 View의 배치 및 크기를 조절하는 함수이다. fitListView에 Cell을 register한다.
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
	
	/// navigationBar의 타이틀을 설정하는 함수이다.
	private func setupNavigationBar() {
		navigationItem.title = navigationBarTitleDateFormatter.string(from: calendarView.currentPage)
	}
	
	/// 화면에 아이템을 추가할 수 있도록 하는 Floating Button을 추가하는 함수이다.
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
	
	// MARK: - Actions
	/// addFitItemFloatingButton을 누르면 실행하는 함수이다. 해당 함수를 실행하면 아이템 추가를 위한 화면으로 이동한다.
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

// MARK: - FSCalendarDelegate
extension CalendarViewController: FSCalendarDelegate {
	// Calendar의 페이지가 바뀌면 실행되는 함수이다.
	func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
		let currentPage = calendar.currentPage
		
		// Calendar의 페이지가 바뀔 때마다 navigationBar의 title을 변경한다.
		navigationItem.title = navigationBarTitleDateFormatter.string(from: currentPage)
	}
	
	// Calendar의 날짜를 선택하면 실행되는 함수이다.
	func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
		// tableView에서 보여질 cell들을 위해 selectedDate의 값을 저장한다.
		selectedDate = date
		// fitListView를 reload하여 선택한 날짜에 맞는 데이터들을 cell에서 보여준다.
		fitListView.reloadData()
	}
}

// MARK: - UITableViewDataSource
extension CalendarViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// 날짜에 맞는 row의 수를 읽어와 count 변수에 담는다.
		let count = DatabaseManager.shared.rowCount(forDate: selectedDate)
		// count의 값이 0보다 크면 addItemMessageLabel을 숨기고, 0이면 addItemMessageLabel을 보여준다.
		if count > 0 {
			addItemMessageLabel.isHidden = true
		} else {
			addItemMessageLabel.isHidden = false
		}
		// count의 값은 return한다.
		return count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withType: FitRecordTableViewCell.self, for: indexPath)
		// dequeue한 cell에 선택한 날짜와 indexPath에 맞는 FitnessLogEntity를 전달하여 cell에 데이터를 보여준다.
		if let target = DatabaseManager.shared.fitnessLogs(for: selectedDate)?[indexPath.row] {
			cell.configure(with: target)
		}
		return cell
	}
}

// MARK: - UITableViewDelegate
extension CalendarViewController: UITableViewDelegate {
	// tableView의 cell을 선택하면 실행하는 메서드이다.
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// 나중에 선택했던 cell을 reload하기 위해 선택한 indexPath의 값을 저장한다.
		self.selectedIndexPath = indexPath
		// 선택한 indexPath에 맞는 FitnessLogEntity를 수정하는 화면으로 이동한다.
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
	
	// tableView의 cell을 꾹 눌렀을 때, 어떤 ContextMenu를 띄울지 구현하는 메서드이다.
	func tableView(
		_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint
	) -> UIContextMenuConfiguration? {
		// 선택한 indexPath에 맞는 fitnessLogEntity를 제거하는 delete Action을 구현하였다.
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

// MARK: - ComposeFitRecordViewControllerDelegate
extension CalendarViewController: ComposeFitRecordViewControllerDelegate {
	// ComposeFitRecordViewController에서 saveButton을 탭하였을 때 실행되는 메서드이다.
	func composeFitRecordViewController(
		_ viewController: ComposeFitRecordViewController, didTapSaveButton: UIBarButtonItem
	) {
		// FitnessLogEntity를 추가할 경우엔 selectedIndexPath가 nil이므로 아래 코드는 실행되지 않는다
		// FitnessLogEntity를 수정하는 경우엔 selectedIndexPath가 nil이 아니므로 아래 코드가 실행된다.
		if let selectedIndexPath {
			fitListView.reloadRows(at: [selectedIndexPath], with: .automatic)
			self.selectedIndexPath = nil
		}
	}
}

