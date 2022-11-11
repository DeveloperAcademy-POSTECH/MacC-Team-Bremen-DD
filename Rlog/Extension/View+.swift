//
//  View+.swift
//  Rlog
//
//  Created by Noah's Ark on 2022/11/10.
//

import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, _ corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

// 도형의 일부분에 곡선 적용하기
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
