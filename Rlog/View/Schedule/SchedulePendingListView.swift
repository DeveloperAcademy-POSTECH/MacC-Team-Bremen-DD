//
//  UnreadScheduleView.swift
//  Rlog
//
//  Created by Noah's Ark on 2022/11/14.
//

import SwiftUI

struct SchedulePendingListView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var viewModel = SchedulePendingListViewModel()
    
    var body: some View {
        ScrollView {
            dateContainer
        }
        .padding(.horizontal)
        .accentColor(.black)
        .onAppear { viewModel.onAppear() }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.fontBlack)
                    Text("이전")
                        .foregroundColor(.fontBlack)
                }
            }
        }
    }
}

private extension SchedulePendingListView {
    var dateContainer: some View {
        ForEach(0..<viewModel.sortedHasNotDoneWorkdays.count, id: \.self) { index in
            VStack(alignment: .leading, spacing: 0) {
                if !viewModel.sortedHasNotDoneWorkdays[index].1.isEmpty {
                    HStack(spacing: 0) {
                        Text("\(viewModel.sortedHasNotDoneWorkdays[index].0.fetchMonthAndDay())")
                            .font(.caption)
                            .foregroundColor(.grayMedium)
                        Spacer()
                    }
                    HDivider()
                        .padding(.bottom, 8)
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(viewModel.sortedHasNotDoneWorkdays[index].1, id: \.self) { data in
                            ScheduleCell(currentDate: Date(), data: data)
                        }
                    }
                }
            }
            .padding(.bottom, 24)
        }
        .padding(.top, 22)
    }
}
