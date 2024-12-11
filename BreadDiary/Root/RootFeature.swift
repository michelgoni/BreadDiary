//
//  RootFeature.swift
//  MyBreadTCADiary
//
//  Created by Michel Goñi on 21/10/24.
//
import ComposableArchitecture

@Reducer
struct RootFeature {
    @ObservableState
    struct State: Equatable {
        var selectedTab: Tab = .home
        var homeState = HomeFeature.State()
        var calendarState = CalendarFeature.State(recipeDates: [], recipesByDate: [:])
    }
    
    enum Action {
        case selectTab(Tab)
        case homeAction(HomeFeature.Action)
        case calendarAction(CalendarFeature.Action)
    }
    
    enum Tab {
        case home, calendar
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .selectTab(tab):
                state.selectedTab = tab
                return .none
            case .homeAction, .calendarAction:
                return .none
            }
        }
        Scope(state: \.homeState, action: \.homeAction) {
            HomeFeature()
        }
        Scope(state: \.calendarState, action: \.calendarAction) {
            CalendarFeature()
        }
    }
    
    static func previewCreateStore() -> StoreOf<RootFeature> {
        let state = RootFeature.State(
            homeState: HomeFeature.State(
                destination: .recipeDetail(
                    RecipeDetailFeature.State(
                        mode: .create,
                        entry: .empty()
                    )
                )
            ),
            calendarState: CalendarFeature.State.mockState()
        )
        
        return Store(
            initialState: state,
            reducer: {
                RootFeature()
            }
        )
    }
    
    static func previewStore() -> StoreOf<RootFeature> {
        let store = Store(
            initialState: RootFeature.State(
                homeState: HomeFeature.State(isLoading: true),
                calendarState: CalendarFeature.State.mockState()
            ),
            reducer: {
                RootFeature()
            },
            withDependencies: {
                $0.homeClient = .mockValue
            }
        )
        
        Task {
            await store.send(.homeAction(.fetchHomeData)).finish()
        }
        
        return store
    }
}
