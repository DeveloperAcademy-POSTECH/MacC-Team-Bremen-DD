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
    @StateObject private var viewModel = WorkSpaceListViewModel()
    
    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 0){
                HStack(){
                    Text("근무지")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.fontBlack)
                    
                    Spacer()
                    
                    NavigationLink(
                        destination: WorkSpaceCreateView(isActive: $viewModel.isShowingSheet),
                        isActive: $viewModel.isShowingSheet) {
                            
                        Image("plus.curved")
                            .foregroundColor(Color.primary)
                    }
                }
                .padding(EdgeInsets(top: 27, leading: 16, bottom: 24, trailing: 16))
                
                ScrollView {
                    ForEach(viewModel.workspaces, id: \.self) { workspace in
                        WorkSpaceCell(workspace: workspace)
                    }
                }
            }
            .navigationBarTitle("", displayMode: .automatic)
            .navigationBarHidden(true)
            .background(Color.backgroundWhite)
            .onAppear {
                viewModel.onAppear()
            }
        }
        .accentColor(.fontBlack)
    }
}
