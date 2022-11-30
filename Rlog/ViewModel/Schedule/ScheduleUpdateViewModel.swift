//
//  ScheduleUpdateViewModel.swift
//  Rlog
//
//  Created by Noah's Ark on 2022/11/19.
//

import SwiftUI

final class ScheduleUpdateViewModel: ObservableObject {
    let workday: WorkdayEntity
    let alreadyExistWorkdays: [WorkdayEntity]
    
    @Published var name: String
    @Published var date: Date
    @Published var startTime: Date
    @Published var endTime: Date
    @Published var memo: String
    @Published var isAlertActive = false
    @Published var isWorkdayPickerActive = false
    @Published var isStartTimePickerActive = false {
        willSet {
            if newValue == true {
                withAnimation {
                    self.isEndTimePickerActive = false
                }
            }
        }
    }
    @Published var isEndTimePickerActive = false {
        willSet {
            if newValue == true {
                withAnimation {
                    self.isStartTimePickerActive = false
                }
            }
        }
    }
    @Published var isConflictAlertActive = false
    
    init(workday: WorkdayEntity) {
        self.workday = workday
        self.name = workday.workspace.name
        self.date = workday.date
        self.startTime = workday.startTime
        self.endTime = workday.endTime
        self.memo = workday.memo ?? ""
        self.alreadyExistWorkdays = CoreDataManager.shared.getWorkdaysBetween(start: workday.date, target: Calendar.current.date(byAdding: DateComponents(day: 1), to: workday.date) ?? workday.date).filter { $0.objectID != workday.objectID }
    }
    
    func didTapConfirmationButton() async {
        await updateWorkday()
    }
    
    func didTapDeleteButton() {
        isAlertActive.toggle()
    }
    
    func didConfirmDeleteWorday() async {
        await deleteWorkday()
    }
    
    func checkConflict() -> Bool {
        var isNotConflict = true
        
        for workday in alreadyExistWorkdays {
            if workday.startTime <= startTime && endTime <= workday.endTime {
                isNotConflict = false
            } else if startTime < workday.startTime {
                if workday.startTime < endTime {
                    isNotConflict = false
                }
            } else if workday.endTime < endTime {
                if startTime < workday.endTime {
                    isNotConflict = false
                }
            }
        }
        
        return isNotConflict
    }
}

private extension ScheduleUpdateViewModel {
    func updateWorkday() async {
        CoreDataManager.shared.editWorkday(
            of: workday,
            startTime: startTime,
            endTime: endTime,
            memo: memo
        )
    }
    
    func deleteWorkday() async {
        CoreDataManager.shared.deleteWorkday(of: workday)
    }
}
