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
        self.viewModel = WorkSpaceCreateViewModel(isActiveNavigation: isActive)
    }
    
    @FocusState var checkoutInFocus: WritingState?
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            guidingText
            if !viewModel.isHiddenToggleInputs {
                toggleInputs
            }
            if !viewModel.isHiddenPayday {
                InputFormElement(containerType: .payday, text: $viewModel.payday)
                    .focused($checkoutInFocus, equals: .payday)
            }
            if !viewModel.isHiddenHourlyWage {
                InputFormElement(containerType: .wage, text: $viewModel.hourlyWage)
                    .focused($checkoutInFocus, equals: .hourlyWage)
            }
            InputFormElement(containerType: .workplace, text: $viewModel.workSpace)
                .focused($checkoutInFocus, equals: .workSpace)

            Spacer()

            if !viewModel.isHiddenConfirmButton {
                ConfirmButton
            }
        }
        .padding(.horizontal)
        .navigationBarTitle("근무지 등록")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                if !viewModel.isHiddenToolBarItem {
                    nextButton
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

private extension WorkSpaceCreateView {
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
    
    var nextButton: some View {
        NavigationLink {
            WorkSpaceCreateScheduleListView(
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
    
    // 가이드 텍스트
    var guidingText: some View {
        TitleSubView(title: viewModel.currentState.title)
    }
    
    var toggleInputs: some View {
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

    // 확인 버튼
    var ConfirmButton: some View {
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
