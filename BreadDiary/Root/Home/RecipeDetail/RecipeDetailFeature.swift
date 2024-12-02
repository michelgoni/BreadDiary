import ComposableArchitecture
import Foundation
import PhotosUI
import SwiftUI

@Reducer
struct RecipeDetailFeature {
    enum Mode {
        case edit
        case create
    }
    
    @ObservableState
    struct State: Equatable {
        let mode: Mode
        var entry: Entry
        @Presents var destination: Destination.State?
        var isShowingDeleteConfirmation = false
        var delegate: Delegate?
        
        enum Delegate: Equatable {
            case didSave
            case didDelete
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    enum Action {
        case autolysisTimeChanged(String)
        case bakingTimeChanged(String)
        case steamUsedModified(Bool)
        case bulkFermentationTimeChanged(String)
        case kneadingDescriptionChanged(String)
        case secondFermentationTimeChanged(String)
        case nameChanged(String)
        case sourDoughRiseTimeChanged(String)
        case sourDoughFeedtemperature(String)
        case dateChanged(Date)
        case ingredientAdded(String)
        case ingredientRemoved(Ingredient)
        case temperatureChanged(String)
        case timeFieldTapped(TimeField)
        case timeFieldChanged(TimeField, Date)
        case foldsChanged(String)
        case ratingChanged(field: RatingField, value: Int)
        case photoButtonTapped
        case destination(PresentationAction<Destination.Action>)
        case save
        case saveNewEntry
        case saveNewEntryResponse(TaskResult<Bool>)
        case deleteButtonTapped
        case confirmDeletion
        case dismissDeletion
        case delegate(Delegate)
        case didDelete
        
        enum TimeField {
            case motherDoughRefreshed
            case prefermentPrepared
            case autolysis
            case bulkFermentation
            case shaping
        }
        
        enum RatingField {
            case crust, crumb, rise, scoring, taste, overall
        }
        
        enum Delegate {
            case didSave
            case didDelete
        }
    }
    
    @Reducer
    struct Destination {
        enum State: Equatable {
            case datePicker(DatePickerFeature.State)
            case photoPicker(PhotoPickerFeature.State)
        }
        
        enum Action {
            case datePicker(DatePickerFeature.Action)
            case photoPicker(PhotoPickerFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: \.datePicker, action: \.datePicker) {
                DatePickerFeature()
            }
            Scope(state: \.photoPicker, action: \.photoPicker) {
                PhotoPickerFeature()
            }
        }
    }
    
    @Dependency(\.homeClient) var homeClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .autolysisTimeChanged(autolysisTime):
                state.entry.autolysisTime = autolysisTime
                return .none
            case let .bakingTimeChanged(bakingTime):
                state.entry.bakingTime = bakingTime
                return .none
            case let .bulkFermentationTimeChanged(bulkFermentation):
                state.entry.bulkFermentationTime = bulkFermentation
                return .none
            case let .secondFermentationTimeChanged(secondFermentationTime):
                state.entry.secondFermentarionTime = secondFermentationTime
                return .none
            case let .kneadingDescriptionChanged(kneadingDescription):
                state.entry.kneadingProcess = kneadingDescription
                return .none
            case let .nameChanged(name):
                state.entry.name = name
                return .none
            case let .sourDoughRiseTimeChanged(sourDoughRiseTime):
                state.entry.sourDoughRiseTime = sourDoughRiseTime
                return .none
            case let .sourDoughFeedtemperature(FeedTemperature):
                state.entry.sourdoughFeedTemperature = FeedTemperature
                return .none
            case let .dateChanged(date):
                state.entry.entryDate = date
                return .none
            case let .ingredientAdded(ingredient):
                state.entry.ingredients.append(
                    Ingredient(id: .init(UUID()), ingredient: ingredient)
                )
                return .none
                
            case let .ingredientRemoved(ingredient):
                state.entry.ingredients.remove(ingredient)
                return .none
            
            case let .steamUsedModified(isSteamUsed):
                state.entry.isSteamUsed = isSteamUsed
                return .none
                
            case let .temperatureChanged(temperature):
                state.entry.sourdoughFeedTemperature = temperature
                return .none
                
            case let .timeFieldTapped(field):
                state.destination = .datePicker(DatePickerFeature.State(
                    date: Date(),
                    field: field
                ))
                return .none
                
            case let .timeFieldChanged(field, value):
                switch field {
                case .motherDoughRefreshed:
                    state.entry.sourdoughFeedTimeDate = value
                case .prefermentPrepared:
//                    state.entry.autolysisTime = value
                    return .none
                case .autolysis:
                    state.entry.autolysisStartingTime = value
                    return .none
                case .bulkFermentation:
//                    state.entry.bulkFermentationStartingTime = value
                    return .none
                case .shaping:
                    // Handled by date picker, no need to update here
                    break
                }
                return .none
                
            case let .foldsChanged(folds):
                state.entry.folds = folds
                return .none
                
            case let .ratingChanged(field, value):
                switch field {
                case .crust:
                    state.entry.crustRating = value
                case .crumb:
                    state.entry.crumbRating = value
                case .rise:
                    state.entry.bloomRating = value
                case .scoring:
                    state.entry.scoreRating = value
                case .taste:
                    state.entry.tasteRating = value
                case .overall:
                    state.entry.evaluation = value
                }
                return .none
                
            case .photoButtonTapped:
                state.destination = .photoPicker(PhotoPickerFeature.State())
                return .none
                
            case let .destination(.presented(.datePicker(.delegate(.timeSelected(date, field))))):
                state.destination = nil
                switch field {
                case .motherDoughRefreshed:
                    state.entry.sourdoughFeedTime = dateFormatter.string(from: date)
                case .prefermentPrepared:
                    state.entry.autolysisTime = dateFormatter.string(from: date)
                case .autolysis:
                    state.entry.autolysisStartingTime = date
                case .bulkFermentation:
                    state.entry.bulkFermentationStartingTime = dateFormatter.string(from: date)
                case .shaping:
                    state.entry.breadFormingTime = date
                }
                return .none
                
            case let .destination(.presented(.photoPicker(.delegate(.photoSelected(data))))):
                state.entry.image = data
                state.destination = nil
                return .none
                
            case .destination(.dismiss):
                state.destination = nil
                return .none
                
            case .save:
                // Perform save action here
                return .none
            case .destination:
                return .none
            case .saveNewEntry:
                return .run { [entry = state.entry] send in
                    do {
                        var entries = try await homeClient.fetch()
                        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
                            entries[index] = entry
                        } else {
                            entries.append(entry)
                        }
                        try await homeClient.save(entries)
                        await send(.saveNewEntryResponse(.success(true)))
                    } catch {
                        await send(.saveNewEntryResponse(.failure(error)))
                    }
                }
                
            case .saveNewEntryResponse(.success):
                state.delegate = .didSave
                return .none
                
            case .saveNewEntryResponse(.failure):
                // Handle save failure
                return .none
                
            case .delegate:
                return .none
                
            case .deleteButtonTapped:
                state.isShowingDeleteConfirmation = true
                return .none
            
            case .confirmDeletion:
                state.isShowingDeleteConfirmation = false
                state.delegate = .didDelete
                return .none
            
            case .dismissDeletion:
                state.isShowingDeleteConfirmation = false
                return .none
            
            case .didDelete:
                state.delegate = .didDelete
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }
}
