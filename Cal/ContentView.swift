//
//  ContentView.swift
//  Cal
//
//  Created by Omar Dajani on 11/29/22.
//

import SwiftUI

enum WelcomeScreenType {
    case welcome, login, register
}

struct ContentView: View {
    @StateObject var session: Session = Session.getInstance()
    @State private var unathorizedWindow: WelcomeScreenType = WelcomeScreenType.welcome
    
    var body: some View {
        if (session.signedIn) {
            if ((session.getAccount() as? Admin) != nil) {
                Text("admin account")
            } else {
                Text("customer account")
            }
            TabView {
                PostsView()
                    .tabItem {
                        Label("Posts", systemImage: "list.dash")
                    }
                
                SearchView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                
                DiaryView()
                    .tabItem {
                        Label("Diary", systemImage: "square.and.pencil")
                    }
            }
        } else {
            switch(unathorizedWindow) {
            case WelcomeScreenType.welcome:
                WelcomeView(unathorizedWindow: $unathorizedWindow)
            case WelcomeScreenType.login:
                LoginView(unathorizedWindow: $unathorizedWindow)
            case WelcomeScreenType.register:
                RegisterView(unathorizedWindow: $unathorizedWindow)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
