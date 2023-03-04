//
//  MainView.swift
//  BreadDiary
//
//  Created by Michel Goñi on 26/2/23.
//

import FeatureDiary
import SwiftUI
import NumbersEx

private extension String {
    static let breadImage = "highlighter"
    static let calendarImage = "calendar"
}

struct MainView: View {

    var body: some View {
        Container()
    }
}

private struct Container: View {

    @Environment(\.viewFactory) private var viewFactory
    @State private var selectedTab: Int = TagType.diary.rawValue
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                viewFactory.diaryView().tabItem(.diary)
                viewFactory.getCalendarView().tabItem(.calendar)
            }
        }
    }
}

enum TagType: Int {
    case diary
    case calendar
}

private extension TagType {
    var title: String {
        switch self {
        case .diary:
            return "Diary"
        case .calendar:
            return "Calendar"
        }
    }

    var image: Image {
        switch self {
        case .diary:
            return Image(systemName: .breadImage)
        case .calendar:
            return Image(systemName: .calendarImage)

        }
    }
}

private extension View {

    func tabItem(_ tab: TagType) -> some View {
        padding(.bottom, 1)
            .tabItem {
                tab.image
                if let title = tab.title {
                    Text(title)
                }
            }
            .tag(tab.rawValue)
    }
}
