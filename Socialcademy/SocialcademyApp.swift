//
//  SocialcademyApp.swift
//  Socialcademy
//
//  Created by wesley osborne on 11/1/23.
//

import SwiftUI
import Firebase

@main
struct SocialcademyApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
