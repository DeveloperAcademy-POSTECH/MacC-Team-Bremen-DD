//
//  UnreadScheduleView.swift
//  Rlog
//
//  Created by Noah's Ark on 2022/11/14.
//
// isChecked (false) -> re-sorted by workdate
// load current month and its date -> sort given schedules by dates
// it's not gonna be a heavy thing even O(n) would be used

import SwiftUI

private struct MockModel: Hashable {
    let name = "팍이네 팍팍 감자탕"
    let date: String

//    let endTime: Date
//    let hasDone: Bool = false
}

struct SchedulePendingListView: View {
    @ObservedObject var viewModel = SchedulePendingListViewModel()
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
    }
}

private extension SchedulePendingListView {
    var dateContainer: some View {
        ForEach(0..<sortedMockData.count, id: \.self) { songcool in
            VStack(alignment: .leading) {
                if sortedMockData[songcool].1 != [] {
                    HStack {
                        Text(sortedMockData[songcool].0)
                            .font(.caption)
                            .foregroundColor(.grayLight)
                        Spacer()
                    }
                    HDivider()
                    ForEach(sortedMockData[songcool].1, id: \.self) { data in
                        VStack(alignment: .leading) {
                            Text(data.name)
                            Text(data.date)
                        }
                        .padding()
                        .background(Color.backgroundCard)
                    }
                }
            }
            .padding(.bottom)
        }
    }
}
