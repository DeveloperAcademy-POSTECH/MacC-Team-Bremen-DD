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
    
    func navigationToolbarSetting(
        leftAction: @escaping () -> Void,
        rightAction: @escaping () -> Void
    ) -> some View {
        modifier(CustomToolbar(leftAction: leftAction, rightAction: rightAction))
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

struct CustomToolbar: ViewModifier {
    var leftAction: () -> Void
    var rightAction: () -> Void
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        leftAction()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.fontBlack)
                        Text("이전")
                            .foregroundColor(.fontBlack)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        rightAction()
                        
                    } label: {
                        Text("완료")
                            .fontWeight(.bold)
                            .foregroundColor(Color.primary)
                    }
                }
            }
    }
}
