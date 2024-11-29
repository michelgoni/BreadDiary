//
//  ProcessSectionView.swift
//  MyBreadTCADiary
//
//  Created by Michel Goñi on 21/11/24.
//

import ComposableArchitecture
import SwiftUI

struct ProcessSectionView: View {
    let store: StoreOf<RecipeDetailFeature>
    
    var body: some View {
        Section("Process") {
            HStack {
                TextField(
                    "Temperatura ambiente",
                    text: .init(
                        get: { store.entry.sourdoughFeedTemperature },
                        set: { store.send(.sourDoughFeedtemperature($0)) }
                    )
                )
            }
            
            DatePicker(
                "Sour Dough Refreshed",
                selection: .init(
                    get: { store.entry.sourdoughFeedTimeDate },
                    set: { store.send(.timeFieldChanged(.motherDoughRefreshed, $0)) }
                ),
                displayedComponents: [.hourAndMinute]
            )
            
            TextField(
                "Tiempo refresco masa madre",
                text: .init(
                    get: { store.entry.sourDoughRiseTime },
                    set: { store.send(.sourDoughRiseTimeChanged($0)) }
                )
            )
            
            TextField(
                "Tiempo autólisis",
                text: .init(
                    get: { store.entry.autolysisTime },
                    set: { store.send(.autolysisTimeChanged($0)) }
                )
            )
            
            TextField(
                "Fermentación en bloque",
                text: .init(
                    get: { store.entry.bulkFermentationTime },
                    set: { store.send(.bulkFermentationTimeChanged($0)) }
                )
            )
            
            TextField(
                "Describe el amasado",
                text: .init(
                    get: { store.entry.kneadingProcess },
                    set: { store.send(.kneadingDescriptionChanged($0)) }
                )
            )
            
            Stepper("Folds: \(store.entry.folds)", value: .init(
                get: { Int(store.entry.folds) ?? 0 },
                set: { store.send(.foldsChanged(String($0))) }
            ), in: 0...Int.max)
            
            TextField(
                "Segunda fermentación",
                text: .init(
                    get: { store.entry.secondFermentarionTime },
                    set: { store.send(.secondFermentationTimeChanged($0)) }
                )
            )
            
            TextField(
                "Describe el horneado",
                text: .init(
                    get: { store.entry.bakingTime },
                    set: { store.send(.bakingTimeChanged($0)) }
                )
            )
            
            Toggle("Has usado vapor?",
                   isOn: .init(
                    get: { store.entry.isSteamUsed },
                    set: { store.send(.steamUsedModified($0)) }
                   )
            )
        }
    }
}

