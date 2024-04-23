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
	
	/// Section에 대한 Rows들이 포함된 Dictionary
	private var dateFitnessLogDictionary: [Date: [FitnessLogEntity]] = [:]
	/// Section에 대한 Date들이 들어있는 Array
	private var sectionDates: [Date] = []
	
	var sectionCount: Int {
		return sectionDates.count
	}
	
	private init() {
		let persistentContainer = NSPersistentContainer(name: "CoreDataModel")
		persistentContainer.loadPersistentStores { description, error in
			if let error {
				fatalError("Unresolved Error, \(error.localizedDescription)")
			}
		}
		self.persistentContainer = persistentContainer
		self.mainContext = persistentContainer.viewContext
		
		let request = FitnessLogEntity.fetchRequest()
		let sortByDate = NSSortDescriptor(keyPath: \FitnessLogEntity.date, ascending: false)
		request.sortDescriptors = [sortByDate]
		
		do {
			let fitnessLogs = try mainContext.fetch(request)
			fitnessLogs.forEach { fitnessLogEntity in
				guard let date = fitnessLogEntity.date else { return }
				if sectionDates.contains(date) == false {
					sectionDates.append(date)
					dateFitnessLogDictionary[date] = [fitnessLogEntity]
				} else {
					dateFitnessLogDictionary[date]?.append(fitnessLogEntity)
				}
			}
		} catch {
			fatalError("Database Fetch Error")
		}
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
		
		if sectionDates.contains(date) == false {
			sectionDates.append(date)
			sectionDates.sort(by: >)
			dateFitnessLogDictionary[date] = [newFitnessLog]
		} else {
			dateFitnessLogDictionary[date]?.append(newFitnessLog)
		}
		
		saveChanges()
	}
	
	func fitnessLogs(for date: Date) -> [FitnessLogEntity]? {
		return dateFitnessLogDictionary[date]
	}
	
	func fitnessLog(for indexPath: IndexPath) -> FitnessLogEntity? {
		let sectionDate = sectionDates[indexPath.section]
		return fitnessLogs(for: sectionDate)?[indexPath.row]
	}
	
	func updateFitnessLog(
		entity: FitnessLogEntity,
		date: Date,
		imageData: Data?,
		activityTimeHour: Int,
		activityTimeMinutes: Int,
		activityTimeSeconds: Int,
		exerciseDistance: Double?,
		consumedCalorie: Double?,
		fitnessResult: String?
	) {
		entity.date = date
		entity.imageData = imageData
		entity.hour = Int16(activityTimeHour)
		entity.minutes = Int16(activityTimeMinutes)
		entity.seconds = Int16(activityTimeSeconds)
		entity.exerciseDistance = exerciseDistance ?? 0.0
		entity.consumedCalorie = consumedCalorie ?? 0.0
		entity.result = fitnessResult
		
		saveChanges()
	}
	
	func deleteRow(fitnessLog entity: FitnessLogEntity) {
		guard let date = entity.date else { return }
		guard let dictionaryValueIndex = dateFitnessLogDictionary[date]?.firstIndex(of: entity) else { return }
		if dateFitnessLogDictionary[date]?.count == 1 {
			dateFitnessLogDictionary[date] = nil
		} else {
			dateFitnessLogDictionary[date]?.remove(at: dictionaryValueIndex)
		}
		mainContext.delete(entity)
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
	
	func sectionDate(forSection section: Int) -> Date {
		return sectionDates[section]
	}
	
	func rowCount(forSection section: Int) -> Int {
		return dateFitnessLogDictionary[sectionDate(forSection: section)]?.count ?? 0
	}
	
	func rowCount(forDate date: Date) -> Int {
		return dateFitnessLogDictionary[date]?.count ?? 0
	}
	
	func deleteSection(forSection section: Int) {
		let date = sectionDate(forSection: section)
		if dateFitnessLogDictionary[date] == nil {
			sectionDates.remove(at: section)
		}
	}
}
