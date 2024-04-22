//
//  ViewController.swift
//  JTFitCalendar
//
//  Created by 김진태 on 4/13/24.
//

import UIKit


/// 앱을 실행하면 제일 먼저 나타나는 Tab Bar 화면을 구현한 Controller이다.
class MainTabBarController: UITabBarController {

	// MARK: - View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.systemBackground
		setupViewControllers()
		setupTabBar()
	}
	
	/// Tab Bar를 통해 전환할 수 있는 3개의 컨트롤러를 설정해준다.
	private func setupViewControllers() {
		let firstViewController = UINavigationController(rootViewController: CalendarViewController())
		firstViewController.tabBarItem.image = UIImage(systemName: "calendar")
		firstViewController.tabBarItem.title = "캘린더"
		
		let secondViewController = FitListViewController()
		secondViewController.tabBarItem.image = UIImage(systemName: "line.3.horizontal")
		secondViewController.tabBarItem.title = "기록 목록"
		
		let thirdViewController = SettingsViewController()
		thirdViewController.tabBarItem.image = UIImage(systemName: "gearshape.fill")
		thirdViewController.tabBarItem.title = "설정"
		
		self.setViewControllers(
			[firstViewController, secondViewController, thirdViewController],
			animated: false
		)
	}
	
	/// Tab Bar의 디자인을 수정하는 함수이다. 해당 함수가 실행되면 TabBar는 System Background와 같은 배경색을 갖게 된다.
	private func setupTabBar() {
		let appearance = UITabBarAppearance()
		appearance.configureWithOpaqueBackground()
		appearance.shadowColor = UIColor.clear
		appearance.backgroundColor = UIColor.jtBackgroundColor
		tabBar.standardAppearance = appearance
		tabBar.scrollEdgeAppearance = appearance
	}
	
}

