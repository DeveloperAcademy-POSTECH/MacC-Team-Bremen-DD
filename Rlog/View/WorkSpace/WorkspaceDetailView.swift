//
//  WorkspaceDetailView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//
import SwiftUI

// TODO: 완료 Button isActive 기능 추가하기
// TODO: 근무지 삭제 Alert 구현
// TODO: Schedule 추가하기
struct WorkspaceDetailView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: WorkspaceDetailViewModel
    
    init(workspace: WorkspaceEntity) {
        viewModel = WorkspaceDetailViewModel(workspace: workspace)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                InputFormElement(containerType: .workplace, text: $viewModel.name)
                InputFormElement(containerType: .wage, text: $viewModel.hourlyWageString)
                InputFormElement(containerType: .payday, text: $viewModel.paymentDayString)
                paymentSystemToggle
                schedules
                addScheduleButton
                HDivider()
                deleteScheduleButton
            }
            .padding(EdgeInsets(top: 24, leading: 16, bottom: 0, trailing: 16))
        }
        .navigationBarTitle (Text("근무수정"), displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton { dismiss() }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.didTapConfirmButton {
                        dismiss()
                    }
                }){
                    Text("완료")
                        .fontWeight(.bold)
                        .foregroundColor(Color.primary)
                }
            }
        }
        .sheet(isPresented: $viewModel.isCreateScheduleModalShow, onDismiss: {
            print("1")
        }) {
            WorkspaceCreateCreatingScheduleView(isShowingModal: $viewModel.isCreateScheduleModalShow, scheduleList: $viewModel.shouldCreateSchedules)
        }
        .background(Color.backgroundWhite)
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $viewModel.isCreateScheduleModalShow) {
            WorkspaceCreateCreatingScheduleView(
                isShowingModal: $viewModel.isCreateScheduleModalShow,
                scheduleList: $viewModel.shouldCreateSchedules
            )
        }
    }
}

private extension WorkspaceDetailView {
    @ViewBuilder
    var paymentSystemToggle: some View {
        ForEach(WorkspaceDetailInfo.allCases, id: \.self) { tab in
            Toggle(isOn: tab == .hasTax ? $viewModel.hasTax : $viewModel.hasJuhyu, label: {
                HStack(spacing: 13) {
                    Text(tab.text.title)
                        .font(.body)
                        .foregroundColor(.grayMedium)
                    Text(tab.text.description)
                        .font(.caption)
                        .foregroundColor(.grayMedium)
                }
            })
        }
    }

    var schedules: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("근무패턴")
                .font(.caption)
                .foregroundColor(.grayMedium)
                .padding(.bottom, -16)
            
            ForEach(viewModel.schedules, id: \.self) { schedule in
                ScheduleContainer(
                    repeatedSchedule: schedule.repeatDays,
                    startHour: Int16(schedule.startHour),
                    startMinute: Int16(schedule.startMinute),
                    endHour: Int16(schedule.endHour),
                    endMinute: Int16(schedule.endMinute)
                ) {
                    viewModel.didTapDeleteScheduleButton(schedule: schedule)
                }
            }
            
            ForEach(viewModel.shouldCreateSchedules, id: \.self) { schedule in
                ScheduleContainer(
                    repeatedSchedule: schedule.repeatedSchedule,
                    startHour: schedule.startHour,
                    startMinute: schedule.startMinute,
                    endHour: schedule.endHour,
                    endMinute: schedule.endMinute
                ) {
                    viewModel.didTapDeleteScheduleModelButton(schedule: schedule)
                }
            }
        }
        .padding(.bottom, -8)
    }
    
    var addScheduleButton: some View {
        StrokeButton(label: "+ 근무패턴 추가", buttonType: .add) {
            viewModel.isCreateScheduleModalShow.toggle()
        }
        .padding(.bottom, -8)
    }
    
    var deleteScheduleButton: some View {
        HStack(alignment: .center) {
            Spacer()
            StrokeButton(label: "근무지 삭제", buttonType: .destructive) {
                viewModel.isAlertOpen.toggle()
            }
            .alert("근무지 삭제", isPresented: $viewModel.isAlertOpen) {
                Button("취소", role: .cancel) {
                    viewModel.isAlertOpen.toggle()
                }
                Button("삭제", role: .destructive) {
                    viewModel.didTapDeleteButton {
                        dismiss()
                    }
                }
            } message: {
                Text("해당 근무지를 삭제합니다.")
            }
            .padding(.top, -8)
            Spacer()
        }
    }
}

fileprivate enum WorkspaceDetailInfo: CaseIterable {
    case hasTax
    case hasJuhyu
    
    var text: (title: String, description: String) {
        switch self {
        case .hasTax: return (title: "소득세", description: "3.3% 적용")
        case .hasJuhyu: return (title: "주휴수당", description: "60시간 근무 시 적용")
        }
    }
}
