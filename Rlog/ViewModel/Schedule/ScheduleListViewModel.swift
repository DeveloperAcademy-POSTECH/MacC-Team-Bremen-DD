//
//  ScheduleListViewModel.swift
//  Rlog
//
//  Created by Noah's Ark on 2022/11/08.
//
// ✅ 강제 unwrapping 이 진행된 경우를 주석으로 표기했습니다.

import Foundation
import SwiftUI

final class ScheduleListViewModel: ObservableObject {
    @Published var nextDate = Calendar.current.date(byAdding: .weekOfMonth, value: 1, to: Date())! // ✅
    @Published var previousDate = Calendar.current.date(byAdding: .weekOfMonth, value: -1, to: Date())! // ✅
    @Published var currentDate = Date() {
        didSet {
            guard let nextWeek = Calendar.current.date(byAdding: .weekOfMonth, value: 1, to: currentDate)
            else { return }
            guard let previousWeek = Calendar.current.date(byAdding: .weekOfMonth, value: -1, to: currentDate)
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
}

extension ScheduleListViewModel {
    // 일주일 뒤의 날짜를 반환합니다.
    private func getNextWeek() {
        guard let dateOfNextWeek = calendar.date(byAdding: .weekOfMonth, value: 1, to: currentDate)
        else { return }
        currentDate = dateOfNextWeek
    }

    // 일주일 전의 날짜를 반환합니다.
    private func getPreviousWeek() {
        guard let dateOfPreviousWeek = calendar.date(byAdding: .weekOfMonth, value: -1, to: currentDate)
        else { return }
        currentDate = dateOfPreviousWeek
    }
    
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
        let days = calendar
            .range(of: .weekday, in: .weekOfYear, for: today)! // ✅
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
        
        // 반환된 배열의 날짜 데이터를 각각 추출합니다.
        // UI 작업을 위해 임시로 사용합니다.
        let weekdayArray = days.map {
            let components = calendar.dateComponents([.year, .month, .day], from: $0)
            let year = components.year! // ✅
            let month = components.month! // ✅
            let day = components.day! // ✅
            
            return CalendarModel(year: year, month: month, day: day)
        }
        
        return weekdayArray
    }
}

// Sample calendar model
struct CalendarModel {
    let year: Int
    let month: Int
    let day: Int
}
