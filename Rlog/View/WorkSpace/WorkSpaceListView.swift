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
                    WorkSpaceCell(workspace: workspace)
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
        .onReceive(
            NotificationCenter.default.publisher(for: NSNotification.disMiss)
        ) {
            obj in
            viewModel.didRecieveNotification()
        }

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
