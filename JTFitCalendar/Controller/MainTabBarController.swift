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
	}
	
	private func setupViewControllers() {
		let calendarViewController = CalendarViewController()
		calendarViewController.tabBarItem.title = "캘린더"
		calendarViewController.tabBarItem.image = UIImage(systemName: "calendar")
		
		let fitListViewController = FitListViewController()
		fitListViewController.tabBarItem.title = "피트 리스트"
		fitListViewController.tabBarItem.image = UIImage(systemName: "line.3.horizontal")
		
		let settingsViewController = SettingsViewController()
		settingsViewController.tabBarItem.title = "설정"
		settingsViewController.tabBarItem.image = UIImage(systemName: "gearshape.fill")
		
		self.setViewControllers(
			[calendarViewController, fitListViewController, settingsViewController],
			animated: false
		)
	}
	
}

