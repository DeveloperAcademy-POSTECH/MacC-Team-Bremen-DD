//
//  ScheduleListViewModel.swift
//  Rlog
//
//  Created by Noah's Ark on 2022/11/08.
//

import SwiftUI

final class ScheduleListViewModel: ObservableObject {
    @Published var nextDate = Calendar.current.date(byAdding: .weekOfMonth, value: 1, to: Date()) ?? Date()
    @Published var previousDate = Calendar.current.date(byAdding: .weekOfMonth, value: -1, to: Date()) ?? Date()
    @Published var currentDate = Date() {
        didSet {
            guard
                let nextWeek = Calendar.current.date(byAdding: .weekOfMonth, value: 1, to: currentDate),
                let previousWeek = Calendar.current.date(byAdding: .weekOfMonth, value: -1, to: currentDate)
            else { return }
            
            nextDate = nextWeek
            previousDate = previousWeek
        }
    }
    let calendar = Calendar.current
    
    func didScrollToNextWeek() {
        getNextWeek()
    }
    
    func didScrollToPreviousWeek() {
        getPreviousWeek()
    }
    
    func didTapDate(_ date: CalendarModel) {
        changeFocusDate(date)
    }
}

// MARK: Private functions
private extension ScheduleListViewModel {
    // 일주일 뒤의 날짜를 반환합니다.
    func getNextWeek() {
        guard let dateOfNextWeek = calendar.date(byAdding: .weekOfMonth, value: 1, to: currentDate)
        else { return }
        currentDate = dateOfNextWeek
    }

    // 일주일 전의 날짜를 반환합니다.
    func getPreviousWeek() {
        guard let dateOfPreviousWeek = calendar.date(byAdding: .weekOfMonth, value: -1, to: currentDate)
        else { return }
        currentDate = dateOfPreviousWeek
    }
    
    // 사용자가 다른 날짜를 터치했을 때 Focus를 변경합니다.
    func changeFocusDate(_ date: CalendarModel) {
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        let year = components.year ?? 2000
        let month = components.month ?? 1
        var focusDateComponents = DateComponents(year: year, month: month, day: date.day)
        guard var focusDate = calendar.date(from: focusDateComponents) else { return }

        // 캘린더 날짜와 터치된 날짜의 년도, 월이 다른 경우
        // 월 정보만 바뀌어도 년도 케이스 핸들링이 가능하므로 월 정보만 비교합니다.
        if date.month != month {
            focusDateComponents = DateComponents(year: date.year, month: date.month, day: date.day)
            guard let data = calendar.date(from: focusDateComponents) else { return }
            focusDate = data
        }
        
        currentDate = focusDate
    }
}

extension ScheduleListViewModel {
    // 오늘 날짜가 속한 주의 날짜 데이터를 반환합니다.
    // https://stackoverflow.com/questions/42981665/how-to-get-all-days-in-current-week-in-swift
    func getWeekOfDate(_ date: Date) -> [CalendarModel] {
        let today = calendar.startOfDay(for: date)
        let dayOfWeek = calendar.component(.weekday, from: today)
        
        // .range: 1..<8 을 반환합니다. 1 = 일요일, 7 = 토요일
        // .compactMap: 각 range의 값에서 오늘의 요일 만큼 차감한 값을 today에 적용합니다. nil의 경우는 제외합니다.
        // ex
        //  1  2  3 4 5 6 7 (range)
        // -3 -2 -1 0 1 2 3 (today가 수요일인 경우를 적용, 4 = 수요일)
        //  [3일 전, 2일 전, 1일 전, 오늘, 1일 후, 2일 후, 3일 후] (반환값)
        guard let rangeData = calendar.range(of: .weekday, in: .weekOfYear, for: today)
        else { return [] }
        let days = rangeData.compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
        
        // 반환된 배열의 날짜 데이터를 각각 추출합니다.
        // UI 작업을 위해 임시로 사용합니다.
        let weekdayArray = days.map {
            let components = calendar.dateComponents([.year, .month, .day], from: $0)
            let year = components.year ?? 2000
            let month = components.month ?? 1
            let day = components.day ?? 1
            
            return CalendarModel(year: year, month: month, day: day)
        }
        
        return weekdayArray
    }
    
    // 터치된 날짜를 판단합니다.
    func verifyFocusDate(_ focusDate: Int) -> Bool {
        let components = calendar.dateComponents([.day], from: currentDate)
        guard let date = components.day else { return false }
        
        if focusDate == date { return true }
        else { return false }
    }
    
    // 🔥 필요한 것만 받기 -> 파라미터 너무 많음
    // 🔥 WorkspaceEntity 하나 받기 -> 간단함 but over-fetching
    func defineWorkType(
        repeatDays: [String],
        workDate: Date,
        startHour: Int16,
        startMinute: Int16,
        endHour: Int16,
        endMinute: Int16,
        spentHour: Int16
    ) -> (type: String, color: Color) {
        let formatter = DateFormatter(dateFormatType: .weekday)
        let _ = formatter.string(from: workDate)
        let spentHourOfNormalCase: Int16 = endHour - startHour
        let timeDifference = spentHour - spentHourOfNormalCase
        
        //        for day in repeatDays {
        //            if day != weekday { return ("추가", .blue) }
        //        }
        
        switch timeDifference {
        // "추가" case 누락
        case 0:
            return ("정규", Color.primary)
        case 1...:
            return ("연장", Color.pointBlue)
        case _ where timeDifference < 0:
            return ("축소", Color.pointRed)
        default:
            return ("정규", .green)
        }
    }
}

// Sample calendar model
struct CalendarModel {
    let year: Int
    let month: Int
    let day: Int
}
