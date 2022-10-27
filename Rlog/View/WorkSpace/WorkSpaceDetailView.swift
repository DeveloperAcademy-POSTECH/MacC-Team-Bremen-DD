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

    init(workspace: WorkspaceEntity, schedules: [ScheduleEntity]) {
        viewModel = WorkSpaceDetailViewModel(workspace: workspace, schedules: schedules)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                InputFormElement(containerType: .workplace, text: $viewModel.name)
                    .padding(.top, 33)
                InputFormElement(containerType: .wage, text: $viewModel.hourlyWageString)
                InputFormElement(containerType: .payday, text: $viewModel.paymentDayString)

                makePaymentSystemToggle()

                Text("근무일정")
                    .font(.subheadline)
                    .foregroundColor(.fontLightGray)
                ForEach(viewModel.schedules) { schedule in
                    schedulesContainer(schedule: schedule)
                }
                
                StrokeButton(label: "+ 근무 일정 추가하기", buttonType: .add) {
                }
                
                HDivider()
                
                StrokeButton(label: "근무지 삭제하기", buttonType: .destructive) {
                    viewModel.didTapDeleteButton() {
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: Notification.disMiss, object: nil, userInfo: ["info": "dismiss"])
                            dismiss()
                        }
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationTitle("근무수정")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    NotificationCenter.default.post(name: Notification.disMiss, object: nil, userInfo: ["info": "dismiss"])
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
                    viewModel.didTapCompleteButton {
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: Notification.disMiss, object: nil, userInfo: ["info": "dismiss"])
                            dismiss()
                        }
                    }
                }){
                    Text("완료")
                        .fontWeight(.bold)
                }
            }
        }
        .background(Color.cardBackground)
        .navigationBarBackButtonHidden()
    }
}

private extension WorkSpaceDetailView {
    @ViewBuilder
    func makePaymentSystemToggle() -> some View {
        ForEach(WorkSpaceDetailInfo.allCases, id: \.self) { tab in
            Toggle(isOn: tab == .hasTax ? $viewModel.hasTax : $viewModel.hasJuhyu, label: {
                HStack(spacing: 13) {
                    Text(tab.text.title)
                        .font(.subheadline)
                        .foregroundColor(.fontLightGray)
                    Text(tab.text.description)
                        .font(.caption)
                        .foregroundColor(.fontLightGray)
                }
            })
        }
    }

    @ViewBuilder
    func schedulesContainer(schedule: ScheduleEntity) -> some View {
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(schedule.repeatedSchedule, id:\.self) { weekDay in
                    Text(weekDay)
                        .font(.body)
                        .foregroundColor(.fontBlack)
                        .padding(.horizontal, 1)
                }
            }
            .padding(.trailing, 3)
            Spacer()
            Text("\(schedule.startHour):\(schedule.startMinute)0 - \(schedule.endHour):\(schedule.endMinute)0")
                .font(.body)
                .foregroundColor(.fontBlack)
            Button {
                viewModel.didTapScheduleDeleteButton(schedule: schedule)
            } label: {
                Image(systemName: "minus.circle")
                    .foregroundColor(.red)
                    .padding(.leading, 16)
            }
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 54)
        .background(Color.containerBackground)
        .cornerRadius(10)
    }
}


