//
//  LoginView.swift
//  Cal
//
//  Created by Omar Dajani on 11/29/22.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var session: Session
    @Binding var unathorizedWindow: WelcomeScreenType
    
    @State var emailText: String = ""
    @State var passwordText: String = ""
    @State var resultText: String = ""
    let loginViewModel: LoginViewModel = LoginViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Email", text: $emailText)
                .background(.gray)
            
            TextField("Password", text: $passwordText)
                .background(.gray)
            
            Text(resultText)
            
            Button("Sign in") {
                Task {
                    if let unwrappedResultText = await LoginViewModel().signIn(email: emailText, password: passwordText) {
                        resultText = unwrappedResultText
                    }
                }
            }
            
            Button("Back") {
                unathorizedWindow = WelcomeScreenType.welcome
            }
        }
    }
}
