//
//  WorkSpaceCreateConfirmationView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/19.
//
// TODO: 네비게이션 연결, 뷰모델 연결, 고민 공유, 컨포넌트 적용
import SwiftUI

struct WorkSpaceCreateConfirmationView: View {
    @ObservedObject private var viewModel: WorkSpaceCreateConfirmationViewModel
    
    
    init(isActive: Binding<Bool>, workspaceData: CreatingWorkSpaceModel, scheduleData: [CreatingScheduleModel]) {
        self.viewModel = WorkSpaceCreateConfirmationViewModel(isActive: isActive, workspaceData: workspaceData, scheduleData: scheduleData)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            TitleSubView(title: "새로운 아르바이트를 추가합니다.")
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    WorkSpaceInfoSubView(labelName:"근무지", content: viewModel.workspaceData.name)
                    WorkSpaceInfoSubView(labelName:"시급", content: viewModel.workspaceData.hourlyWage)
                    WorkSpaceInfoSubView(labelName:"급여일", content:"매월 \(viewModel.workspaceData.paymentDay)일")
                    WorkSpaceInfoSubView(labelName:"소득세", content:viewModel.workspaceData.hasTax ? "3.3% 적용" : "미적용")
                    WorkSpaceInfoSubView(labelName:"주휴수당", content:viewModel.workspaceData.hasJuhyu ? "60시간 근무 시 적용" : "미적용")
                    WorkTypeInfo
                    Spacer()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                toolbarConfirmButton
            }
        }
        .padding(.horizontal)
    }
}

private extension WorkSpaceCreateConfirmationView {
//    @ViewBuilder
//    func WorkTypeInfo(for worktype: String) -> some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text("근무 유형")
//                .font(.caption)
//                .foregroundColor(.fontLightGray)
//            // TODO: 컨포넌트에 일하는 유형을 넣어준다.
//            RoundedRectangle(cornerRadius: 10)
//                .frame(height: 54)
//        }
//    }
    var WorkTypeInfo: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("근무 유형")
                .font(.caption)
                .foregroundColor(.fontLightGray)
            // TODO: 컨포넌트에 일하는 유형을 넣어준다.
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 54)
        }
    }
    var toolbarConfirmButton: some View {
            Button{
                viewModel.didTapConfirmButton()
            } label: {
                Text("완료")
            }
        }
}
