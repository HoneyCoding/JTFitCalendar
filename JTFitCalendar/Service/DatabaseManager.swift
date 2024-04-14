//
//  DatabaseManager.swift
//  JTFitCalendar
//
//  Created by 김진태 on 4/14/24.
//

import CoreData
import Foundation
import UIKit

final class DatabaseManager {
	static let shared = DatabaseManager()
	
	let persistentContainer: NSPersistentContainer
	let mainContext: NSManagedObjectContext
	
	private init() {
		let persistentContainer = NSPersistentContainer(name: "CoreDataModel")
		persistentContainer.loadPersistentStores { description, error in
			if let error {
				fatalError("Unresolved Error, \(error.localizedDescription)")
			}
		}
		self.persistentContainer = persistentContainer
		self.mainContext = persistentContainer.viewContext
	}
	
	func insertFitnessLog(
		date: Date,
		imageData: Data?,
		activityTimeHour: Int,
		activityTimeMinutes: Int,
		activityTimeSeconds: Int,
		exerciseDistance: Double?,
		consumedCalorie: Double?,
		fitnessResult: String?
	) {
		let newFitnessLog = FitnessLogEntity(context: mainContext)
		newFitnessLog.date = date
		newFitnessLog.imageData = imageData
		newFitnessLog.hour = Int16(activityTimeHour)
		newFitnessLog.minutes = Int16(activityTimeMinutes)
		newFitnessLog.seconds = Int16(activityTimeSeconds)
		newFitnessLog.exerciseDistance = exerciseDistance ?? 0.0
		newFitnessLog.consumedCalorie = consumedCalorie ?? 0.0
		newFitnessLog.result = fitnessResult
		
		saveChanges()
	}
	
	func saveChanges() {
		if mainContext.hasChanges {
			mainContext.perform { [weak self] in
				guard let self else { return }
				do {
					try self.mainContext.save()
				} catch {
					print(error.localizedDescription)
				}
			}
		}
	}
}
