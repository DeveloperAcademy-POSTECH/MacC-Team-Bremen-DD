//
//  ScheduleListView.swift
//  Rlog
//
//  Created by Kim Insub on 2022/11/10.
//

import SwiftUI

struct ScheduleListView: View {
    var body: some View {
        VStack {
            InputFormElement(containerType: .payday, text: .constant("25"))
            InputFormElement(containerType: .wage, text: .constant("25"))
            InputFormElement(containerType: .workplace, text: .constant("25"))
            InputFormElement(containerType: .reason, text: .constant("25"))
        }
        .padding(.horizontal)
    }
}
