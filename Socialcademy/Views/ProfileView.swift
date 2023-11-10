//
//  ProfileView.swift
//  Socialcademy
//
//  Created by wesley osborne on 11/9/23.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    var body: some View {
        Button("Sign Out") {
            try! Auth.auth().signOut()
        }
    }
}

#Preview {
    ProfileView()
}
