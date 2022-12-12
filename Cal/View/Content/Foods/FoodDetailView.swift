//
//  FoodDetailView.swift
//  Cal
//
//  Created by Omar Dajani on 12/9/22.
//

import SwiftUI

struct FoodDetailView: View {
    var data: Food
    @State var resultText: String = ""
    var body: some View {
        VStack(spacing: 30) {
            if let brandBrandName = data.getBrandName() {
                Text("\(data.getDescription()) - \(brandBrandName)")
                    .font(.title)
            } else {
                    Text(data.getDescription())
            }
            Divider()
            if let ing = data.getIngredients() {
                Text("CONTAINS: \(ing)")
            }
            if let servingSize = data.getServingSize(), let servingSizeUnit = data.getServingSizeUnit() {
                Text("\(servingSize) - \(servingSizeUnit)")
            }
            Button("Add food to diary") {
                Task {
                    do {
                        try await FoodsViewModel().addFoodDiary(foodName: data.getDescription())
                        resultText = "\(data.getDescription()) added to diary"
                    } catch {
                        resultText = "Could not add \(data.getDescription()) to diary, please try again later"
                    }
                }
            }
            
            Text(resultText)
        }
    }
}
