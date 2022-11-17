//
//  WorkSpaceDetailView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI

// TODO: 완료 Button isActive 기능 추가하기
// TODO: 근무지 삭제 Alert 구현
// TODO: Schedule 추가하기

enum WorkSpaceDetailInfo: CaseIterable {
    case hasTax
    case hasJuhyu
    
    var text: (title: String, description: String) {
        switch self {
        case .hasTax: return (title: "소득세", description: "3.3% 적용")
        case .hasJuhyu: return (title: "주휴수당", description: "60시간 근무 시 적용")
        }
    }
}

struct WorkSpaceDetailView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: WorkSpaceDetailViewModel
    
    init(workspace: WorkspaceEntity) {
        viewModel = WorkSpaceDetailViewModel(workspace: workspace)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                InputFormElement(containerType: .workplace, text: $viewModel.name)
                InputFormElement(containerType: .wage, text: $viewModel.hourlyWageString)
                InputFormElement(containerType: .payday, text: $viewModel.paymentDayString)
                makePaymentSystemToggle()
                
                Text("근무패턴")
                    .font(.caption)
                    .foregroundColor(.grayMedium)
                    .padding(.bottom, -16)
                
                ForEach(viewModel.schedules, id: \.self) { schedule in
                    ScheduleContainer(
                        repeatedSchedule: schedule.repeatDays,
                        startHour: String(schedule.startHour),
                        startMinute: String(schedule.startMinute),
                        endHour: String(schedule.endHour),
                        endMinute: String(schedule.endMinute)
                    )
                }
                .padding(.bottom, -8)
                
                StrokeButton(label: "+ 근무패턴 추가", buttonType: .add) {
                    viewModel.isCreateScheduleModalShow.toggle()
                }
                .padding(.bottom, -8)
                
                HDivider()
                
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
                    Text("해당 근무지를 삭제합니다.?")
                }
                .padding(.top, -8)
                
                Spacer()
            }
            .padding(EdgeInsets(top: 24, leading: 16, bottom: 0, trailing: 16))
        }
        .navigationTitle("근무수정")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }){
                    Image(systemName: "chevron.left")
                        .foregroundColor(.fontBlack)
                    Text("이전")
                        .foregroundColor(.fontBlack)
                }
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
        .sheet(isPresented: $viewModel.isCreateScheduleModalShow) {
            Text("근무 패턴 생성")
        }
        .background(Color.backgroundWhite)
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.onAppear()
        }
    }
}

private extension WorkSpaceDetailView {
    @ViewBuilder
    func makePaymentSystemToggle() -> some View {
        ForEach(WorkSpaceDetailInfo.allCases, id: \.self) { tab in
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
}


