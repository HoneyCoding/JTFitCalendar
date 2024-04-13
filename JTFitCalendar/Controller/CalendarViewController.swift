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
		return collectionView
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
	}
	
	private func setupViews() {
		view.backgroundColor = UIColor.systemBackground
		setupCalendarView()
		setupFitListView()
		setupNavigationBar()
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
		fitListView.register(withType: FitCollectionViewCell.self)
	}
	
	private func setupNavigationBar() {
		navigationItem.title = navigationBarTitleDateFormatter.string(from: calendarView.currentPage)
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
		let cell = collectionView.dequeueReusableCell(withType: FitCollectionViewCell.self, for: indexPath)
		return cell
	}
}
