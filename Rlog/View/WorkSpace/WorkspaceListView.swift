//
//  WorkSpaceListView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI

struct WorkspaceListView: View {
    @StateObject private var viewModel = WorkspaceListViewModel()
    
    var body: some View {
        NavigationView {
            workspaceList
        }
    }
}

private extension WorkspaceListView {
    var workspaceList: some View {
        VStack(spacing: 0){
            HStack(){
                Text("근무지")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.fontBlack)
                
                Spacer()
                
                NavigationLink(
                    destination: WorkspaceCreateView(isActive: $viewModel.isShowingSheet),
                    isActive: $viewModel.isShowingSheet) {
                        
                        Image("plus.curved")
                            .foregroundColor(Color.primary)
                    }
            }
            .padding(EdgeInsets(top: 27, leading: 16, bottom: 24, trailing: 16))
            if viewModel.workspaces.isEmpty {
                emptyWorkspaceList
            } else {
                ScrollView {
                    ForEach(viewModel.workspaces, id: \.self) { workspace in
                        WorkspaceCell(workspace: workspace)
                    }
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
    
    var emptyWorkspaceList: some View {
        VStack(spacing: 0) {
            Spacer()
            Text("근무지를 등록해주세요")
                .font(Font.body.bold())
                .padding(.bottom, 8)
            
            NavigationLink(
                destination: WorkspaceCreateView(isActive: $viewModel.isShowingSheet),
                isActive: $viewModel.isShowingSheet) {
                    Text("근무지 등록하기")
                        .font(Font.subheadline.bold())
                        .foregroundColor(Color.primary)
                        .overlay {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color.primary)
                                .padding(.top)
                        }
                }
            Spacer()
        }
    }
}
