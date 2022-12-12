//
//  Food.swift
//  Cal
//
//  Created by Omar Dajani on 12/9/22.
//

import Foundation

class Food: Codable, Identifiable {
    private var fdcId: Int = 0
    private var description: String = ""
    private var brandName: String? = ""
    private var ingredients: String? = ""
    private var servingSize: Double? = 0.0
    private var servingSizeUnit: String? = ""
    
    func getFdcId() -> Int {
        return fdcId
    }
    func getDescription() -> String {
        return description
    }
    func getBrandName() -> String? {
        return brandName
    }
    func getIngredients() -> String? {
        return ingredients
    }
    func getServingSize() -> Double? {
        return servingSize
    }
    func getServingSizeUnit() -> String? {
        return servingSizeUnit
    }
}

class FoodResult: Codable, Identifiable {
    private var foods: [Food] = []
    
    func getFoods() -> [Food] {
        return foods
    }
}
