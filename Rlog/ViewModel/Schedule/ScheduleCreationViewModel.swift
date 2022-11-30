//
//  ScheduleCreationViewModel.swift
//  Rlog
//
//  Created by Hyeon-sang Lee on 2022/11/14.
//

import SwiftUI

final class ScheduleCreationViewModel: ObservableObject {
    let alreadyExistWorkdays: [WorkdayEntity]
    
    @Published var isFocused = false
    @Published var workspaces: [WorkspaceEntity] = []
    @Published var selectedWorkspaceString: String = "" {
        didSet {
            let result = workspaces.filter { $0.name == selectedWorkspaceString}
            self.selectedWorkspace = result.first
        }
    }
    @Published var selectedWorkspace: WorkspaceEntity? = nil
    @Published var workday: Date = Date()
    @Published var startTime: Date = Date()
    @Published var endTime: Date = Date()
    @Published var memo: String = ""
    @Published var isAlertActive = false
    @Published var isConflictAlertActive = false
    @Published var isWorkdayPickerActive = false {
        willSet {
            if newValue == true {
                withAnimation {
                    self.isStartTimePickerActive = false
                    self.isEndTimePickerActive = false
                }
            }
        }
    }
    @Published var isStartTimePickerActive = false {
        willSet {
            if newValue == true {
                withAnimation {
                    self.isWorkdayPickerActive = false
                    self.isEndTimePickerActive = false
                }
            }
        }
    }
    @Published var isEndTimePickerActive = false {
        willSet {
            if newValue == true {
                withAnimation {
                    self.isWorkdayPickerActive = false
                    self.isStartTimePickerActive = false
                }
            }
        }
    }
    
    var isSelectedWorkspace: Bool {
        return selectedWorkspaceString != ""
    }

    init(of selectedDate: Date) {
        workday = selectedDate
        self.startTime = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: selectedDate) ?? Date()
        self.endTime = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: selectedDate) ?? Date()
        self.alreadyExistWorkdays = CoreDataManager.shared.getWorkdaysBetween(start: selectedDate, target: Calendar.current.date(byAdding: DateComponents(day: 1), to: selectedDate) ?? selectedDate)
        print(alreadyExistWorkdays)
    }
    
    func onAppear() {
        getAllWorkspaces()
    }
    
    func didTapCreationButton() {
        if checkConflict() {
            isAlertActive.toggle()
        } else {
            isConflictAlertActive.toggle()
        }
    }
    
    func didTapConfirmationButton() {
        createWorkday()
    }
    
    func getWorkspacesListString() -> [String] {
        var result: [String] = [""]
        for workspace in workspaces {
            result.append(workspace.name)
        }
        return result
    }    
}

private extension ScheduleCreationViewModel {
    func getAllWorkspaces() {
        let result = CoreDataManager.shared.getAllWorkspaces()
        workspaces = result
        
        if result.count == 1 {
            self.selectedWorkspaceString = result[0].name
        }
    }
    
    func createWorkday() {
        guard let workspaceEntity = selectedWorkspace else { return }
        guard let date = workday.onlyDate else { return }
        CoreDataManager.shared.createWorkday(
            of: workspaceEntity,
            hourlyWage: workspaceEntity.hourlyWage,
            hasDone: false,
            date: date,
            startTime: startTime,
            endTime: endTime,
            memo: memo,
            schedule: nil
        )
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
