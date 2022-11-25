//
//  WorkSpaceCreateConfirmationView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/19.
//
// TODO: 네비게이션 연결, 뷰모델 연결, 고민 공유, 컨포넌트 적용
import SwiftUI

struct WorkspaceCreateConfirmationView: View {
    @ObservedObject private var viewModel: WorkspaceCreateConfirmationViewModel
    
    @Environment(\.dismiss) var dismiss
    
    init(isActiveNavigation: Binding<Bool>, workspaceData: WorkSpaceModel, scheduleData: [ScheduleModel]) {
        self.viewModel = WorkspaceCreateConfirmationViewModel(
            isActiveNavigation: isActiveNavigation,
            workspaceData: workspaceData,
            scheduleData: scheduleData
        )
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                TitleSubView(title: "새로운 아르바이트를 추가합니다.")
                InputFormElement(containerType: .workplace, text: $viewModel.workspaceData.name)
                InputFormElement(containerType: .wage, text: $viewModel.workspaceData.hourlyWage)
                InputFormElement(containerType: .payday, text: $viewModel.workspaceData.paymentDay)
                toggleInputs
                workTypeInfo
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationBarTitle("근무지 등록")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                toolbarConfirmButton
            }
        }
    }
}

private extension WorkspaceCreateConfirmationView {
    var backButton: some View {
        Button(action: {
            dismiss()
        }, label: {
            HStack(spacing: 5) {
                Image(systemName: "chevron.backward")
                Text("이전")
            }
            .foregroundColor(Color.fontBlack)
        })
    }
    
    var workTypeInfo: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("근무 패턴")
                .font(.caption)
                .foregroundColor(.grayMedium)
            
            VStack(spacing: 16) {
                ForEach(viewModel.scheduleData, id: \.self) { schedule in
                    ScheduleContainer(
                        repeatedSchedule: schedule.repeatedSchedule,
                        startHour: Int16(schedule.startHour),
                        startMinute: Int16(schedule.startMinute),
                        endHour: Int16(schedule.endHour),
                        endMinute: Int16(schedule.endMinute)
                    )
                }
            }
        }
    }
    var toolbarConfirmButton: some View {
        Button{
            viewModel.didTapConfirmButton()
        } label: {
            Text("완료")
                .foregroundColor(.primary)
        }
    }
    var toggleInputs: some View {
        VStack(spacing: 24) {
            Toggle(isOn: $viewModel.workspaceData.hasTax, label: {
                HStack {
                    Text("소득세")
                    Text("3.3% 적용")
                        .font(.caption)
                }
                .foregroundColor(.grayMedium)
            })
            Toggle(isOn: $viewModel.workspaceData.hasJuhyu, label: {
                HStack {
                    Text("주휴수당")
                    Text("60시간 근무 시 적용")
                        .font(.caption)
                }
                .foregroundColor(.grayMedium)
                
            })
        }
    }
}
