//
//  HomeFeature.swift
//  MyBreadTCADiary
//
//  Created by Michel Goñi on 21/10/24.
//
import ComposableArchitecture

@Reducer
struct HomeFeature {
    @ObservableState
    struct State: Equatable {
        var isLoading = false
        var entries: IdentifiedArrayOf<Entry> = []
        var searchState: SearchFeature.State
        @Presents var destination: Destination.State?
        
        init(
            isLoading: Bool = false,
            entries: IdentifiedArrayOf<Entry> = [],
            destination: Destination.State? = nil
        ) {
            self.isLoading = isLoading
            self.entries = entries
            self.searchState = SearchFeature.State(entries: entries)
            self.destination = destination
        }
    }
    
    enum Action {
        case fetchHomeData
        case homeDataResponse(TaskResult<[Entry]>)
        case search(SearchFeature.Action)
        case favorite(id: Entry.ID, action: FavoriteFeature.Action)
        case destination(PresentationAction<Destination.Action>)
        case showRecipeDetail(Entry)
        case addNewRecipeTapped
        case toggleFavorite(Entry)
        case updateRecipe(Entry)
        case deleteEntry(Entry)
    }
    
    @Dependency(\.homeClient) var homeClient
    
    var body: some ReducerOf<Self> {
        Scope(state: \.searchState, action: \.search) {
            SearchFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .fetchHomeData:
                state.isLoading = true
                return .run { send in
                    await send(.homeDataResponse(TaskResult { try await self.homeClient.fetch()}))
                }
                
            case let .homeDataResponse(.success(entries)):
                state.isLoading = false
                state.entries = IdentifiedArray(uniqueElements: entries)
                return .send(.search(.updateEntries(state.entries)))
                
            case .homeDataResponse(.failure):
                state.isLoading = false
                return .none
                
            case let .showRecipeDetail(entry):
                state.destination = .recipeDetail(
                    RecipeDetailFeature.State(
                        mode: .edit,
                        entry: entry
                    )
                )
                return .none
                
            case let .toggleFavorite(entry):
                if let index = state.entries.firstIndex(where: { $0.id == entry.id }) {
                    state.entries[index].isFavorite.toggle()
                    return .send(.search(.updateEntries(state.entries)))
                }
                return .none
                
            case let .updateRecipe(updatedEntry):
                if let _ = state.entries.firstIndex(where: { $0.id == updatedEntry.id }) {
                    state.entries[id: updatedEntry.id] = updatedEntry
                    return .send(.search(.updateEntries(state.entries)))
                }
                return .none
                
            case .search:
                return .none
                
            case .destination(.dismiss):
                return .send(.fetchHomeData)
                
            case let .destination(.presented(.recipeDetail(.delegate(.didDelete)))):
                if case let .recipeDetail(detailState) = state.destination {
                    return .send(.deleteEntry(detailState.entry))
                }
                return .none
                
            case let .deleteEntry(entry):
                if let index = state.entries.firstIndex(where: { $0.id == entry.id }) {
                    state.entries.remove(at: index)
                    state.destination = nil
                    return .run { [entries = state.entries] send in
                        do {
                            try await homeClient.save(Array(entries))
                            await send(.search(.updateEntries(entries)))
                        } catch {
                            // Handle error if needed
                        }
                    }
                }
                return .none
                
            case let .destination(.presented(.recipeDetail(.delegate(.didSave)))):
                state.destination = nil
                return .send(.fetchHomeData)
                
            case .destination:
                return .none
                
            case .addNewRecipeTapped:
                state.destination = .recipeDetail(
                    RecipeDetailFeature.State(
                        mode: .create,
                        entry: Entry.empty()
                    )
                )
                return .none
                
            case let .destination(.presented(.recipeDetail(.confirmDeletion))):
                if case let .recipeDetail(detailState) = state.destination {
                    state.destination = nil
                    return .send(.deleteEntry(detailState.entry))
                }
                return .none
                
            case .favorite:
                return .none
            
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }
    
    static func previewStore(
        isLoading: Bool = false,
        entries: IdentifiedArrayOf<Entry> = IdentifiedArrayOf()
    ) -> StoreOf<HomeFeature> {
        Store(
            initialState: HomeFeature.State(
                isLoading: isLoading,
                entries: entries
            ),
            reducer: {
                HomeFeature()
            },
            withDependencies: {
                $0.homeClient = HomeClient(
                    fetch: { [] },
                    save: { _ in }
                )
            }
        )
    }
    
    static func previewStoreWithEntries() -> StoreOf<HomeFeature> {
        let store = Store(
            initialState: HomeFeature.State(
                isLoading: true
            ),
            reducer: {
                HomeFeature()
            },
            withDependencies: {
                $0.homeClient = .mockValue
            }
        )
        
        Task {
            await store.send(.fetchHomeData).finish()
        }
        
        return store
    }
}

@Reducer
struct Destination {
    enum State: Equatable {
        case recipeDetail(RecipeDetailFeature.State)
    }
    
    enum Action {
        case recipeDetail(RecipeDetailFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.recipeDetail, action: \.recipeDetail) {
            RecipeDetailFeature()
        }
    }
}
