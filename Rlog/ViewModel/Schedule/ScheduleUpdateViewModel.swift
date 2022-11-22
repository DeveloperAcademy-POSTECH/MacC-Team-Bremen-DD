//
//  ScheduleUpdateViewModel.swift
//  Rlog
//
//  Created by Noah's Ark on 2022/11/19.
//

import Foundation

final class ScheduleUpdateViewModel: ObservableObject {
    @Published var name = ""
    @Published var date = Date()
    @Published var startTime = Date()
    @Published var endTime = Date()
    @Published var memo = ""
    @Published var isAlertActive = false
    @Published var workday: WorkdayEntity? = nil {
        didSet {
            guard
                let workday = workday,
                let memo = workday.memo,
                memo != ""
            else { return }
            name = workday.workspace.name
            date = workday.date
            startTime = workday.startTime
            endTime = workday.endTime
            self.memo = memo
        }
    }
    @Published var isDatePickerActive = false
    @Published var isStartTimePickerActive = false
    @Published var isEndTimePickerActive = false
    
    func onAppear(_ data: WorkdayEntity) {
        getWorkdayInformation(data)
    }
    
    func didTapConfirmationButton() {
        changeWorkdayInformation()
    }
    
    func didTapDeleteButton() {
        isAlertActive = true
    }
    
    func didConfirmDeleteWorday() {
        deleteWorkday()
    }
}

private extension ScheduleUpdateViewModel {
    func getWorkdayInformation(_ data: WorkdayEntity) {
        workday = data
    }
    
    func changeWorkdayInformation() {
        // TODO: Use editWorkday CoreDataManager
        print("👀 Edited Workday Information")
        print(name)
        print("\(date)")
        print("\(startTime)")
        print("\(endTime)")
        print("\(memo)")
        print("=============================")
    }
    
    func deleteWorkday() {
        guard let workday = self.workday else { return }
        CoreDataManager.shared.deleteWorkday(of: workday)
        isAlertActive = false
    }
}
