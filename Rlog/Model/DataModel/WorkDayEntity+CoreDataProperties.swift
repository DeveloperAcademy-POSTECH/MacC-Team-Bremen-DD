//
//  WorkDayEntity+CoreDataProperties.swift
//  Rlog
//
//  Created by Kim Insub on 2022/10/20.
//
//

import CoreData
import Foundation

extension WorkDayEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkDayEntity> {
        return NSFetchRequest<WorkDayEntity>(entityName: "WorkDayEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var weekDay: Int16
    @NSManaged public var yearInt: Int16
    @NSManaged public var monthInt: Int16
    @NSManaged public var dayInt: Int16
    @NSManaged public var startTime: String
    @NSManaged public var endTime: String
    @NSManaged public var spentHour: Int16
    @NSManaged public var workspace: WorkspaceEntity

    var weekDayType: WeekDay {
        get {
            WeekDay(rawValue: self.weekDay) ?? .mon
        }
        set {
            self.weekDay = newValue.rawValue
        }
    }

}

extension WorkDayEntity : Identifiable {

}
