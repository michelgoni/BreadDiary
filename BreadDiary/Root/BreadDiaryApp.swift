//
//  BreadDiaryApp.swift
//  BreadDiary
//
//  Created by Michel Goñi on 29/11/24.
//

import ComposableArchitecture
import SwiftUI

@main
struct MyBreadTCADiaryApp: App {
    
    private let store = Store(
        initialState: InitialAppFeature.State(
            rootState: .init()
        )
    ) {
        InitialAppFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(
                store: store.scope(
                    state: \.rootState,
                    action: \.rootAction)
            ).onAppear {
                self.store.send(.initApp)
            }
        }
    }
}

#Preview {
    RootView(
        store: InitialAppFeature
            .previewStore()
            .scope(
            state: \.rootState,
            action: \.rootAction
        )
    )
}
