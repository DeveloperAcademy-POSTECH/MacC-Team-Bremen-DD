//
//  WorkSpaceCreateView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//
import SwiftUI


struct WorkspaceCreateView: View {
    @ObservedObject var viewModel: WorkspaceCreateViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState var checkoutInFocus: WritingState?
    
    init(isActive: Binding<Bool>) {
        self.viewModel = WorkspaceCreateViewModel(isActiveNavigation: isActive)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            guidingText
            toggle
            payday
            hourlyWage
            workspace
            Spacer()
            confirmationButton
        }
        .padding(.horizontal)
        .navigationBarTitle("근무지 등록")
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton { dismiss() }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                if !viewModel.isHiddenToolBarItem {
                    NavigationLink {
                        WorkspaceCreateScheduleListView(
                            isActiveNavigation: $viewModel.isActiveNavigation, workspaceModel: WorkSpaceModel(
                                name: viewModel.workSpace,
                                paymentDay: viewModel.payday,
                                hourlyWage: viewModel.hourlyWage,
                                hasTax: viewModel.hasTax,
                                hasJuhyu: viewModel.hasJuhyu
                            )
                        )
                    } label: {
                        Text("다음")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .onAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
              self.checkoutInFocus = .workSpace
          }
        }
    }
}

private extension WorkspaceCreateView {
    // 가이드 텍스트
    var guidingText: some View {
        TitleSubView(title: viewModel.currentState.title)
    }
    
    @ViewBuilder
    var toggle: some View {
        if !viewModel.isHiddenToggleInputs {
            VStack(spacing: 24) {
                Toggle(isOn: $viewModel.hasTax, label: {
                    HStack {
                        Text("소득세")
                        Text("3.3% 적용")
                            .font(.caption)
                    }
                    .foregroundColor(.grayMedium)
                })
                Toggle(isOn: $viewModel.hasJuhyu, label: {
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
    
    @ViewBuilder
    var payday: some View {
        if !viewModel.isHiddenPayday {
            InputFormElement(containerType: .payday, text: $viewModel.payday)
                .focused($checkoutInFocus, equals: .payday)
        }
    }
    
    @ViewBuilder
    var hourlyWage: some View {
        if !viewModel.isHiddenHourlyWage {
            InputFormElement(containerType: .wage, text: $viewModel.hourlyWage)
                .focused($checkoutInFocus, equals: .hourlyWage)
        }
    }
    
    var workspace: some View {
        InputFormElement(containerType: .workplace, text: $viewModel.workSpace)
            .focused($checkoutInFocus, equals: .workSpace)
            .onSubmit {
                viewModel.didTapConfirmButton()
            }
    }
    
    @ViewBuilder
    var confirmationButton: some View {
        if !viewModel.isHiddenConfirmButton {
            Button {
                viewModel.didTapConfirmButton()
                switch checkoutInFocus {
                case .none:
                    break
                case .some(.workSpace):
                    checkoutInFocus = .hourlyWage
                    break
                case .some(.hourlyWage):
                    checkoutInFocus = .payday
                    break
                case .some(.payday):
                    checkoutInFocus = nil
                    break
                case .some(.toggleOptions):
                    print("잘못된 입력")
                    break
                }
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
}
