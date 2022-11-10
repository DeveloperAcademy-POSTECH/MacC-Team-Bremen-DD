//
//  ScheduleListView+.swift
//  Rlog
//
//  Created by 정지혁 on 2022/10/20.
//

import SwiftUI

extension ScheduleListView {
    struct StatusPicker: View {
        @ObservedObject private var viewModel: StatusPickerViewModel
        
        init(selectedScheduleCase: Binding<ScheduleCase>) {
            self.viewModel = StatusPickerViewModel(selectedScheduleCase: selectedScheduleCase)
        }
        
        var body: some View {
            GeometryReader { geometry in
                ZStack {
                    Rectangle()
                        .fill(.white)
                    Rectangle()
                        .fill(Color.primary)
                        .frame(width: 97)
                        .cornerRadius(20)
                        .offset(x: viewModel.statusPickerOffset)
                    HStack(spacing: 0) {
                        ForEach(viewModel.scheduleCases, id: \.self) { schedule in
                            ZStack {
                                Rectangle()
                                    .fill(.clear)
                                    .frame(width: 176 / 2)
                                Text(schedule.rawValue)
                                    .font(.caption2)
                                    .fontWeight(viewModel.getStatusPickerTextWeight(compareCase: schedule))
                                    .foregroundColor(viewModel.getStatusPickerForegroundColor(compareCase: schedule))
                                    .onTapGesture {
                                        withAnimation {
                                            viewModel.selectedScheduleCase = schedule
                                        }
                                    }
                            }
                        }
                    }
                }
                .cornerRadius(20)
            }
        }
    }
    
    struct ScheduleCell: View {
        @ObservedObject private var viewModel: ScheduleCellViewModel
        
        init(workDayEntity: WorkDayEntity, didDismiss: @escaping () -> Void) {
            self.viewModel = ScheduleCellViewModel(workDayEntity: workDayEntity) {
                didDismiss()
            }
        }
        
        var body: some View {
            VStack(spacing: 0) {
                cellHeader
                Spacer()
                HStack(alignment: .bottom, spacing: 0) {
                    cellContent
                    Spacer()
                    cellButton
                }
                .padding(EdgeInsets(top: 0, leading: 14, bottom: -2, trailing: 0))
            }
            .padding()
            .frame(height: 97)
            .background(
                backgroundRectangle
            )
        }
        
        var backgroundRectangle: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(viewModel.isShowConfirmButton ? Color(viewModel.workDayEntity.workspace.colorString) : .white)
                    .frame(height: 97)
                RoundedRectangle(cornerRadius: 9)
                    .fill(Color.white)
                    .padding(1)
            }
        }
        
        var cellHeader: some View {
            HStack(spacing: 0) {
                Rectangle()
                    .fill(Color(viewModel.workDayEntity.workspace.colorString))
                    .frame(width: 3, height: 17)
                Text(viewModel.workDayEntity.workspace.name)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundColor(Color.fontBlack)
                    .padding(.leading, 3)
                Spacer()
                Text("\(viewModel.workDay.spentHour)시간")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.fontBlack)
            }
            .padding(.horizontal, 4)
        }
        
        var cellContent: some View {
            VStack(alignment: .leading, spacing: 0) {
                // TODO: - 요일 처리
                Text("\(viewModel.workDay.monthInt)월 \(viewModel.workDay.dayInt)일 \(WeekDay(rawValue: viewModel.workDay.weekDay)?.name ?? "월")요일")
                    .font(.caption)
                    .foregroundColor(Color.fontBlack)
                Text("\(viewModel.workDay.startHour):\(viewModel.workDay.startMinute)-\(viewModel.workDay.endHour):\(viewModel.workDay.endMinute)")
                    .font(.caption2)
                    .foregroundColor(Color.fontLightGray)
            }
        }
        
        var cellButton: some View {
            HStack(spacing: 11) {
                Button(action: {
                    viewModel.didTapEditButton()
                }, label: {
                    Text("수정")
                        .font(.footnote)
                        .foregroundColor(Color.fontBlack)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            Color(UIColor.systemGray5)
                        )
                        .cornerRadius(10)
                })
                .sheet(isPresented: $viewModel.isShowUpdateModal, onDismiss: {
                    viewModel.didDismiss()
                }) {
                    NavigationView {
                        ScheduleUpdateView(workDayEntity: viewModel.workDayEntity)
                    }
                }
                if viewModel.isShowConfirmButton {
                    Button(action: {
                        viewModel.didTapConfirmButton()
                    }, label: {
                        Text("확인")
                            .font(.footnote)
                            .foregroundColor(Color.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(
                                Color(viewModel.workDayEntity.workspace.colorString)
                            )
                            .cornerRadius(10)
                    })
                }
            }
        }
    }
}
