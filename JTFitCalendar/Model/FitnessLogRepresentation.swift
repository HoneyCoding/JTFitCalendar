//
//  FitnessLogSections.swift
//  JTFitCalendar
//
//  Created by 김진태 on 4/20/24.
//

import Foundation

struct FitnessLogRepresentation {
	/// Section에 대한 Rows들이 포함된 Dictionary
	private var dateFitnessLogDictionary: [Date: [FitnessLogEntity]] = [:]
	/// Section에 대한 Date들이 들어있는 Array
	private var sectionDates: [Date] = []
	
	// Section의 갯수
	var count: Int {
		return sectionDates.count
	}
	
	
	/// fitnessLog를 맨 뒤에 추가하는 함수
	/// - Parameter todo: 추가하고자 하는 fitnessLog를 전달
	mutating func append(fitnessLog entity: FitnessLogEntity) {
		guard let date = entity.date else { return }
		if sectionDates.contains(date) == false {
			sectionDates.append(date)
			dateFitnessLogDictionary[date] = [entity]
		} else {
			dateFitnessLogDictionary[date]?.append(entity)
		}
	}
	
	/// fitnessLogList를 맨 뒤에 추가하는 함수
	/// - Parameter todoList: 추가하고자 하는 todoList를 전달
	mutating func append(fitnessLogList: [FitnessLogEntity]) {
		fitnessLogList.forEach { fitnessLog in
			self.append(fitnessLog: fitnessLog)
		}
	}
	
	/// indexPath에 대해 fitnessLog를 update하는 함수
	/// - Parameters:
	///   - todo: 새로운 fitnessLog를 전달
	///   - indexPath: 변경하고자 하는 fitnessLog의 위치, indexPath를 전달
	mutating func update(fitnessLog: FitnessLogEntity, for indexPath: IndexPath) {
		let sectionDate = sectionDates[indexPath.section]
		dateFitnessLogDictionary[sectionDate]?[indexPath.row] = fitnessLog
	}
	
	
	/// section을 삭제하는 함수
	/// - Parameter section: 삭제하고자 하는 section을 전달. 값은 Int 타입
	mutating func removeSection(forSection section: Int) {
		dateFitnessLogDictionary.removeValue(forKey: sectionDate(forSection: section))
		sectionDates.remove(at: section)
	}
	
	
	/// indexPath의 fitnessLog를 삭제하는 함수
	/// - Parameter indexPath: 삭제하고자 하는 fitnessLog의 indexPath 전달.
	mutating func removeFitnessLog(at indexPath: IndexPath) {
		dateFitnessLogDictionary[sectionDate(forSection: indexPath.section)]?.remove(at: indexPath.row)
	}
	
	
	/// fitnessLog의 갯수를 전달해주는 함수
	/// - Parameter section: fitnessLog의 갯수를 알고 싶은 section을 전달한다.
	/// - Returns: 해당 section의 fitnessLog의 갯수를 반환한다.
	func rowCount(forSection section: Int) -> Int {
		let sectionDate = sectionDates[section]
		return dateFitnessLogDictionary[sectionDate]?.count ?? 0
	}
	
	
	/// section에 해당하는 Date를 Return하는 함수
	/// - Returns: section에 해당하는 Date
	func sectionDate(forSection section: Int) -> Date {
		return sectionDates[section]
	}
	
	
	/// section에 해당하는 rows (fitnessLogs)를 Return하는 함수
	/// - Returns: section에 해당하는 rows (fitnessLogs)를 return하고, rows가 없으면 nil을 return
	func rows(forSection section: Int) -> [FitnessLogEntity]? {
		return dateFitnessLogDictionary[sectionDate(forSection: section)]
	}
	
	
	/// indexPath에 해당하는 fitnessLog를 return하는 함수
	/// - Returns: indexPath에 해당하는 fitnessLog, 또는 nil
	func fitnessLog(for indexPath: IndexPath) -> FitnessLogEntity? {
		return rows(forSection: indexPath.section)?[indexPath.row]
	}
}
