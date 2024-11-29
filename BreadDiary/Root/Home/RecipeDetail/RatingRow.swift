//
//  RatingRow.swift
//  MyBreadTCADiary
//
//  Created by Michel Goñi on 21/11/24.
//

import SwiftUI

struct RatingRow: View {
    let title: String
    @Binding var rating: Int
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            HStack {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: star <= rating ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                        .onTapGesture {
                            rating = star
                        }
                }
            }
        }
    }
}

// Start Generation Here
struct RatingRow_Previews: PreviewProvider {
    @State static var sampleRating = 3
    
    static var previews: some View {
        RatingRow(title: "Sample Rating", rating: $sampleRating)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
