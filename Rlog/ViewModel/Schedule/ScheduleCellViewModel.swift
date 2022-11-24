//
//  ScheduleCellViewModel.swift
//  Rlog
//
//  Created by Hyeon-sang Lee on 2022/11/22.
//

import SwiftUI

final class ScheduleCellViewModel: ObservableObject{
    private let timeManager = TimeManager()
    private let workTypeManager = WorkTypeManager()
    let data: WorkdayEntity
    @Published var workType: WorkDayType = .regular
    @Published var spentHour = ""
    @Published var startTimeString = ""
    @Published var endTimeString = ""
    @Published var hasDone = false
    
    init(of data: WorkdayEntity) {
        self.data = data
        onAppear()
    }
    
    func onAppear() {
        self.workType = workTypeManager.defineWorkType(data: data)
        getSpentHour(data.endTime, data.startTime)
        getStartAndEndTimeAndMinute(data.startTime, data.endTime)
        verifyIsScheduleExpired(data.endTime)
    }
    
    func didTapConfirmationButton(_ data: WorkdayEntity) {
        toggleWorkdayHasDoneEntity(data)
    }
}

extension ScheduleCellViewModel {
    func toggleWorkdayHasDoneEntity(_ data: WorkdayEntity) {
        CoreDataManager.shared.toggleHasDone(of: data)
    }
    
    func getSpentHour(_ endTime: Date, _ startTime: Date) {
        let timeGap = endTime - startTime
        let result = timeManager.secondsToHoursMinutesSeconds(timeGap)
        
        self.spentHour = result.1 < 30 ? "\(result.0)시간" : "\(result.0)시간 \(result.1)분"
    }

    func getStartAndEndTimeAndMinute(_ startTime: Date, _ endTime: Date) {
        let startTime = timeManager.getHourAndMinute(startTime)
        let endTime = timeManager.getHourAndMinute(endTime)
        
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
