//
//  ScheduleCellViewModel.swift
//  Rlog
//
//  Created by Hyeon-sang Lee on 2022/11/22.
//

import SwiftUI

final class ScheduleCellViewModel: ObservableObject{
    private let workTypeManager = WorkTypeManager()
    let data: WorkdayEntity
    let didTapConfirm: () -> Void
    @Published var workType: WorkDayType = .regular
    @Published var spentHour = ""
    @Published var startTimeString = ""
    @Published var endTimeString = ""
    @Published var hasDone = false
    var isShowPlus1: Bool {
        return data.startTime.dayInt != data.endTime.dayInt
    }
    
    init(of data: WorkdayEntity, didTapConfirm: @escaping () -> Void) {
        self.data = data
        self.didTapConfirm = didTapConfirm
        self.workType = workTypeManager.defineWorkType(workday: data)
        getSpentHour(data.endTime, data.startTime)
        getStartAndEndTimeAndMinute(data.startTime, data.endTime)
        verifyIsScheduleExpired(data.endTime)
    }
    
    func didTapConfirmationButton(_ data: WorkdayEntity) {
        toggleWorkdayHasDoneEntity(data)
        didTapConfirm()
    }
}

extension ScheduleCellViewModel {
    func toggleWorkdayHasDoneEntity(_ data: WorkdayEntity) {
        CoreDataManager.shared.toggleHasDone(of: data)
    }
    
    func getSpentHour(_ endTime: Date, _ startTime: Date) {
        let timeGap = endTime - startTime
        let result = Date.secondsToHoursMinutesSeconds(timeGap)
        
        self.spentHour = result.1 < 30 ? "\(result.0)시간" : "\(result.0)시간 \(result.1)분"
    }

    func getStartAndEndTimeAndMinute(_ startTime: Date, _ endTime: Date) {
        let startTime = Date.getHourAndMinute(startTime)
        let endTime = Date.getHourAndMinute(endTime)
        
        startTimeString = "\(startTime.hour):\(startTime.minute >= 10 ? startTime.minute.description : "0\(startTime.minute)")"
        endTimeString = "\(endTime.hour):\(endTime.minute >= 10 ? endTime.minute.description : "0\(endTime.minute)")"
    }

    func verifyIsScheduleExpired(_ endTime: Date) {
        let order = NSCalendar.current.compare(Date(), to: endTime, toGranularity: .minute)
        switch order {
        case .orderedAscending:
            self.hasDone = true
        default:
            self.hasDone = false
        }
    }
}
