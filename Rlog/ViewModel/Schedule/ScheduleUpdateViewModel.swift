//
//  ScheduleUpdateViewModel.swift
//  Rlog
//
//  Created by Noah's Ark on 2022/11/19.
//

import Foundation

final class ScheduleUpdateViewModel: ObservableObject {
    let workday: WorkdayEntity
    
    @Published var name: String
    @Published var date: Date
    @Published var startTime: Date
    @Published var endTime: Date
    @Published var memo: String
    @Published var isAlertActive = false
    
    init(workday: WorkdayEntity) {
        self.workday = workday
        self.name = workday.workspace.name
        self.date = workday.date
        self.startTime = workday.startTime
        self.endTime = workday.endTime
        self.memo = workday.memo ?? ""
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
