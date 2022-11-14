//
//  WorkdayEntity+CoreDataProperties.swift
//  Rlog
//
//  Created by Kim Insub on 2022/11/11.
//
//

import Foundation
import CoreData


extension WorkdayEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkdayEntity> {
        return NSFetchRequest<WorkdayEntity>(entityName: "WorkdayEntity")
    }

    @NSManaged public var date: Date
    @NSManaged public var hourlyWage: Int32
    @NSManaged public var startTime: Date
    @NSManaged public var endTime: Date
    @NSManaged public var memo: String?
    @NSManaged public var workspace: WorkspaceEntity
    @NSManaged public var schedule: ScheduleEntity?

}

extension WorkdayEntity : Identifiable {

}
