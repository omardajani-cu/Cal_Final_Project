//
//  PostsView.swift
//  Cal
//
//  Created by Omar Dajani on 12/6/22.
//

import SwiftUI

struct PostsView: View {
    @State private var path: [Color] = []
    @State private var posts: [Post] = []
    @State private var searchText: String = ""
    let postViewModel: PostViewModel = PostViewModel()
    
    func refreshPosts() {
        Task {
            do {
                if let data = try await postViewModel.retrievePosts() {
                    posts = data
                }
            } catch {
                
            }
        }
    }
    
    var body: some View {
        if (posts.count == 0) {
            Task {
                do {
                    if let data = try await postViewModel.retrievePosts() {
                        posts = data
                    }
                } catch {
                    
                }
            }
        }
        return NavigationStack(path: $path) {
            Button("Refresh posts") {
                refreshPosts()
            }
            List(posts) { post in
                NavigationLink(post.getTitle()) {
                    PostDetailView(data: post)
                }
                .navigationTitle("Posts")
            }
            NavigationLink("New post") {
                NewPostView()
            }
            .navigationTitle("New post")
        }
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView()
    }
}
