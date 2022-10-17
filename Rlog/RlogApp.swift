//
//  RlogApp.swift
//  Rlog
//
//  Created by 송시원 on 2022/10/17.
//

import SwiftUI

@main
struct RlogApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
