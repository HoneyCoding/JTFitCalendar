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
	
	/// imageData를 변환하여 image를 생성하거나 image를 imageData로 변환하는 계산 프로퍼티이다.
	var image: UIImage? {
		get {
			// imageData를 변환하여 image를 생성
			guard let imageData else { return nil }
			return UIImage(data: imageData)
		} set {
			// image를 imageData로 변환
			self.imageData = newValue?.pngData()
		}
	}
	
	
	/// FitnessLogEntity의 hour, minutes, seconds를 합쳐 텍스트로 변환해주는 프로퍼티이다.
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
