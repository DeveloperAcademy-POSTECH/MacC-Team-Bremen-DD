//
//  ScheduleListView+.swift
//  Rlog
//
//  Created by 정지혁 on 2022/10/20.
//

import SwiftUI

extension ScheduleListView {
    struct CustomPicker: View {
        @Binding var selectedCase: String
        var options: [String]
        
        var body: some View {
            GeometryReader { geometry in
                ZStack {
                    Rectangle()
                        .fill(.white)
                    Rectangle()
                        .fill(Color.primary)
                        .frame(width: 97)
                        .cornerRadius(20)
                        .offset(x: selectedCase == options[0] ? -40 : 40)
                    HStack(spacing: 0) {
                        ForEach(options, id: \.self) { option in
                            ZStack {
                                Rectangle()
                                    .fill(.clear)
                                    .frame(width: selectedCase == option ? 97 : 176 - 97)
                                Text(option)
                                    .font(.caption2)
                                    .fontWeight(selectedCase == option ? .bold : .regular)
                                    .foregroundColor(selectedCase == option ? .white : Color.fontBlack)
                                    .onTapGesture {
                                        withAnimation {
                                            selectedCase = option
                                        }
                                    }
                            }
                        }
                    }
                }
                .cornerRadius(20)
            }
        }
    }
}
