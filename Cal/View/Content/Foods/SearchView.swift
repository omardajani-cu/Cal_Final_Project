//
//  SearchView.swift
//  Cal
//
//  Created by Omar Dajani on 12/9/22.
//

import SwiftUI

struct SearchView: View {
    @State var foodResults: [Food] = []
    @State var searchText: String = ""
    
    var body: some View {
        VStack {
            HStack {
                TextField("Search foods...", text: $searchText)
                    .background(.gray)
                Button("Search") {
                    Task {
                        do {
                            if let _foodResults = try await FoodsViewModel().retrieveFoods(foodName: searchText) {
                               foodResults = _foodResults
                            }
                        } catch {
                            
                        }
                    }
                }
            }
            .padding(20)
            
            if (foodResults.count > 0) {
                NavigationStack() {
                    List(foodResults) { food in
                        if let brandName = food.getBrandName() {
                            NavigationLink("\(food.getDescription()) - \(brandName)") {
                                FoodDetailView(data: food)
                            }
                            .navigationTitle("Posts")
                        } else {
                            NavigationLink("\(food.getDescription())") {
                                FoodDetailView(data: food)
                            }
                            .navigationTitle("Posts")
                        }
                    }
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
