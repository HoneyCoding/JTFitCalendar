//
//  FitnessLogEntity+CoreDataClass.swift
//  JTFitCalendar
//
//  Created by 김진태 on 4/14/24.
//
//

import CoreData
import Foundation
import UIKit

@objc(FitnessLogEntity)
public class FitnessLogEntity: NSManagedObject {
	var image: UIImage? {
		get {
			guard let imageData else { return nil }
			return UIImage(data: imageData)
		} set {
			self.imageData = newValue?.pngData()
		}
	}
	
	var activityTimeText: String? {
		var activityTimeText = ""
		
		if hour != 0 {
			activityTimeText += "\(hour)시간 "
		}
		if minutes != 0 {
			activityTimeText += "\(minutes)분 "
		}
		if seconds != 0 {
			activityTimeText += "\(seconds)초 "
		}
		return activityTimeText.trimmingCharacters(in: .whitespacesAndNewlines)
	}
}
