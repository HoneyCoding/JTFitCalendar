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
		let firstViewController = createNavigationController(
			image: UIImage(systemName: "calendar"), 
			title: "캘린더",
			rootViewController: CalendarViewController()
		)
		
		let secondViewController = createNavigationController(
			image: UIImage(systemName: "line.3.horizontal"),
			title: "기록 목록",
			rootViewController: FitListViewController()
		)
		
		let thirdViewController = createNavigationController(
			image: UIImage(systemName: "gearshape.fill"),
			title: "설정",
			rootViewController: SettingsViewController()
		)
		
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
		appearance.backgroundColor = UIColor.systemBackground
		tabBar.standardAppearance = appearance
		tabBar.scrollEdgeAppearance = appearance
	}
	
	/// 해당 함수를 통해 tabBarItem이 설정된 NavigationController를 생성한다.
	/// - Parameters:
	///   - image: tabBarItem의 image로 사용된다.
	///   - title: tabBarItem의 title로 사용된다.
	///   - rootViewController: UINavigationController로 감싸주는 viewController이다.
	/// - Returns: rootViewController를 UINavigationController로 감싸주어 return한다.
	private func createNavigationController(
		image: UIImage?, title: String?, rootViewController: UIViewController
	) -> UINavigationController {
		let navigationController = UINavigationController(rootViewController: rootViewController)
		navigationController.tabBarItem.title = title
		navigationController.tabBarItem.image = image
		return navigationController
	}
	
}

