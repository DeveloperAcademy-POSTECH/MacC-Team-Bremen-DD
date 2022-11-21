//
//  UnreadScheduleView.swift
//  Rlog
//
//  Created by Noah's Ark on 2022/11/14.
//

import SwiftUI

private struct MockModel: Hashable {
    let name = "팍이네 팍팍 감자탕"
    let date: String
}

struct SchedulePendingListView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var viewModel = SchedulePendingListViewModel()
    private let dateArray: [String] = ["11.14", "11.15", "11.20", "11.21"]
    private let mockData: [MockModel] = [
        MockModel(date: "11.14"),
        MockModel(date: "11.15"),
        MockModel(date: "11.20"),
        MockModel(date: "11.21"),
        MockModel(date: "11.51"),
        MockModel(date: "12.21"),
        MockModel(date: "11.20"),
        MockModel(date: "11.21"),
    ]
    
    private var sortedMockData: [(String, [MockModel])] {
        var sortedArray: [(String, [MockModel])] = []
        var scheduleArray: [MockModel] = []
        for date in dateArray {
            for schedule in mockData {
                if schedule.date == date {
                    scheduleArray.append(schedule)
                }
            }
            
            sortedArray.append((date, scheduleArray))
            scheduleArray.removeAll()
        }
        
        return sortedArray
    }
    
    var body: some View {
        ScrollView {
            dateContainer
        }
        .padding(.horizontal)
        .accentColor(.black)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }){
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
        ForEach(0..<sortedMockData.count, id: \.self) { index in
            VStack(alignment: .leading, spacing: 0) {
                if sortedMockData[index].1 != [] {
                    HStack(spacing: 0) {
                        Text(sortedMockData[index].0)
                            .font(.caption)
                            .foregroundColor(.grayMedium)
                        
                        Spacer()
                    }
                    
                    HDivider()
                        .padding(.bottom, 8)
                    
                    //TODO : 근무 카드 적용
                    ForEach(sortedMockData[index].1, id: \.self) { data in
                        VStack(alignment: .leading, spacing: 0) {
                            Text(data.name)
                            Text(data.date)
                        }
                        .padding()
                        .background(Color.backgroundCard)
                    }
                }
            }
            .padding(.bottom, 24)
        }
    }
}
