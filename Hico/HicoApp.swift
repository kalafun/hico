//
//  HicoApp.swift
//  Hico
//
//  Created by Tomas Bobko on 24.07.24.
//

import SwiftUI

@main
struct HicoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
