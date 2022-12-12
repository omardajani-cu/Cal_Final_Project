//
//  Diary.swift
//  Cal
//
//  Created by Omar Dajani on 12/10/22.
//

import Foundation

class DiaryItem: Codable, Identifiable {
    private var foodName: String
    
    func getFoodName() -> String {
        return foodName
    }
}
