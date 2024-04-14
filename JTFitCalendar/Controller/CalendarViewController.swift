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
		$0.appearance.todayColor = .clear
		$0.appearance.weekdayTextColor = UIColor.secondaryLabel
		$0.appearance.titleTodayColor = UIColor.label
	}
	
	private let navigationBarTitleDateFormatter = DateFormatter().then {
		$0.dateFormat = "yyyy년 MM월"
		$0.locale = Locale(identifier: "ko_kr")
		$0.timeZone = TimeZone(identifier: "KST")
	}
	
	private lazy var fitListView: UICollectionView = {
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .vertical
		flowLayout.minimumInteritemSpacing = 8
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
		return collectionView
	}()
	
	private let addFitItemFloatingButton: UIButton = UIButton(type: .system).then {
		$0.tintColor = UIColor.white
		$0.backgroundColor = UIColor.systemBlue
		$0.setImage(UIImage(systemName: "plus"), for: .normal)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
	}
	
	private func setupViews() {
		view.backgroundColor = UIColor.systemBackground
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
		fitListView.register(withType: FitRecordCollectionViewCell.self)
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
		mainTabBarController?.navigationController?.pushViewController(
			AddFitRecordViewController(date: selectedDate),
			animated: true
		)
	}
}

extension CalendarViewController: FSCalendarDelegate {
	func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
		let currentPage = calendar.currentPage
		
		navigationItem.title = navigationBarTitleDateFormatter.string(from: currentPage)
	}
}

extension CalendarViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 6
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withType: FitRecordCollectionViewCell.self, for: indexPath)
		return cell
	}
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		let width: CGFloat = collectionView.frame.width - 12 * 2
		let height: CGFloat = 240
		let dummyCell = FitRecordCollectionViewCell(frame: CGRect(x: 0, y: 0, width: width, height: height))
		let estimatedSize = dummyCell.systemLayoutSizeFitting(CGSize(width: width, height: height))
		return CGSize(width: width, height: estimatedSize.height)
	}
}
