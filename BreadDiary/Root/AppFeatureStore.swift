//
//  AppFeatureStore.swift
//  MyBreadTCADiary
//
//  Created by Michel Goñi on 21/10/24.
//
import ComposableArchitecture

@Reducer
struct InitialAppFeature {
    @ObservableState
    struct State: Equatable {
        var rootState: RootFeature.State
    }
    
    enum Action {
        case initApp
        case rootAction(RootFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.rootState, action: \.rootAction) {
            RootFeature()
        }

        Reduce { state, action in
            switch action {
            case .initApp:
                return .send(.rootAction(.homeAction(.fetchHomeData)))
            case .rootAction:
                return .none
            }
        }
    }
    
    static func previewStore() -> StoreOf<InitialAppFeature> {
        let store = Store(
            initialState: InitialAppFeature.State(
                rootState: RootFeature.State(
                    homeState: HomeFeature.State(isLoading: true)
                )
            ),
            reducer: {
                InitialAppFeature()
            },
            withDependencies: {
                $0.homeClient = .mockValue
            }
        )
        
        // Trigger the initial load
        store.send(.initApp)
        
        return store
    }
}
