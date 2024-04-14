//
//  FitnessLogEntity+CoreDataClass.swift
//  JTFitCalendar
//
//  Created by 김진태 on 4/14/24.
//
//

import Foundation
import CoreData
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
}
