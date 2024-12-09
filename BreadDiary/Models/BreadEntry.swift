import Foundation
import Tagged
import ComposableArchitecture

struct BreadEntry: Identifiable, Equatable, Codable {
    let id: UUID
    var name: String
    var isFavorite: Bool
    var date: Date
    let imageURL: URL?
    let rating: Int
    
    init(
        id: UUID = UUID(),
        name: String,
        isFavorite: Bool = false,
        date: Date,
        imageURL: URL? = nil,
        rating: Int
    ) {
        self.id = id
        self.name = name
        self.isFavorite = isFavorite
        self.date = date
        self.imageURL = imageURL
        self.rating = rating
    }
}

struct Entry: Codable, Identifiable, Equatable {
    
    var autolysisTime = ""
    var entryDate = Date.yearMonthDay
    var isFavorite = false
    var rating = Int.zero
    var name = ""
    var sourDoughRiseTime = ""
    var image: Data?
    let id: UUID
    var ingredients: IdentifiedArrayOf<Ingredient> = []
    var bakingTime = ""
    var kneadingProcess = ""
    var sourdoughFeedTime = ""
    var sourdoughFeedTimeDate: Date = .yearMonthDay
    var sourdoughFeedTemperature = ""
    var autolysisStartingTime: Date = .yearMonthDay
    var bulkFermentationStartingTime = ""
    var bulkFermentationTime = ""
    var secondFermentarionTime = ""
    var fridgeTotalTime = ""
    var folds = ""
    var breadFormingTime: Date = .yearMonthDay
    var isFridgeUsed = true
    var isSteelPlateUsed = false
    var isSteamUsed = false
    var crustRating: Int = .zero
    var crumbRating: Int = .zero
    var bloomRating: Int = .zero
    var scoreRating: Int = Int.zero
    var tasteRating: Int = .zero
    var evaluation: Int = .zero
    
    var ingredientsText: String {
        get {
            ingredients.map(\.ingredient).joined(separator: "\n")
        }
        set {
            ingredients = IdentifiedArrayOf(uniqueElements: newValue
                .components(separatedBy: "\n")
                .filter { !$0.isEmpty }
                .map { Ingredient(id: Tagged<Ingredient, UUID>(rawValue: UUID()), ingredient: $0.trimmingCharacters(in: .whitespaces)) }
            )
        }
    }
}

struct Ingredient: Codable, Identifiable, Equatable {
    let id: Tagged<Self, UUID>
    var ingredient = ""
    
  
}

extension Entry {
    static func empty() -> Entry {
        Entry(
            entryDate: Date(),
            isFavorite: false,
            rating: 0,
            name: "",
            id: UUID(),
            ingredients: IdentifiedArrayOf(),
            evaluation: 0
        )
    }
}

extension Entry {
    func toBreadEntry() -> BreadEntry {
        BreadEntry(
            id: self.id,
            name: self.name,
            isFavorite: self.isFavorite,
            date: self.entryDate,
            imageURL: nil,  
            rating: self.evaluation
        )
    }
}

extension BreadEntry {
    func toEntry() -> Entry {
        Entry(
            entryDate: self.date,
            isFavorite: self.isFavorite,
            rating: self.rating,
            name: self.name,
            id: self.id,
            evaluation: self.rating
        )
    }
}

extension BreadEntry {
    static var empty: BreadEntry {
        BreadEntry(
            id: UUID(),
            name: "",
            date: Date(),
            imageURL: nil,
            rating: 0
        )
    }
}
