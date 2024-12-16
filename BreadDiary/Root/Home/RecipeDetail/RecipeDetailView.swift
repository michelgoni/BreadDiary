import SwiftUI
import PhotosUI
import ComposableArchitecture
import UIKit

struct RecipeDetailView: View {
    let store: StoreOf<RecipeDetailFeature>
    @Environment(\.dismiss) private var dismiss
    
    private var isSaveEnabled: Bool {
        !store.entry.name.isEmpty && store.entry.entryDate <= Date()
    }
    
    var body: some View {
        Form {
            BasicInfoSectionView(store: store)
            Section(header: Text("Ingredientes")) {
                TextEditor(text: .init(
                    get: { store.entry.ingredientsText },
                    set: { store.send(.setIngredients($0)) }
                ))
                .frame(minHeight: 50)
            }
            ProcessSectionView(store: store)
            RatingsSectionView(store: store)
            photoSection
            
            if store.mode == .edit {
                Section {
                    Button(role: .destructive) {
                        store.send(.deleteButtonTapped)
                    } label: {
                        HStack {
                            Spacer()
                            Text("Delete Recipe")
                                .foregroundStyle(.red)
                            Spacer()
                        }
                    }
                }
            }
            
            Section {
                Button(action: {
                    store.send(.saveNewEntry)
                    dismiss()
                }) {
                    Text("Save recipe")
                        .frame(maxWidth: .infinity)
                        .font(.headline)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                .disabled(!isSaveEnabled)
                .opacity(isSaveEnabled ? 1 : 0.6)
            }
        }
        .navigationTitle(store.mode == .create ? "New Recipe" : "Edit Recipe")
        .onChange(of: store.delegate) { _, delegate in
            if let delegate {
                switch delegate {
                case .didSave, .didDelete:
                    dismiss()
                }
            }
        }
        .alert(
            "Delete Recipe",
            isPresented: .init(
                get: { store.isShowingDeleteConfirmation },
                set: { isPresented in
                    store.send(isPresented ? .deleteButtonTapped : .dismissDeletion)
                }
            ),
            actions: {
                Button("Delete", role: .destructive) {
                    store.send(.confirmDeletion)
                }
                Button("Cancel", role: .cancel) {
                    store.send(.dismissDeletion)
                }
            },
            message: {
                Text("Are you sure you want to delete this recipe?")
            }
        )
        .navigationBarTitleDisplayMode(.inline)
        .sheet(
            store: store.scope(
                state: \.$destination,
                action: \.destination
            ),
            state: \.datePicker,
            action: RecipeDetailFeature.Destination.Action.datePicker
        ) { store in
            DatePickerView(store: store)
        }
        .sheet(
            store: store.scope(
                state: \.$destination,
                action: \.destination
            ),
            state: \.photoPicker,
            action: RecipeDetailFeature.Destination.Action.photoPicker
        ) { store in
            PhotoPickerView(store: store)
        }
    }
    
    private var photoSection: some View {
        Section("Photo") {
            if let imageData = store.entry.image,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 200)
            }
            Button("Add Photo") {
                store.send(.photoButtonTapped)
            }
        }
    }
}


struct DatePickerView: View {
    let store: StoreOf<DatePickerFeature>
    
    var body: some View {
        NavigationView {
            DatePicker(
                "Select Time",
                selection: .init(
                    get: { store.date },
                    set: { store.send(.dateChanged($0)) }
                ),
                displayedComponents: [.hourAndMinute]
            )
            .datePickerStyle(.wheel)
            .navigationBarItems(
                trailing: Button("Done") {
                    store.send(.doneButtonTapped)
                }
            )
            .padding()
        }
    }
}

struct PhotoPickerView: View {
    let store: StoreOf<PhotoPickerFeature>
    
    var body: some View {
        PhotosPicker(
            selection: .init(
                get: { nil },
                set: { item in
                    Task {
                        guard let item = item else { return }
                        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
                        store.send(.setImageData(data))
                    }
                }
            ),
            matching: .images
        ) {
            Text("Select Photo")
        }
    }
}

#Preview("Create Mode") {
    NavigationStack {
        RecipeDetailView(
            store: Store(
                initialState: RecipeDetailFeature.State(
                    mode: .create,
                    entry: Entry.empty()
                )
            ) {
                RecipeDetailFeature()
            }
        )
    }
}

#Preview("Edit Mode - Enabled Save") {
    NavigationStack {
        RecipeDetailView(
            store: Store(
                initialState: RecipeDetailFeature.State(
                    mode: .edit,
                    entry: Entry(
                        name: "Pan de centeno",
                        id: UUID()
                    )
                )
            ) {
                RecipeDetailFeature()
            }
        )
    }
}

#Preview("Edit Mode - Save not enabled") {
    NavigationStack {
        RecipeDetailView(
            store: Store(
                initialState: RecipeDetailFeature.State(
                    mode: .edit,
                    entry: Entry(
                        id: UUID()
                    )
                )
            ) {
                RecipeDetailFeature()
            }
        )
    }
}
