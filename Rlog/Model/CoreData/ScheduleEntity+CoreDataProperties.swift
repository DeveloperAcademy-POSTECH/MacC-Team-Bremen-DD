//
//  ScheduleEntity+CoreDataProperties.swift
//  Rlog
//
//  Created by Kim Insub on 2022/10/24.
//
//

import CoreData
import Foundation

extension ScheduleEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScheduleEntity> {
        return NSFetchRequest<ScheduleEntity>(entityName: "ScheduleEntity")
    }

    @NSManaged public var repeatedSchedule: [String]
    @NSManaged public var startTime: String
    @NSManaged public var endTime: String
    @NSManaged public var spentHour: Int16
    @NSManaged public var workspace: WorkspaceEntity

}

extension ScheduleEntity : Identifiable {

}
