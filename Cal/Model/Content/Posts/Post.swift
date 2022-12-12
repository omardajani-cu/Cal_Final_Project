//
//  Post.swift
//  Cal
//
//  Created by Omar Dajani on 12/6/22.
//

import Foundation

class Post: Codable, Identifiable {
    private var title: String = "" //
    private var creator: String = "" //
    private var date: String = "" //
    private var body: String = "" //
    
    func getTitle() -> String {
        return title
    }
    func getCreator() -> String {
        return creator
    }
    func getDate() -> String {
        return date
    }
    func getBody() -> String {
        return body
    }
}
