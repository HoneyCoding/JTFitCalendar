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
	/// Core Data의 mainContext이다.
	let mainContext: NSManagedObjectContext
	
	/// Section에 대한 Rows들이 포함된 Dictionary
	private var dateFitnessLogDictionary: [Date: [FitnessLogEntity]] = [:]
	/// Section에 대한 Date들이 들어있는 Array
	private var sectionDates: [Date] = []
	
	/// Section의 갯수를 계산하는 프로퍼티
	var sectionCount: Int {
		return sectionDates.count
	}
	
	private init() {
		// Persistent Container 생성
		let persistentContainer = NSPersistentContainer(name: "CoreDataModel")
		persistentContainer.loadPersistentStores { description, error in
			if let error {
				fatalError("Unresolved Error, \(error.localizedDescription)")
			}
		}
		// persistentContainer 프로퍼티 초기화
		self.persistentContainer = persistentContainer
		// mainContext 프로퍼티 초기화
		self.mainContext = persistentContainer.viewContext
		
		// FitnessLogEntity를 Core Data에서 읽어오기 위한 fetchRequest 생성
		let request = FitnessLogEntity.fetchRequest()
		// fitnessLogEntity를 date를 기준으로 내림차순으로 정렬
		let sortByDate = NSSortDescriptor(keyPath: \FitnessLogEntity.date, ascending: false)
		request.sortDescriptors = [sortByDate]
		
		do {
			// mainContext에서 fitnessLogEntity 목록을 읽어온다
			let fitnessLogs = try mainContext.fetch(request)
			// 읽어온 fitnessLogEntity를 날짜별로 구분하여 dateFitnessLogDictionary에 추가한다.
			// 처음 추가되는 날짜일 경우 sectionDates도 추가한다.
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
	
	
	/// 새로운 fitnessLogEntity를 추가하는 함수이다.
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
		
		// dateFitnessLogDictionary에 newFitnessLog를 추가한다.
		// date가 sectionDates에 없을 경우
		if sectionDates.contains(date) == false {
			// sectionDates에 date를 추가하고, 내림차순으로 정렬한다.
			sectionDates.append(date)
			sectionDates.sort(by: >)
			dateFitnessLogDictionary[date] = [newFitnessLog]
		} else {
			dateFitnessLogDictionary[date]?.append(newFitnessLog)
		}
		
		// Core Data에 새로운 mainContext의 상태를 저장한다.
		saveChanges()
	}
	
	
	/// 특정 날짜에 대한 FitnessLogEntity 배열을 전부 읽어온다.
	func fitnessLogs(for date: Date) -> [FitnessLogEntity]? {
		return dateFitnessLogDictionary[date]
	}
	
	/// 특정 IndexPath에 대한 FitnessLogEntity를 하나 읽어온다.
	func fitnessLog(for indexPath: IndexPath) -> FitnessLogEntity? {
		let sectionDate = sectionDates[indexPath.section]
		return fitnessLogs(for: sectionDate)?[indexPath.row]
	}
	
	/// 기존에 존재하는 fitnessLogEntity를 수정하는 함수이다.
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
	
	/// FitnessLogEntity를 삭제하는 함수이다.
	func deleteRow(fitnessLog entity: FitnessLogEntity) {
		guard let date = entity.date else { return }
		guard let dictionaryValueIndex = dateFitnessLogDictionary[date]?.firstIndex(of: entity) else { return }
		// dateFitnessLogDictionary에 동일한 날짜에 대한 entity가 없을 경우
		if dateFitnessLogDictionary[date]?.count == 1 {
			// dateFitnessLogDictionary를 nil로 변경
			dateFitnessLogDictionary[date] = nil
		} else {
			// dateFitnessLogDictionary에서 entity를 하나만 삭제
			dateFitnessLogDictionary[date]?.remove(at: dictionaryValueIndex)
		}
		// mainContext에서 entity를 제거한 후 변화한 상태를 저장한다.
		mainContext.delete(entity)
		saveChanges()
	}
	
	
	/// Core Data의 mainContext 내부에 변화가 있을 경우 변화한 상태를 저장하는 메서드이다.
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
	
	/// Section에 대응되는 Date를 알려주는 함수이다.
	func sectionDate(forSection section: Int) -> Date {
		return sectionDates[section]
	}
	
	/// Section에 대한 몇 개의 FitnessEntity가 저장되어 있는지 알려주는 함수이다.
	func rowCount(forSection section: Int) -> Int {
		return dateFitnessLogDictionary[sectionDate(forSection: section)]?.count ?? 0
	}
	
	/// Date에 대한 몇 개의 FitnessEntity가 저장되어 있는지 알려주는 함수이다.
	func rowCount(forDate date: Date) -> Int {
		return dateFitnessLogDictionary[date]?.count ?? 0
	}
	
	/// dateFitnessLogDictionary에 해당 section에 대한 배열이 없을 경우 sectionDates에서 section을 삭제하는 메서드이다.
	func deleteSectionIfNeeded(forSection section: Int) {
		let date = sectionDate(forSection: section)
		if dateFitnessLogDictionary[date] == nil {
			sectionDates.remove(at: section)
		}
	}
}
