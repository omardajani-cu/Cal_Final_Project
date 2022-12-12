//
//  PostViewModel.swift
//  Cal
//
//  Created by Omar Dajani on 12/9/22.
//

import Foundation

class FoodsViewModel {
    func retrieveFoods(foodName: String) async throws -> [Food]? {
        do {
            if let data = try await retrieveFoodsData(foodName: foodName) {
                let decoder = JSONDecoder()
                let objects: FoodResult = try decoder.decode(FoodResult.self, from: data)
                return objects.getFoods()
            }
        } catch {
            print(String(describing: error))
        }
        
        return nil
    }
    
    func retrieveFoodsData(foodName: String) async throws -> Data? {
        let encodedString = foodName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let urlStr = "https://api.nal.usda.gov/fdc/v1/foods/search?api_key=2mMpMl3kKgWXMhHwYvLjQgbYNdTCAPfJFyyQ2Y0G&query=\(encodedString!)"
        let url = URL(string: urlStr)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
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
                
                if let mimeType = httpResponse.mimeType, mimeType == "application/json",
                   let data = data {
                    continuation.resume(returning: data)
                } else {
                    continuation.resume(throwing: ResponseError.badReturnContentType)
                }
            }
            .resume()
        }
    }
    
    func addFoodDiary(foodName: String) async throws {
        let url = URL(string: "https://omardajani.com/projects/cal/insertdiary.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let uploadData = "uid=\(Session.getInstance().getAccount()!.getUid())&foodName=\(foodName)"
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
                    print("invalid response")
                    continuation.resume(throwing: ResponseError.badReturnContentType)
                }
            }
            .resume()
        }
    }
}
