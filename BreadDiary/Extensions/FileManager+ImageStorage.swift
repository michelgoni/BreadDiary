import Foundation

extension FileManager {
    static let imagesDirectoryName = "BreadImages"
    
    static func imagesDirectory() -> URL {
        let directory = documentsDirectory().appendingPathComponent(imagesDirectoryName)
        if !FileManager.default.fileExists(atPath: directory.path) {
            try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        }
        return directory
    }
    
    static func saveImage(_ imageData: Data, for id: UUID) -> URL? {
        let imageURL = imagesDirectory().appendingPathComponent("\(id.uuidString).jpg")
        do {
            try imageData.write(to: imageURL)
            return imageURL
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
    
    static func loadImage(from url: URL) -> Data? {
        try? Data(contentsOf: url)
    }
    
    static func deleteImage(at url: URL) {
        try? FileManager.default.removeItem(at: url)
    }
}
