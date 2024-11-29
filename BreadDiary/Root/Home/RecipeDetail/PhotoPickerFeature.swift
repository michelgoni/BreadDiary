//
//  PhotoPickerFeature.swift
//  MyBreadTCADiary
//
//  Created by Michel Goñi on 18/11/24.
//
import ComposableArchitecture
import Foundation

@Reducer
struct PhotoPickerFeature {
    @ObservableState
    struct State: Equatable {
        var imageData: Data?
        var isImagePickerPresented: Bool = false
    }
    
    enum Action: Equatable {
        case setImageData(Data?)
        case toggleImagePicker
        case delegate(Delegate)
        
        enum Delegate: Equatable {
            case photoSelected(Data)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .setImageData(data):
                state.imageData = data
                if let data {
                    return .send(.delegate(.photoSelected(data)))
                }
                return .none
                
            case .toggleImagePicker:
                state.isImagePickerPresented.toggle()
                return .none
                
            case .delegate:
                return .none
            }
        }
    }
}
