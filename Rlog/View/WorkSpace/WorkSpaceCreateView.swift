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
            
            // TODO: 컨포넌트로 대체
            if !viewModel.isHiddenPayday {
                VStack(alignment: .leading, spacing: 20)  {
                    Text("정산일")
                    TextField("10", text: $viewModel.payday)
                }
            }
            if !viewModel.isHiddenHourlyWage {
                VStack(alignment: .leading, spacing: 20)  {
                    Text("시급")
                    TextField("최저시급 9,160원", text: $viewModel.hourlyWage)
                }
            }
            VStack(alignment: .leading, spacing: 20)  {
                Text("근무지")
                TextField("예시) 편의점", text: $viewModel.workSpaceName)
            }
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
                    NavigationLink(
                        destination: WorkSpaceCreateScheduleListView(isActive: $viewModel.isActive)) {
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
            Toggle(isOn: $viewModel.isOnIncomeTax, label: {
                HStack(alignment:.bottom) {
                    Text("소득세")
                    Text("3.3% 적용")
                        .font(.caption)
                        .foregroundColor(.fontLightGray)
                }
            })
            Toggle(isOn: $viewModel.isOnHolidayAllowance, label: {
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
        Button {
            print(viewModel.currentState.rawValue)
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
