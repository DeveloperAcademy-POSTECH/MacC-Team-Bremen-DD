//
//  YearMonthStepperCalendar.swift
//  Rlog
//
//  Created by Hyeon-sang Lee on 2022/11/16.
//

import SwiftUI

struct YearMonthStepperCalendar: View {
    let tapToPreviousMonth: () -> Void
    let tapToNextMonth: () -> Void
    let currentMonth: String
    
    var body: some View {
        HStack(spacing: 0) {
            Group {
                Button {
                    tapToPreviousMonth()
                } label: {
                    Image(systemName: "chevron.left")
                }
                Text(currentMonth)
                Button {
                    tapToNextMonth()
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
            .foregroundColor(.fontBlack)
            .font(.title)
        }
    }
}

