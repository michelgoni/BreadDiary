import Foundation

extension FileManager {
    static let breadEntriesFileName = "breadEntries.json"
    
    static func documentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    static func breadEntriesFileURL() -> URL {
        documentsDirectory().appendingPathComponent(breadEntriesFileName)
    }
} 