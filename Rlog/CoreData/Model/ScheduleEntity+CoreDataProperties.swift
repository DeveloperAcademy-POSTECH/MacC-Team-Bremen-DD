//
//  ScheduleEntity+CoreDataProperties.swift
//  Rlog
//
//  Created by Kim Insub on 2022/11/11.
//
//

import Foundation
import CoreData


extension ScheduleEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScheduleEntity> {
        return NSFetchRequest<ScheduleEntity>(entityName: "ScheduleEntity")
    }

    @NSManaged public var repeatDays: [String]
    @NSManaged public var startHour: Int16
    @NSManaged public var startMinute: Int16
    @NSManaged public var endHour: Int16
    @NSManaged public var endMinute: Int16
    @NSManaged public var workspace: WorkspaceEntity
    @NSManaged public var workdays: NSSet?

}

// MARK: Generated accessors for workdays
extension ScheduleEntity {

    @objc(addWorkdaysObject:)
    @NSManaged public func addToWorkdays(_ value: WorkdayEntity)

    @objc(removeWorkdaysObject:)
    @NSManaged public func removeFromWorkdays(_ value: WorkdayEntity)

    @objc(addWorkdays:)
    @NSManaged public func addToWorkdays(_ values: NSSet)

    @objc(removeWorkdays:)
    @NSManaged public func removeFromWorkdays(_ values: NSSet)

}

extension ScheduleEntity : Identifiable {

}
