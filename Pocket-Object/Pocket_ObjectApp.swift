//
//  Pocket_ObjectApp.swift
//  Pocket-Object
//
//  Created by 구본의 on 2023/06/10.
//

import SwiftUI
import SwiftData

@main
struct Pocket_ObjectApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
         
         return true
    }
}
