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
    
    var body: some View {
        VStack {
            header
            scheduleContainer
        }
        .background(.gray)
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
                Button {
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
            .font(.title)
            .foregroundColor(.black)
            Spacer()
            Button("메일함") { }
                .padding(.horizontal)
                .foregroundColor(.black)
            Button("추가") { }
                .foregroundColor(.black)
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
    }
    
    var scheduleContainer: some View {
        VStack(spacing: 0) {
            Group {
                weekDaysContainer
                    .padding(.top)
                datesContainer
                    .padding(.bottom, 11)
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, maxHeight: 1.5)
            }
            .padding(.horizontal, 22)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
        .cornerRadius(30, [.topLeft, .topRight])
        .padding(.top, 54)
        .ignoresSafeArea()
    }
    
    var weekDaysContainer: some View {
        HStack(spacing: 0) {
            ForEach(Weekday.allCases, id: \.self) { weekday in
                Text(weekday.rawValue)
                    .font(.caption)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.top)
    }
    
    var datesContainer: some View {
        VStack(spacing: 0) {
            TabView(selection: $selection) {
                previousWeekdayBox.tag(0)
                weekdayBox.tag(1)
                nextWeekdayBox.tag(2)
            }
            .frame(height: 50)
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
                    VStack {
                        Button {
                            withAnimation {
                                viewModel.didTapDate(currentWeek[index])
                            }
                        } label: {
                            Text("\(currentWeek[index].day)")
                                .font(.callout)
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity)

                        Circle()
                            .frame(width: 6, height: 6)
                            .foregroundColor(.green)
                    }

                    if viewModel.verifyFocusDate(currentWeek[index].day) {
                        VStack {
                            Text("\(currentWeek[index].day)")
                                .font(.callout)
                                .foregroundColor(.white)
                            Circle()
                                .frame(width: 6, height: 6)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(.blue)
                        .cornerRadius(15)
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
                    Circle()
                        .frame(width: 6, height: 6)
                        .foregroundColor(.green)
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
                    Circle()
                        .frame(width: 6, height: 6)
                        .foregroundColor(.green)
                }
            }
        }
    }
}
