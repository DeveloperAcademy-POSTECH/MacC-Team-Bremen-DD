//
//  ScheduleCreationViewModel.swift
//  Rlog
//
//  Created by Hyeon-sang Lee on 2022/11/14.
//

import SwiftUI

final class ScheduleCreationViewModel: ObservableObject {
    @Published var isFocused = false
    @Published var workspaces: [WorkspaceEntity] = []
    @Published var selectedWorkspaceString: String = "" {
        didSet {
            let result = workspaces.filter { $0.name == selectedWorkspaceString}
            self.selectedWorkspaceEntity = result.first
        }
    }
    @Published var selectedWorkspace: WorkspaceEntity? = nil
    @Published var workday: Date = Date()
    @Published var startTime: Date = Date()
    @Published var endTime: Date = Date()
    @Published var memo: String = ""
    @Published var isAlertActive = false
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

    init(of selectedDate: Date) {
        workday = selectedDate
        self.startTime = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: selectedDate) ?? Date()
        self.endTime = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: selectedDate) ?? Date()
    }
    
    var selectedWorkspaceEntity: WorkspaceEntity? = nil
    
    func onAppear() {
        getAllWorkspaces()
    }
    
    func didTapCreationButton() {
        isAlertActive = true
    }
    
    func didTapConfirmationButton() {
        createWorkday()
    }
    
    func getWorkspacesListString() -> [String] {
        var result: [String] = []
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
        guard let workspaceEntity = selectedWorkspaceEntity else { return }
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
}
