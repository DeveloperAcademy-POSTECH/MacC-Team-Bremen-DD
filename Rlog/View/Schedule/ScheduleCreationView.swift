//
//  ScheduleCreationView.swift
//  Rlog
//
//  Created by Noah's Ark on 2022/11/14.
//

import SwiftUI

struct ScheduleCreationView: View {
    @ObservedObject var viewModel = ScheduleCreationViewModel()
    @State private var date = Date()
    @State private var date2 = Date()
    @State private var date3 = Date()
    
    var body: some View {
        ZStack {
            VStack {
                BorderedPicker(date: $date, type: .date, isFocused: $viewModel.isFocused)
                BorderedPicker(date: $date2, type: .time, isFocused: $viewModel.isFocused)
                BorderedPicker(date: $date3, type: .time, isFocused: $viewModel.isFocused)
                Spacer()
            }
            .padding(.horizontal)
            
            if viewModel.isFocused {
                Rectangle()
            }
        }
    }
}

//private extension ScheduleCreationView {
//    var components: some View {
//        VStack(spacing: 0) {
//            BorderedPicker(date: $date, type: .time)
//        }
//    }
//}

final class ScheduleCreationViewModel: ObservableObject {
    @Published var isFocused = false
}
