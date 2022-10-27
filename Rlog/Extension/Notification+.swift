//
//  Notification+.swift
//  Rlog
//
//  Created by Kim Insub on 2022/10/25.
//

import Foundation

extension Notification {
    static let disMiss = Notification.Name.init("dismiss")
    static let publisher = NotificationCenter.default.publisher(for: Notification.disMiss)
}
