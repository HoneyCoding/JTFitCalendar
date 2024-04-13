//
//  ViewController.swift
//  JTFitCalendar
//
//  Created by 김진태 on 4/13/24.
//

import UIKit

class MainTabBarController: UITabBarController {

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.systemBackground
		setupViewControllers()
		setupTabBar()
	}
	
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
	
	private func setupTabBar() {
		let appearance = UITabBarAppearance()
		appearance.configureWithOpaqueBackground()
		appearance.shadowColor = UIColor.clear
		appearance.backgroundColor = UIColor.systemBackground
		tabBar.standardAppearance = appearance
		tabBar.scrollEdgeAppearance = appearance
	}
	
	private func createNavigationController(
		image: UIImage?, title: String?, rootViewController: UIViewController
	) -> UINavigationController {
		let navigationController = UINavigationController(rootViewController: rootViewController)
		navigationController.tabBarItem.title = title
		navigationController.tabBarItem.image = image
		return navigationController
	}
	
}

