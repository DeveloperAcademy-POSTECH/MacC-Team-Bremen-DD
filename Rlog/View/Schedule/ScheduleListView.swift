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
    let mockData: [WorkspaceEntitySample] = [
        WorkspaceEntitySample(
            name: "팍이네 팍팍 감자탕",
            schedules: ScheduleEntitySample(),
            workdays: WorkdayEntitySample(date: Date(), endHour: 18)
        ),
        WorkspaceEntitySample(
            name: "팍이네 팍팍 감자탕",
            schedules: ScheduleEntitySample(),
            workdays: WorkdayEntitySample(date: Date(), endHour: 15)
        ),
        WorkspaceEntitySample(
            name: "팍이네 팍팍 감자탕",
            schedules: ScheduleEntitySample(),
            workdays: WorkdayEntitySample(date: Date(), endHour: 22)
        )
    ]

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                header
                scheduleContainer
            }
            .background(.gray)
            .navigationBarHidden(true)
        }
    }
}

private extension ScheduleListView {
    var header: some View {
        
        HStack(spacing: 0) {
            Group {
                Button {
                } label: {
                    Image(systemName: "chevron.left")
                }
                
                Text(currentMonth)
                    .fontWeight(.bold)
                    .padding(.horizontal, 3)
                
                Button {
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
            .font(.title)
            .foregroundColor(Color.fontBlack)
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
                destination: SchedulePendingListView(),
                isActive: $isSchedulePendingListViewActive
            ) { EmptyView() }
            NavigationLink(
                 destination: ScheduleCreationView(),
                 isActive: $isScheduleCreationViewActive
             ) { EmptyView() }
        }
        .padding(EdgeInsets(top: 24, leading: 20, bottom: 54, trailing: 20))
    }
    
    var scheduleContainer: some View {
        
        VStack(spacing: 0) {
            Group {
                weekDaysContainer
                    .padding(.top)
                    .padding(.bottom, 3)
                
                datesContainer
                    .padding(.bottom, 8)
                HDivider()
                    .padding(.bottom, 32)
                scheduleList
            }
            .padding(.horizontal, 22)
            Spacer()
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
                                .foregroundColor(.grayDark)
                                .padding(.bottom, 9)
                        }
                        .frame(maxWidth: .infinity)
                        
                        Circle()
                            .frame(width: 6, height: 6)
                            .foregroundColor(.green)
                    }
                    
                    if viewModel.verifyFocusDate(currentWeek[index].day) {
                        
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
                    
                    Circle()
                        .frame(width: 6, height: 6)
                        .foregroundColor(Color.primary)
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
                    
                    Circle()
                        .frame(width: 6, height: 6)
                        .foregroundColor(Color.primary)
                }
            }
        }
    }
    
    var scheduleList: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 8) {
                ForEach(mockData) { data in
                    ScheduleCell(currentDate: viewModel.currentDate, data: data)
                }
                Spacer()
            }
        }
    }
}
