//
//  ScheduleListView.swift
//  Rlog
//
//  Created by Noah's Ark on 2022/11/08.
//

import SwiftUI

struct ScheduleListView: View {
    @ObservedObject var viewModel = ScheduleListViewModel()
    @State var selection = 1
    @State private var isSchedulePendingListViewActive = false
    @State private var isScheduleCreationViewActive = false
    
    // Sample to recognize when workspace is not found
    let isWorkspaceNotFound = false
    var weekday: String {
        let formatter = DateFormatter(dateFormatType: .weekday)
        return formatter.string(from: viewModel.currentDate)
    }

    var currentMonth: String {
        let components = Calendar.current.dateComponents([.year, .month], from: viewModel.currentDate)
        let year = components.year ?? 2000
        let month = components.month ?? 1
        
        return "\(year). \(month)"
    }
    
    var currentWeek: [CalendarModel] {
        return viewModel.getWeekOfDate(viewModel.currentDate)
    }
    
    var previousWeek: [CalendarModel] {
        return viewModel.getWeekOfDate(viewModel.previousDate)
    }
    
    var nextWeek: [CalendarModel] {
        return viewModel.getWeekOfDate(viewModel.nextDate)
    }
    
    var schedulesOfFocusDate: [WorkspaceEntitySample] {
        return viewModel.schedulesOfFocusDate
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                header
                scheduleContainer
            }
            .background(Color.backgroundStroke)
            .navigationBarHidden(true)
            .onAppear {
                viewModel.onAppear()
                print(viewModel.schedulesOfFocusDate)
            }
        }
    }
}

private extension ScheduleListView {
    var header: some View {
        
        HStack(spacing: 0) {
            YearMonthStepperCalendar(
                tapToPreviousMonth: viewModel.didTapPreviousMonth,
                tapToNextMonth: viewModel.didTapNextMonth,
                currentMonth: currentMonth
            )
            Spacer()
            // inbox.curved.badge로 조건 처리하면 됩니다.
            Button{ isSchedulePendingListViewActive.toggle() } label: {
                Image("inbox.curved")
            }
            .foregroundColor(.grayMedium)
            .padding(.trailing, 16)
            
            Button{ isScheduleCreationViewActive.toggle() } label: {
                Image("plus.curved")
            }
            .foregroundColor(.grayMedium)
            
            NavigationLink(
                destination: SchedulePendingListView().navigationTitle("미확인 일정"),
                isActive: $isSchedulePendingListViewActive
            ) { EmptyView() }
            NavigationLink(
                destination: ScheduleCreationView().navigationTitle("근무 일정 추가하기"),
                 isActive: $isScheduleCreationViewActive
             ) { EmptyView() }
        }
        .padding(EdgeInsets(top: 24, leading: 20, bottom: 54, trailing: 20))
    }
    
    var scheduleContainer: some View {
        
        VStack(spacing: 0) {
            Group {
                if isWorkspaceNotFound {
                    workspaceNotFound
                } else {
                    weekDaysContainer
                        .padding(.top)
                        .padding(.bottom, 3)
                    datesContainer
                        .padding(.bottom, 8)
                    HDivider()
                        .padding(.bottom, 32)
                    scheduleList
                }
            }
            .padding(.horizontal, 22)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundWhite)
        .cornerRadius(30, [.topLeft, .topRight])
        .ignoresSafeArea()
    }
    
    var weekDaysContainer: some View {
        HStack(spacing: 0) {
            ForEach(Weekday.allCases, id: \.self) { weekday in
                Text(weekday.rawValue)
                    .font(.caption)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.grayDark)
            }
        }
    }
    
    var datesContainer: some View {
        
        VStack(spacing: 0) {
            TabView(selection: $selection) {
                previousWeekdayBox.tag(0)
                weekdayBox.tag(1)
                nextWeekdayBox.tag(2)
            }
            .frame(maxHeight: 47)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: selection) { newValue in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    selection = 1
                    if newValue == 0 { viewModel.didScrollToPreviousWeek() }
                    if newValue == 2 { viewModel.didScrollToNextWeek() }
                }
            }
        }
    }
    
    var weekdayBox: some View {
        
        HStack(spacing: 0) {
            ForEach(0..<currentWeek.count, id: \.self) { index in
                ZStack {
                    
                    VStack(spacing: 0) {
                        Button {
                            viewModel.didTapDate(currentWeek[index])
                        } label: {
                            Text("\(currentWeek[index].day)")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(viewModel.verifyCurrentMonth(currentWeek[index].month) ? .grayDark : .gray)
                                .padding(.bottom, 9)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 5)

//                        Circle()
//                            .frame(width: 6, height: 6)
//                            .foregroundColor(viewModel.verifyCurrentMonth(currentWeek[index].month) ? .primary : .gray)
                    }
                    
                    if viewModel.highlightFocusDate(currentWeek[index].day) {
                        
                        VStack(spacing: 0) {
                            Text("\(currentWeek[index].day)")
                                .font(.callout)
                                .foregroundColor(Color.backgroundWhite)
                                .padding(.bottom, 9)

                            Circle()
                                .frame(width: 6, height: 6)
                                .foregroundColor(.white)
                        }
                        .padding(EdgeInsets(top: 3, leading: 6, bottom: 7, trailing: 6))
                        .frame(width: 32)
                        .background(Color.primary)
                        .cornerRadius(10)
                        .padding(.top, 2)
                          .transition(AnyTransition.opacity.animation(.easeInOut))
                    }
                }
            }
        }
    }
    
    var previousWeekdayBox: some View {
        
        HStack(spacing: 0) {
            ForEach(0..<previousWeek.count, id: \.self) { index in
                VStack {
                    Text("\(previousWeek[index].day)")
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 16, weight: .medium))
                }
            }
        }
    }
    
    var nextWeekdayBox: some View {
        
        HStack(spacing: 0) {
            ForEach(0..<nextWeek.count, id: \.self) { index in
                VStack {
                    Text("\(nextWeek[index].day)")
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 16, weight: .medium))
                }
            }
        }
    }
    
    var scheduleList: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 8) {
                ForEach(schedulesOfFocusDate) { data in
                        ScheduleCell(
                            currentDate: viewModel.currentDate,
                            data: data
                        )
                }
            }
        }
    }
    
    var workspaceNotFound: some View {
        VStack(spacing: 0) {
            Spacer()
            Text("근무지탭에서 근무지를 등록해주세요.")
                .padding(.bottom, 100)
                .font(Font.body.bold())
            Spacer()
        }
    }
}
