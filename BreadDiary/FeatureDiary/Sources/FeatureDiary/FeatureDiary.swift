import SwiftUI
import Foundation
@available(iOS 13.0, *)

@available(iOS 13.0, *)
struct Cell: View {
    let row: Int
    let column: Int

    var body: some View {
        Text("\(row), \(column)")
            .frame(width: 320, height: 180)
            .background(Color.blue)
    }
}

@available(iOS 13.0, *)
struct Row: View {
    let index: Int

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(0..<10) { index1 in
                    Cell(row: index, column: index1)
                }
            }
        }
    }
}

@available(iOS 13.0, *)
struct Grid: View {
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0..<20) { index in
                    Row(index: index)
                }
            }
        }
    }
}
