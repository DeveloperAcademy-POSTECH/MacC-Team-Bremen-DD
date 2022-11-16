//
 //  BorderedPicker.swift
 //  Rlog
 //
 //  Created by Noah's Ark on 2022/11/14.
 //

 import SwiftUI

 enum BorderedPickerType {
     case date
     case startTime
     case endTime

     var title: String {
         switch self {
         case .date: return "날짜"
         case .startTime: return "출근 시간"
         case .endTime: return "퇴근 시간"
         }
     }
 }

 struct BorderedPicker: View {
     @Binding var date: Date
     @State private var isTapped = false
     let type: BorderedPickerType
     var timeData: String {
         let components = Calendar.current.dateComponents(
             [.year, .month, .day, .hour, .minute],
             from: date
         )
         let year = components.year ?? 2000
         let month = components.month ?? 1
         let day = components.day ?? 1
         let hour = components.hour ?? 9
         let minute = components.minute ?? 0

         if type == .date {
             return "\(year)년 \(month)월 \(day)일"
         } else {
             return "\(hour):\(minute < 10 ? "0\(minute)" : "\(minute)")"
         }
     }

     var body: some View {
         borderedPicker
     }
 }

 private extension BorderedPicker {
     var borderedPicker: some View {
         HStack {
             if type == .date {
                 Text(timeData)
                 Spacer()
             } else {
                 Text(type.title)
                 Spacer()
                 Text(timeData)
             }
         }
         .padding(EdgeInsets(top: 13, leading: 16, bottom: 13, trailing: 16))
         .cornerRadius(13)
         .frame(maxWidth: .infinity, maxHeight: 56)
         .background(Color.backgroundCard)
         .onTapGesture { isTapped = true }
         .overlay {
             RoundedRectangle(cornerRadius: 13)
                 .stroke(
                     isTapped ? Color.primary : Color.backgroundStroke,
                     lineWidth: 2
                 )
         }
         .popover(isPresented: $isTapped) {
             wheelTimePicker
         }
     }

     var wheelTimePicker: some View {
         VStack(spacing: 0) {
             HStack {
                 Spacer()
                 Button {
                     isTapped = false
                 } label: {
                     Text("완료")
                         .foregroundColor(.primary)
                 }

             }
             .padding(.top)

             DatePicker(
                 "",
                 selection: $date,
                 displayedComponents: type != .date ? .hourAndMinute : .date
             )
                 .datePickerStyle(.wheel)
                 .background(.white)
                 .onAppear {
                     UIDatePicker.appearance().minuteInterval = 30
                 }
                 .onDisappear {
                     UIDatePicker.appearance().minuteInterval = 1
                     isTapped = false
                 }

             Spacer()
         }
         .padding(.horizontal)
     }
 }
