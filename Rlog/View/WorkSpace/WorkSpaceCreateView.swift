//
//  WorkSpaceCreateView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI


struct WorkSpaceCreateView: View {
    @ObservedObject var viewModel: WorkSpaceCreateViewModel
    init() {
        self.viewModel = WorkSpaceCreateViewModel()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            guidingText
            if !viewModel.isHiddenToggleInputs {
                toggleInputs
            }
            if !viewModel.isHiddenPayday {
                InputFormElement(containerType: .payday, text: $viewModel.paymentDay)
            }
            if !viewModel.isHiddenHourlyWage {
                InputFormElement(containerType: .wage, text: $viewModel.hourlyWage)
            }
            InputFormElement(containerType: .workplace, text: $viewModel.name)

            Spacer()

            if !viewModel.isHiddenConfirmButton {
                ConfirmButton
            }
        }
        .padding(.horizontal)
        .navigationBarTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if !viewModel.isHiddenToolBarItem {
                    NavigationLink {
                        WorkSpaceCreateScheduleListView()
                    } label: {
                        Text("다음")
                            .foregroundColor(.fontBlack)
                    }
                }
            }
        }
    }
}

private extension WorkSpaceCreateView {
    // 가이드 텍스트
    var guidingText: some View {
        Text("")
//        TitleSubView(title: viewModel.currentState.title)
    }
    
    var toggleInputs: some View {
        VStack(spacing: 10) {
            Toggle(isOn: $viewModel.hasTax, label: {
                HStack(alignment:.bottom) {
                    Text("소득세")
                    Text("3.3% 적용")
                        .font(.caption)
                        .foregroundColor(.grayLight)
                }
            })
            Toggle(isOn: $viewModel.hasJuhyu, label: {
                HStack(alignment:.bottom) {
                    Text("주휴수당")
                    Text("60시간 근무 시 적용")
                        .font(.caption)
                        .foregroundColor(.grayLight)
                }
            })
        }
    }

    
    // 확인 버튼
    var ConfirmButton: some View {
        Button {
            viewModel.didTapConfirmButton()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(viewModel.isActivatedConfirmButton ? .green : .gray)
                    .frame(height: 58)
                Text("확인")
                    .foregroundColor(.white)
            }
            .padding(.bottom, 20)
        }
    }
}
