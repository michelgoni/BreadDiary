//
//  ViewFactory.swift
//  BreadDiary
//
//  Created by Michel Goñi on 26/2/23.
//

import NumbersUI
import SwiftUI

public extension ViewFactory {
    func getMainView() -> some View {
        make {
            MainView()
        }
    }

    func getDiaryView() -> some View {

        make {
            ContentView()
        }
    }

    func getCalendarView() -> some View {

        make {
            ContentView()
        }
    }
}
