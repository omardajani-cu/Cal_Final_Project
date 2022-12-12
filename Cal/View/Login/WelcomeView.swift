//
//  WelcomeView.swift
//  Cal
//
//  Created by Omar Dajani on 11/29/22.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var unathorizedWindow: WelcomeScreenType
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Login") {
                unathorizedWindow = WelcomeScreenType.login
            }
            
            Button("Register") {
                unathorizedWindow = WelcomeScreenType.register
            }
        }
    }
}
