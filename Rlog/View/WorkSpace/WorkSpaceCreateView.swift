//
//  WorkSpaceCreateView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI


struct WorkSpaceCreateView: View {
    @ObservedObject var viewModel: WorkSpaceCreateViewModel
    init(isActive: Binding<Bool>) {
        self.viewModel = WorkSpaceCreateViewModel(isActive: isActive)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 0) {
                if !viewModel.isHiddenGuidingTitle {
                    guidingTitle
                }
                guidingText
            }
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
                        WorkSpaceCreateScheduleListView(isActive: $viewModel.isActive, workspaceModel: WorkSpaceModel(
                            name: viewModel.name,
                            paymentDay: viewModel.paymentDay,
                            hourlyWage: viewModel.hourlyWage,
                            hasTax: viewModel.hasTax,
                            hasJuhyu: viewModel.hasJuhyu
                        )
                        )
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
    // 타이틀
    var guidingTitle: some View {
        Text("새로운 아르바이트를 추가합니다.")
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.fontBlack)
            .padding(.top, 20)
    }
    var toggleInputs: some View {
        VStack(spacing: 10) {
            Toggle(isOn: $viewModel.hasTax, label: {
                HStack(alignment:.bottom) {
                    Text("소득세")
                    Text("3.3% 적용")
                        .font(.caption)
                        .foregroundColor(.fontLightGray)
                }
            })
            Toggle(isOn: $viewModel.hasJuhyu, label: {
                HStack(alignment:.bottom) {
                    Text("주휴수당")
                    Text("60시간 근무 시 적용")
                        .font(.caption)
                        .foregroundColor(.fontLightGray)
                }
            })
        }
    }
    // 가이드 텍스트
    var guidingText: some View {
        TitleSubView(title: viewModel.currentState.title)
    }
    
    // 확인 버튼
    var ConfirmButton: some View {
        // -------> TODO: 컨포넌트로 대체
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
        // <------- TODO: 컨포넌트로 대체
    }
}
