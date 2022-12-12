//
//  NewPostView.swift
//  Cal
//
//  Created by Omar Dajani on 12/8/22.
//

import SwiftUI

struct NewPostView: View {
    @State var titleText: String = ""
    @State var bodyText: String = ""
    @State var resultText: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Post title", text: $titleText)
                .background(.gray)
            
            TextField("Post body", text: $bodyText, axis: .vertical)
                .frame(height: 90.0)
                .background(.gray)
            
            Text(resultText)
            
            Button("Create") {
                Task {
                    let result = await PostViewModel().createPost(title: titleText, body: bodyText)
                    
                    if (result) {
                        resultText = "Post created"
                    } else {
                        resultText = "Failed to create post, please try again later"
                    }
                }
            }
        }
    }
}

struct NewPostView_Previews: PreviewProvider {
    static var previews: some View {
        NewPostView()
    }
}
