//
//  PostsView.swift
//  Cal
//
//  Created by Omar Dajani on 12/6/22.
//

import SwiftUI

struct DiaryView: View {
    @State private var diary: [DiaryItem] = []
    let diaryViewModel: DiaryViewModel = DiaryViewModel()
    
    func refreshDiary() {
        Task {
            do {
                if let data = try await diaryViewModel.retrieveDiary() {
                    diary = data
                }
            } catch {
                
            }
        }
    }
    
    var body: some View {
        if (diary.count == 0) {
            Task {
                do {
                    if let data = try await diaryViewModel.retrieveDiary() {
                        diary = data
                    }
                } catch {
                    
                }
            }
        }
        return VStack {
            Button("Refresh diary") {
                refreshDiary()
            }
            List(diary) { diaryItem in
                Text(diaryItem.getFoodName())
            }
        }
    }
}

struct DiaryView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView()
    }
}
