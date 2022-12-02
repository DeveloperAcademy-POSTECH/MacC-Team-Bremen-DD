//
//  WorkSpaceInfoSubView.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/19.
//
import SwiftUI

struct WorkSpaceInfoSubView: View {
    let labelName: String
    let content: String

    var body: some View {

        VStack(alignment: .leading, spacing: 10) {
            Text(labelName)
                .font(.caption)
                .foregroundColor(.grayLight)
            Text(content)
                .foregroundColor(.black)
        }
    }
}
