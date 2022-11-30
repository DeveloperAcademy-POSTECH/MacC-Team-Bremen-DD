//
//  ScheduleListViewModel.swift
//  Rlog
//
//  Created by Noah's Ark on 2022/11/08.
//

import SwiftUI

final class ScheduleListViewModel: ObservableObject {
    let calendar = Calendar.current
    let timeManager = TimeManager()
    @Published var workspaces: [WorkspaceEntity] = []
    @Published var workdays: (hasNotDone: [WorkdayEntity], hasDone: [WorkdayEntity]) = ([], [])
    @Published var workdaysOfFocusedDate: (hasNotDone: [WorkdayEntity], hasDone: [WorkdayEntity]) = ([], [])
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
    var hasWorkspace: Bool {
        return workspaces != []
    }
    
    func onAppear() {
        // 생성된 근무지 여부를 확인합니다. 생성된 근무지가 없다면 예외처리 화면을 표시합니다.
        getAllWorkspaces()
        getWorkdaysOfFiveMonths()
        getWorkdaysOfFocusDate()
    }
    
    func didScrollToNextWeek() {
        getNextWeek()
        getWorkdaysOfFocusDate()
    }
    
    func didScrollToPreviousWeek() {
        getPreviousWeek()
        getWorkdaysOfFocusDate()
    }
    
    func didTapNextMonth() {
        getNextMonth()
        getWorkdaysOfFocusDate()
    }
    
    func didTapPreviousMonth() {
        getPreviousMonth()
        getWorkdaysOfFocusDate()
    }
    
    func didTapDate(_ date: CalendarModel) {
        changeFocusDate(date)
        getWorkdaysOfFocusDate()
    }
}

// MARK: Private functions
private extension ScheduleListViewModel {
    func getAllWorkspaces() {
        let result = CoreDataManager.shared.getAllWorkspaces()
        self.workspaces = result
    }
    
    // 일주일 뒤의 날짜를 반환합니다.
    func getNextWeek() {
        currentDate = timeManager.increaseOneWeek(currentDate)
    }
    
    // 일주일 전의 날짜를 반환합니다.
    func getPreviousWeek() {
        currentDate = timeManager.decreaseOneWeek(currentDate)
    }
    
    // 한 달 뒤의 날짜를 반환합니다.
    // 갱신 이후 한 달 전의 오늘 날짜로 포커싱 됩니다. (ex. 11월 9일 -> 12월 9일)
    func getNextMonth() {
        let resetWeeks = resetWeekChanges()
        currentDate = timeManager.increaseOneMonth(resetWeeks)
    }
    
    // 한 달 전의 날짜를 반환합니다.
    // 갱신 이후 한 달 전의 오늘 날짜로 포커싱 됩니다. (ex. 11월 9일 -> 10월 9일)
    func getPreviousMonth() {
        let resetWeeks = resetWeekChanges()
        currentDate = timeManager.decreaseOneMonth(resetWeeks)
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
    
    // 사용자가 getNextWeek, getPreviousWeek 함수를 통해 주 단위 변경을 진행한 경우를 초기화합니다.
    func resetWeekChanges() -> Date {
        // 현재 활성화된 날짜의 연, 월 데이터를 추출합니다.
        let currentComponents = calendar.dateComponents([.year, .month], from: currentDate)
        let year = currentComponents.year ?? 2000
        let month = currentComponents.month ?? 1
        
        // 오늘 날짜의 일 데이터를 추출합니다.
        let todayComponents = calendar.dateComponents([.day], from: Date())
        let day = todayComponents.day ?? 1
        
        // 연, 월, 일 데이터를 사용하여 DateComponents를 생성합니다.
        let extractedDate = DateComponents(year: year, month: month, day: day)
        
        return calendar.date(from: extractedDate) ?? Date()
    }
}

extension ScheduleListViewModel {
    func getWeekdayOfDate(_ date: Date) -> String {
        let weekday = timeManager.getWeekdayOfDate(date)
        
        return weekday
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
    func highlightFocusDate(_ focusDate: Int) -> Bool {
        let components = calendar.dateComponents([.day], from: currentDate)
        guard let date = components.day else { return false }
        
        if focusDate == date { return true }
        else { return false }
    }
    
    // 터치된 날짜의 월 데이터를 판단합니다.
    func isCurrentMonth(_ date: Int) -> Bool {
        let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        if date == components.month { return true }
        return false
    }
    
    // 확정이 안된 Workday 중, 확정하기 버튼이 활성화 되어있는 것만 true를 반환합니다.
    func isPassedAndHasNotDone(_ date: CalendarModel) -> Bool {
        let workdays = workdays.hasNotDone.filter { $0.date.yearInt == date.year && $0.date.monthInt == date.month && $0.date.dayInt == date.day }
        for workday in workdays {
            return isPassedWorkday(workday.endTime)
        }
        return false
    }
    
    func isPassedWorkday(_ endTime: Date) -> Bool {
        let order = NSCalendar.current.compare(Date(), to: endTime, toGranularity: .minute)
        switch order {
        case .orderedAscending:
            return false
        default:
            return true
        }
    }
    
    // ✅ Sample
    // 임시로 현재 날짜의 이전 2개월, 이후 3개월의 일정을 불러옵니다.
    func getWorkdaysOfFiveMonths() {
        var hasDoneWorkdays: [WorkdayEntity] = []
        var hasNotDoneWorkdays: [WorkdayEntity] = []
        
        let workdays = CoreDataManager.shared.getWorkdaysBetween(
            start: Calendar.current.date(byAdding: .month, value: -2, to: Date()) ?? Date() - (86400 * 60),
            target: Calendar.current.date(byAdding: .month, value: 3, to: Date()) ?? Date() + (86400 * 90)
        )
                
        for data in workdays {
            if data.hasDone {
                hasDoneWorkdays.append(data)
            } else {
                hasNotDoneWorkdays.append(data)
            }
        }
        
        self.workdays = (hasNotDoneWorkdays, hasDoneWorkdays)
    }
    
    // 🔥 네이밍 추천 받습니다.
    // 사용자가 터치한 날짜의 근무 일정이 있을 경우 화면에 표시합니다.
    func getWorkdaysOfFocusDate() {
        workdaysOfFocusedDate.hasNotDone.removeAll()
        workdaysOfFocusedDate.hasDone.removeAll()
        
        
        let hasNotDoneData = workdays.hasNotDone.filter { $0.date.onlyDate == currentDate.onlyDate }
        for data in hasNotDoneData {
            if data.hasDone {
                workdaysOfFocusedDate.hasDone.append(data)
            } else {
                workdaysOfFocusedDate.hasNotDone.append(data)
            }
        }

        for data in workdays.hasDone {
            if data.date.onlyDate == currentDate.onlyDate {
                workdaysOfFocusedDate.hasDone.append(data)
            }
        }        
    }
    
    // 스크롤 캘린더에 Circle 표시를 하기 위한 함수입니다.
    // 해당 일자에 근무 일정이 있을 경우 Circle을 표시합니다.
    func getWorkdayIndicator(_ date: CalendarModel) -> Bool {
        let givenDate = calendar.date(from: DateComponents(year: date.year, month: date.month, day: date.day)) ?? Date()
        
        if !workdays.hasNotDone.isEmpty || !workdays.hasDone.isEmpty {
            for data in workdays.hasNotDone {
                if data.date.onlyDate == givenDate.onlyDate { return true }
            }
            for data in workdays.hasDone {
                if data.date.onlyDate == givenDate.onlyDate { return true }
            }
        }
        
        return false
    }
}
