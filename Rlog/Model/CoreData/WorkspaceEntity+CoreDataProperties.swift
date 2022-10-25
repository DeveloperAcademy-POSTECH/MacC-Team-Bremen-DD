//
//  WorkspaceEntity+CoreDataProperties.swift
//  Rlog
//
//  Created by Kim Insub on 2022/10/24.
//
//

import CoreData
import SwiftUI

extension WorkspaceEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkspaceEntity> {
        return NSFetchRequest<WorkspaceEntity>(entityName: "WorkspaceEntity")
    }

    @NSManaged public var name: String
    @NSManaged public var paymentDay: Int16
    @NSManaged public var hourlyWage: Int16
    @NSManaged public var colorString: String
    @NSManaged public var hasTax: Bool
    @NSManaged public var hasJuhyu: Bool
    @NSManaged public var schedules: ScheduleEntity
    @NSManaged public var workDays: WorkDayEntity

    var colorProperty: Color {
        Color(self.colorString)
    }

}

extension WorkspaceEntity : Identifiable {

}
