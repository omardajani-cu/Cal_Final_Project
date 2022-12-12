//
//  DiaryViewModel.swift
//  Cal
//
//  Created by Omar Dajani on 12/10/22.
//

import Foundation

class DiaryViewModel {
    func retrieveDiary() async throws -> [DiaryItem]? {
        do {
            if let data = try await retrieveDiaryData() {
                let decoder = JSONDecoder()
                print(String(data: data, encoding: .utf8)!)
                let objects = try decoder.decode([DiaryItem].self, from: data)
                return objects
            }
        } catch {
            print(String(describing: error))
        }
        
        return nil
    }
    
    func retrieveDiaryData() async throws -> Data? {
        let url = URL(string: "https://omardajani.com/projects/cal/getdiary.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let uploadData = "uid=\(Session.getInstance().getAccount()!.getUid())"
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
                    continuation.resume(returning: data)
                } else {
                    print("error 1")
                    continuation.resume(throwing: ResponseError.badReturnContentType)
                }
            }
            .resume()
        }
    }
}
