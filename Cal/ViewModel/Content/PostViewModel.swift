//
//  PostViewModel.swift
//  Cal
//
//  Created by Omar Dajani on 12/6/22.
//

import Foundation

class PostViewModel {
    func createPost(title: String, body: String) async -> Bool {
        do {
            try await createPostData(title: title, body: body)
            return true
        }
        catch {
            return false
        }
    }
    
    func createPostData(title: String, body: String) async throws {
        let url = URL(string: "https://omardajani.com/projects/cal/createPost.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let uploadData = "title=\(title)&body=\(body)&uid=\(Session.getInstance().getAccount()!.getUid())"
        request.httpBody = uploadData.data(using: String.Encoding.utf8)
        
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    continuation.resume(throwing: ResponseError.unprocessableEntity)
                    return
                }
                
                if let mimeType = response.mimeType,
                   mimeType == "text/html" {
                    continuation.resume()
                    return
                } else {
                    continuation.resume(throwing: ResponseError.badReturnContentType)
                }
            }
            .resume()
        }
    }
    
    func retrievePosts() async throws -> [Post]? {
        do {
            if let data = try await retrievePostsData() {
                let decoder = JSONDecoder()
                let objects = try decoder.decode([Post].self, from: data)
                return objects
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
    func retrievePostsData() async throws -> Data? {
        let url = URL(string: "https://omardajani.com/projects/cal/getposts.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    continuation.resume(throwing: ResponseError.unprocessableEntity)
                    return
                }
                
                if let mimeType = httpResponse.mimeType, mimeType == "applications/json",
                   let data = data {
                    continuation.resume(returning: data)
                } else {
                    continuation.resume(throwing: ResponseError.badReturnContentType)
                }
            }
            .resume()
        }
    }
}
