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
