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
    var action: () -> Void

    init(workspace: WorkspaceEntity, action: @escaping () -> Void) {
        viewModel = WorkSpaceDetailViewModel(workspace: workspace)
        self.action = action
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            //TODO : Rectangle 자리 공용 컴포넌트 삽입
            InputFormElement(containerType: .workplace, text: $viewModel.name)
//            InputFormElement(containerType: .wage, text: $viewModel.hourlyWage)
//            InputFormElement(containerType: .payday, text: $viewModel.paymentDay)

            makePaymentSystemToggle()
            
                Text("근무일정")
                    .font(.subheadline)
                    .foregroundColor(.fontLightGray)
                Spacer()

            
            Rectangle() //근무유형
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, maxHeight: 54)
            Rectangle() //일정추가 버튼
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, maxHeight: 54)
            StrokeButton(label: "+ 근무 일정 추가하기", buttonType: .add) {

            }
            HDivider()
            StrokeButton(label: "근무지 삭제하기", buttonType: .destructive) {
                viewModel.didTapDeleteButton() {
                    dismiss()
                    action()
                }
            }
            Spacer()
        }
        .navigationTitle("근무수정") 
        .padding(.horizontal)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                    action()
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
                        dismiss()
                        action()
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
}


