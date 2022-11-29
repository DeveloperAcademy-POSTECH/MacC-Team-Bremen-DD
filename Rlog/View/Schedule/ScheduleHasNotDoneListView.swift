//
//  UnreadScheduleView.swift
//  Rlog
//
//  Created by Noah's Ark on 2022/11/14.
//

import SwiftUI

struct ScheduleHasNotDoneListView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var viewModel = ScheduleHasNotDoneListViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.hasNotDoneWorkdays.isEmpty {
                emptyHasNotDoneList
            } else {
                ScrollView {
                    hasNotDoneList
                }
                .padding(.horizontal)
                .accentColor(.black)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle ("미확정 일정", displayMode: .inline)
        .onAppear { viewModel.onAppear() }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton { dismiss() }
            }
        }
    }
}

private extension ScheduleHasNotDoneListView {
    var hasNotDoneList: some View {
        ForEach(0..<viewModel.sortedHasNotDoneWorkdays.count, id: \.self) { index in
            VStack(alignment: .leading, spacing: 0) {
                if !viewModel.sortedHasNotDoneWorkdays[index].1.isEmpty {
                    HStack(spacing: 0) {
                        Text("\(viewModel.sortedHasNotDoneWorkdays[index].0.monthInt)월 \(viewModel.sortedHasNotDoneWorkdays[index].0.dayInt)일")
                            .font(.caption)
                            .foregroundColor(.grayMedium)
                        Spacer()
                    }
                    HDivider()
                        .padding(.bottom, 8)
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(viewModel.sortedHasNotDoneWorkdays[index].1, id: \.self) { data in
                            ScheduleCell(of: data) {
                                viewModel.onAppear()
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 24)
        }
        .padding(.top, 22)
    }
    
    var emptyHasNotDoneList: some View {
        VStack(spacing: 0) {
            Spacer()
            Image("rlogGreenLogo")
            Text("모든 근무를 확인했어요.")
                .padding(.top, 24)
                .padding(.bottom, 100)
            Spacer()
        }
        .font(Font.body.bold())
    }
}
