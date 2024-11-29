//
//  RootView.swift
//  MyBreadTCADiary
//
//  Created by Michel Goñi on 21/10/24.
//

import ComposableArchitecture
import SwiftUI

struct RootView: View {
    let store: StoreOf<RootFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            TabView(selection: viewStore.binding(get: \.selectedTab, send: RootFeature.Action.selectTab)) {
                NavigationView {
                    HomeView(store: store.scope(state: \.homeState, action: \.homeAction))
                }
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(RootFeature.Tab.home)
                
                NavigationView {
                    CalendarView(store: store.scope(state: \.calendarState, action: \.calendarAction))
                }
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
                .tag(RootFeature.Tab.calendar)
            }
        }
    }
}

#Preview {
    RootView(
        store: Store(initialState: RootFeature.State()) {
            RootFeature()
        }
    )
}
