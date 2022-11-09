//
//  ScheduleListView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI

struct ScheduleListView: View {
    @ObservedObject private var viewModel = ScheduleListViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                header
                    .padding(.top, 32)
                    .padding(.leading, 7)
                scheduleList
                    .padding(.top, 36)
            }
            .padding(.horizontal)
            
            Rectangle()
                .fill(LinearGradient(colors: [Color.clear, Color.gradientGray], startPoint: .top, endPoint: .bottom))
                .frame(height: 68)
            
            StatusPicker(selectedScheduleCase: $viewModel.selectedScheduleCase)
                .frame(width: 176, height: 40)
                .padding(.bottom)
        }
        .background(
           background
        )
    }
}

private extension ScheduleListView {
    var background: some View {
        Rectangle()
            .fill(Color.cardBackground)
            .edgesIgnoringSafeArea(.top)
    }
    
    var header: some View {
        HStack(spacing: 0) {
            Image(systemName: "chevron.backward")
            Text(viewModel.yearAndMonth)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.fontBlack)
                .padding(.horizontal, 10)
            Image(systemName: "chevron.right")
            Spacer()
        }
    }
    
    var scheduleList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                scheduleListHeader
                Button(action: {
                    viewModel.didTapPlusButton()
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .frame(height: 97)
                        Image(systemName: "plus")
                            .font(.title)
//                            .fontWeight(.semibold)
                            .foregroundColor(Color.primary)
                    }
                })
                .padding(.top)
                .sheet(isPresented: $viewModel.isShowCreateModal, onDismiss: {
                    viewModel.didSheetDismissed()
                }) {
                    NavigationView {
                        ScheduleCreateView()
                    }
                }
                switch viewModel.selectedScheduleCase {
                case .upcoming:
                    ForEach(viewModel.upcomingWorkDays, id: \.self) { schedule in
                        // TODO: - 다른 방법 생각 생각해보기(async 등)
                        ScheduleCell(workDayEntity: schedule) {
                            viewModel.didSheetDismissed()
                        }
                    }
                    .padding(.top)
                case .past:
                    ForEach(viewModel.pastWorkDays, id: \.self) { schedule in
                        // TODO: - 다른 방법 생각 생각해보기(async 등)
                        ScheduleCell(workDayEntity: schedule) {
                            viewModel.didSheetDismissed()
                        }
                    }
                    .padding(.top)
                }
            }
        }
//        .scrollIndicators(.hidden)
    }
    
    var scheduleListHeader: some View {
        HStack(spacing: 0) {
            Image(systemName: "checkmark")
                .foregroundColor(Color.primary)
//                .fontWeight(.bold)
            Text(viewModel.selectedScheduleCase.rawValue)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(Color.fontBlack)
                .padding(.leading, 5)
        }
    }
}
