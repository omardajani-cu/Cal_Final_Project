//
//  PostDetailView.swift
//  Cal
//
//  Created by Omar Dajani on 12/6/22.
//

import SwiftUI

struct PostDetailView: View {
    var data: Post
    var body: some View {
        VStack {
            Text(data.getTitle())
                .font(.title)
            Divider()
            HStack {
                Text("Posted by: \(data.getCreator())")
                    .font(.headline)
                Spacer()
                    .frame(width: 20)
                Text(data.getDate())
            }
            Text(data.getBody())
                .padding(20)
        }
    }
}
