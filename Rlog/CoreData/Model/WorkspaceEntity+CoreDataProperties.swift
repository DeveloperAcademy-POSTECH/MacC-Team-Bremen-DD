//
//  WorkspaceEntity+CoreDataProperties.swift
//  Rlog
//
//  Created by Kim Insub on 2022/11/11.
//
//

import Foundation
import CoreData


extension WorkspaceEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkspaceEntity> {
        return NSFetchRequest<WorkspaceEntity>(entityName: "WorkspaceEntity")
    }

    @NSManaged public var name: String
    @NSManaged public var payDay: Int16
    @NSManaged public var hourlyWage: Int32
    @NSManaged public var hasTax: Bool
    @NSManaged public var hasJuhyu: Bool
    @NSManaged public var schedules: ScheduleEntity?
    @NSManaged public var workdays: WorkdayEntity?

}

// MARK: Generated accessors for schedules
extension WorkspaceEntity {

    @objc(addSchedulesObject:)
    @NSManaged public func addToSchedules(_ value: ScheduleEntity)

    @objc(removeSchedulesObject:)
    @NSManaged public func removeFromSchedules(_ value: ScheduleEntity)

    @objc(addSchedules:)
    @NSManaged public func addToSchedules(_ values: NSSet)

    @objc(removeSchedules:)
    @NSManaged public func removeFromSchedules(_ values: NSSet)

}

// MARK: Generated accessors for workdays
extension WorkspaceEntity {

    @objc(addWorkdaysObject:)
    @NSManaged public func addToWorkdays(_ value: WorkdayEntity)

    @objc(removeWorkdaysObject:)
    @NSManaged public func removeFromWorkdays(_ value: WorkdayEntity)

    @objc(addWorkdays:)
    @NSManaged public func addToWorkdays(_ values: NSSet)

    @objc(removeWorkdays:)
    @NSManaged public func removeFromWorkdays(_ values: NSSet)

}

extension WorkspaceEntity : Identifiable {

}
