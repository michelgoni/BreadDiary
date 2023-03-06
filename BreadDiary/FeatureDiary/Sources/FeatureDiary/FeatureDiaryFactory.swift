//
//  File.swift
//  
//
//  Created by Michel Goñi on 4/3/23.
//

import Foundation
import NumbersUI
import SwiftUI

@available(iOS 16.0, *)
public extension ViewFactory {

    func diaryView() -> some View {
        make {
            ContentView()
        }
    }
}
