//
//  WorkSpaceListView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI

struct WorkSpaceListView: View {
    @StateObject private var viewModel = WorkspaceListViewModel()
    
    var body: some View {
        NavigationView {
            workspaceList
        }
    }
}

private extension WorkSpaceListView {
    var workspaceList: some View {
        ScrollView(showsIndicators: false) {
            ForEach(viewModel.workspaces, id: \.self) { workspace in
                WorkspaceCell(workspace: workspace)
            }
        }
        .padding(.top, 24)
        .accentColor(.fontBlack)
        .background(Color.backgroundWhite)
        .onAppear { viewModel.onAppear() }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("근무지")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.fontBlack)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(
                    destination: WorkspaceCreateView(isActive: $viewModel.isShowingSheet),
                    isActive: $viewModel.isShowingSheet) {
                    Image("plus.curved")
                        .foregroundColor(Color.primary)
                }
            }
        }
    }
}
