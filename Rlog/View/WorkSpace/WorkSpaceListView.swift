//
//  WorkSpaceListView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI


struct WorkSpaceListView: View {

    @ObservedObject var viewModel = WorkSpaceListViewModel()
    
    var body: some View {
        //  Navgation Header 리팩토링 고려 코드 https://stackoverflow.com/questions/57517803/how-to-remove-the-default-navigation-bar-space-in-swiftui-navigationview
        NavigationView {
            ScrollView {
                ForEach(viewModel.workspaces, id: \.self) { workspace in
                    makeWorkspaceCell(workspace: workspace)
                }
            }
            .padding(.top, 32)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("근무지")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.didTapPlusButton() }){
                        Image(systemName: "plus")
                            .fontWeight(.bold)
                    }
                }
            }
            .background(Color.cardBackground)
            .sheet(isPresented: $viewModel.isShowingSheet) {
                Text("Hello")
            }
        }
    }
}

extension WorkSpaceListView {

    @ViewBuilder
    func makeWorkspaceCell(workspace: WorkspaceEntity) -> some View {
        NavigationLink(
            destination: {
                WorkSpaceDetailView(workspace: workspace) {
                    viewModel.didDismissed()
                }
            },
            label: { makeWorkSpaceCardContent(workspace: workspace) }
        )
    }

    @ViewBuilder
    func makeWorkSpaceCardHeader(workTitle: String, workTagColor: String) -> some View {
        HStack(alignment: .center){
            Rectangle()
                .foregroundColor(Color(workTagColor))
                .frame(width: 3, height: 17)
            Text(workTitle)
                .font(.callout)
                .fontWeight(.bold)
                .foregroundColor(.fontBlack)
        }.padding(.bottom, 20)
    }

    @ViewBuilder
    func makeWorkSpaceCardContent(workspace: WorkspaceEntity) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            makeWorkSpaceCardHeader(workTitle: workspace.name, workTagColor: workspace.colorString)

            VStack(spacing: 8){
                ForEach(WorkSpaceInfo.allCases, id: \.self) { tab in
                    HStack() {
                        Text(tab.text)
                            .font(.subheadline)
                            .foregroundColor(.fontLightGray)
                        Spacer()
//                        Text( model.getValue(info: tab))
//                            .font(.subheadline)
//                            .foregroundColor(.fontBlack)
                    }
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10)
            .fill(Color.background))
        .padding([.horizontal, .bottom])
    }

}

// TODO: CoreData의 Model로 변경
struct CustomModel: Hashable {
    let name: String
    let hourlyWage: Int
    let date: String
    var hasJuhyu: Bool
    var hasTax: Bool
    let color: String
    let workDays: String
    let schedules: String
    
    // TODO: CoreData model에도 추가해야함.
    func getValue(info: WorkSpaceInfo) -> String {
        switch info {
        case .hourlyWage: return "\(hourlyWage)"
        case .paymentDay: return date
        case .hasJuhyu:
            return hasJuhyu ? "적용" : "미적용"
        case .hasTax:
            return hasTax ? "적용" : "미적용"
        case .workDays: return "\(workDays + " " + schedules)"
        }
    }
    
    // TODO: TODO: CoreData model에도 추가해야함. 공용 컴포넌트 연결시 case 추가해야함.
    func getDetailValue(info: WorkSpaceDetailInfo) -> Bool {
        switch info {
        case .hasTax:
            return hasTax
        case .hasJuhyu:
            return hasJuhyu
        }
    }
}
