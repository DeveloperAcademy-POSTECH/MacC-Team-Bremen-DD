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
    @NSManaged public var startHour: Int16
    @NSManaged public var startMinute: Int16
    @NSManaged public var endHour: Int16
    @NSManaged public var endMinute: Int16
    @NSManaged public var spentHour: Double
    @NSManaged public var workspace: WorkspaceEntity

}

extension ScheduleEntity : Identifiable {

}
