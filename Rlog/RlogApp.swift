//
//  RlogApp.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI

@main
struct RlogApp: App {
    @StateObject var viewRouter = ViewRouter()

    var body: some Scene {
        WindowGroup {
            MainTabView(viewRouter: viewRouter)
        }
    }
}
