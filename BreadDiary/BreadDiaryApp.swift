//
//  BreadDiaryApp.swift
//  BreadDiary
//
//  Created by Michel Goñi on 26/2/23.
//

import SwiftUI

@main
struct BreadDiaryApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
