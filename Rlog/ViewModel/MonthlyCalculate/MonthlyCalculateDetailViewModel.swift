//
//  MonthlyCalculateDetailViewModel.swift
//  Rlog
//
//  Created by 정지혁 on 2022/11/14.
//

import SwiftUI

@MainActor
final class MonthlyCalculateDetailViewModel: ObservableObject {
    let calculateResult: MonthlyCalculateResult
    @Published var isShareSheetActive = false
    @Published var items: [Any] = []
    @Published var proxy: GeometryProxy? = nil
    @Published var calendarDays: [Date] = []
    @Published var emptyCalendarDays: [Int] = []
    @Published var startDate = Date()
    @Published var target = Date()
    
    let current: Date
    let workTypeManager = WorkTypeManager()
    
    var notRegularWorkdays: [WorkdayEntity] {
        return calculateResult.hasDoneWorkdays.filter { workTypeManager.defineWorkType(workday: $0) != .regular }
    }
    
    init(calculateResult: MonthlyCalculateResult) {
        self.calculateResult = calculateResult
        self.current = calculateResult.currentMonth
        Task {
            await makeCalendarDates()
            makeEmptyCalendarDates()
        }
    }
    
    func filterWorkday(for day: Date) -> [WorkdayEntity] {
        return calculateResult.hasDoneWorkdays.filter{ $0.date == day }
    }
    
    func getSpentHour(_ endTime: Date, _ startTime: Date) -> String {
        let timeGap = endTime - startTime
        let result = Date.secondsToHoursMinutesSeconds(timeGap)
        
        return result.1 < 30 ? "\(result.0)시간" : "\(result.0)시간 \(result.1)분"
    }
    
    func didTapShareButton(view: some View) {
        makeViewToImage(view) { [weak self] in
            guard let self = self else { return }
            self.shareViewImage()
        }
    }
}

private extension MonthlyCalculateDetailViewModel {
    func makeCalendarDates() async {
        let payDay = calculateResult.workspace.payDay
        var range = Date()
        
        print(calculateResult.startDate)
        print(calculateResult.endDate)
        
        let previous = Date.decreaseOneMonth(current)
        startDate = Calendar.current.date(bySetting: .day, value: Int(payDay), of: previous) ?? Date()
        range = startDate
        target = Calendar.current.date(byAdding: DateComponents(month: 1), to: range) ?? Date()
        
        while range < target {
            calendarDays.append(range)
            guard let next = Calendar.current.date(byAdding: DateComponents(day: 1), to: range) else { return }
            range = next
        }
    }
    
    func makeEmptyCalendarDates() {
        for count in 0..<startDate.weekDayInt - 1 {
            emptyCalendarDays.append(count)
        }
    }
    
    func makeViewToImage(_ view: some View, completion: @escaping () -> Void) {
        guard let proxy = proxy else { return }
        let image = view.takeScreenshot(origin: proxy.frame(in: .global).origin, size: proxy.size)
        
        items.removeAll()
        items.append(image)
        
        completion()
    }
    
    func shareViewImage() {
        self.isShareSheetActive = true
    }
}
