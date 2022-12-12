//
//  RegisterView.swift
//  Cal
//
//  Created by Omar Dajani on 11/29/22.
//

import SwiftUI

struct RegisterView: View {
    @Binding var unathorizedWindow: WelcomeScreenType
    
    @State var emailText: String = ""
    @State var nameText: String = ""
    @State var usernameText: String = ""
    @State var passwordText: String = ""
    @State var resultText: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Email", text: $emailText)
                .background(.gray)
            
            TextField("Name", text: $nameText)
                .background(.gray)
            
            TextField("Username", text: $usernameText)
                .background(.gray)
            
            SecureField("Password", text: $passwordText)
                .background(.gray)
            
            Text(resultText)
            
            Button("Create account") {
                Task {
                    if let unwrappedResultText = await LoginViewModel().createUser(email: emailText, name: nameText, username: usernameText, password: passwordText) {
                        resultText = unwrappedResultText
                    } else {
                        unathorizedWindow = WelcomeScreenType.login
                    }
                }
            }
            
            Button("Back") {
                unathorizedWindow = WelcomeScreenType.welcome
            }
        }
    }
}
