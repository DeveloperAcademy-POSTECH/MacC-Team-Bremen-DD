//
//  WorkSpaceListView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI

enum WorkSpaceInfo: CaseIterable {
    case hourlyWage
    case paymentDay
    case hasJuhyu
    case hasTax
    case workDays

    var text: String {
        switch self {
        case .hourlyWage: return "시급"
        case .paymentDay: return "급여일"
        case .hasJuhyu: return "주휴수당"
        case .hasTax: return "소득세"
        case .workDays: return "근무 유형"
        }
    }
}


struct WorkSpaceListView: View {
    @StateObject var viewModel = WorkSpaceListViewModel()
    
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                ForEach(viewModel.workspaces, id: \.self) { workspace in
                    WorkSpaceCell(workspace: workspace)
                }
                Text("")
            }
            .padding(.top, 24)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    Text("근무지")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.fontBlack)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    NavigationLink(
                        destination: WorkSpaceCreateView(isActive: $viewModel.isShowingSheet),
                        isActive: $viewModel.isShowingSheet) {
                        //TODO : SF심블이 아니므로 별도 PR에 assets 추가 후 적용 예정
                        Image("plus.curved")
                            .foregroundColor(Color.primary)
                    }
                }
            }
            .background(Color.backgroundWhite)
            .onAppear {
                viewModel.onAppear()
            }
        }
        .accentColor(.fontBlack)
    }
}
