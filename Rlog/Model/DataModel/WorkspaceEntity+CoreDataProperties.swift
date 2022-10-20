//
//  WorkspaceEntity+CoreDataProperties.swift
//  Rlog
//
//  Created by Kim Insub on 2022/10/20.
//
//

import Foundation
import CoreData


extension WorkspaceEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkspaceEntity> {
        return NSFetchRequest<WorkspaceEntity>(entityName: "WorkspaceEntity")
    }

    @NSManaged public var name: String
    @NSManaged public var paymentDay: Int16
    @NSManaged public var hourlyWage: Int16
    @NSManaged public var color: String
    @NSManaged public var hasTax: Bool
    @NSManaged public var hasJuhyu: Bool
    @NSManaged public var schedules: ScheduleEntity
    @NSManaged public var workDays: WorkDayEntity

}

extension WorkspaceEntity : Identifiable {

}
