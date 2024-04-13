//
//  AddFitItemViewController.swift
//  JTFitCalendar
//
//  Created by 김진태 on 4/13/24.
//

import UIKit

class AddFitRecordViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.systemBackground
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.isNavigationBarHidden = false
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.isNavigationBarHidden = true
	}
}
