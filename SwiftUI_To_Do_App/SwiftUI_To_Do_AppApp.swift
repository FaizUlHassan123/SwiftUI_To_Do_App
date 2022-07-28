//
//  SwiftUI_To_Do_AppApp.swift
//  SwiftUI_To_Do_App
//
//  Created by Faiz Ul Hassan on 28/07/2022.
//

import SwiftUI

@main
struct SwiftUI_To_Do_AppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
