//
//  LoginViewModel.swift
//  Cal
//
//  Created by Omar Dajani on 11/29/22.
//

import Foundation
import FirebaseAuth

enum ResponseError: Error {
    case unprocessableEntity
    case internalError
    case badReturnContentType
}

class LoginViewModel {
    func getErrorFromCode(error: Error) -> String? {
        switch (error) {
            case ResponseError.unprocessableEntity:
                return "(422) Unprocessable Entity"
            case ResponseError.internalError:
                return "(500) Internal Error"
            case ResponseError.badReturnContentType:
                return "(415) Unsupported Media Type"
            default:
                return error.localizedDescription
        }
    }
    
    func signIn(email: String, password: String) async -> String? {
        do {
            let auth = try await Auth.auth().signIn(withEmail: email, password: password)
            try await retrieveProfile(uid: auth.user.uid)
            DispatchQueue.main.async {
                Session.getInstance().signedIn = true
            }
            return nil
        }
        catch {
            return getErrorFromCode(error: error)
        }
    }
    
    func createUser(email: String, name: String, username: String, password: String) async -> String? {
        do {
            let auth = try await Auth.auth().createUser(withEmail: email, password: password)
            try await createProfile(uid: auth.user.uid, name: name, username: username)
            return nil
        } catch {
            return getErrorFromCode(error: error)
        }
    }
    
    func createProfile(uid: String, name: String, username: String) async throws {
        let url = URL(string: "https://omardajani.com/projects/cal/insertprofile.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let uploadData = "uid=\(uid)&name=\(name)&username=\(username)"
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
    
    func retrieveProfile(uid: String) async throws {
        let url = URL(string: "https://omardajani.com/projects/cal/getprofile.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let uploadData = "uid=\(uid)"
        request.httpBody = uploadData.data(using: String.Encoding.utf8)
        
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
                    let decoder = JSONDecoder()
                    do {
                        let accountFactory = AccountFactory()
                        let tempAccount = try decoder.decode(Account.self, from: data)
                        Session.getInstance().account = accountFactory.create(type: tempAccount.getRole() == 0 ? AccountFactory.AccountType.customer : AccountFactory.AccountType.admin, data: data)
                    } catch {
                        continuation.resume(throwing: error)
                        return
                    }
                    continuation.resume()
                } else {
                    continuation.resume(throwing: ResponseError.badReturnContentType)
                }
            }
            .resume()
        }
    }
}
