//
//  ScheduleCell.swift
//  Rlog
//
//  Created by Noah's Ark on 2022/11/11.
//

import SwiftUI

struct ScheduleCell: View {
    @ObservedObject var viewModel: ScheduleCellViewModel
    
    init(of data: WorkdayEntity, didTapConfirm: @escaping () -> Void) {
        self.viewModel = ScheduleCellViewModel(of: data, didTapConfirm: didTapConfirm)
    }
    
    var body: some View {
        scheduleInfo
            .transition(AnyTransition.opacity.animation(.easeInOut))
    }
}

private extension ScheduleCell {
    var scheduleInfo: some View {
        VStack(spacing: 0) {
            
            HStack {
                Text(viewModel.workType.name)
                    .font(.caption2)
                    .foregroundColor(Color.backgroundWhite)
                    .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6))
                    .background(viewModel.data.hasDone ? Color.grayLight : viewModel.workType.mainColor)
                    .cornerRadius(5)
                
                Spacer()
                
                Text(viewModel.spentHour)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(viewModel.data.hasDone ? Color.grayLight : Color.fontBlack)
            }
            
            HStack {
                Text("\(viewModel.data.workspace.name)")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(viewModel.data.hasDone ? Color.grayLight : Color.fontBlack)
                
                Spacer()
                
                Text("\(viewModel.startTimeString) ~ \(viewModel.endTimeString)")
                    .font(.body)
                    .foregroundColor(viewModel.data.hasDone ? Color.grayLight : Color.fontBlack)
            }
            .padding(.vertical, 8)
            
            if !viewModel.hasDone && !viewModel.data.hasDone {
                confirmationButton
            }
            
        }
        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        .background(Color.backgroundCard)
        .cornerRadius(10)
        .padding(2)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.backgroundStroke, lineWidth: 2)
        }
    }
    
    var confirmationButton: some View {
        HStack {
            Spacer()
            Button {
                viewModel.didTapConfirmationButton(viewModel.data)
            } label: {
                Text("확정하기")
                    .font(Font.caption.bold())
                    .padding(EdgeInsets(top: 5, leading: 29, bottom: 5, trailing: 29))
                    .foregroundColor(.white)
                    .background(viewModel.workType.mainColor)
                    .cornerRadius(10)
            }
        }
        .padding(.top, 8)
    }
}
