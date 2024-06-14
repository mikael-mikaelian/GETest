//
//  CoreDataManager.swift
//  GETest
//
//  Created by Mikael Mikaelian on 5/15/24.
//

import Foundation
import CoreData

class CoreDataManager {
    // MARK: - Properties
    let container: NSPersistentContainer
    
    // MARK: - Initializer
    init() {
        container = NSPersistentContainer (name: "UserModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - CoreData Methods
    func fetchSavedBookmarks(for mode: TestMode) -> [String] {
        let request: NSFetchRequest<BookmarkEntity> = BookmarkEntity.fetchRequest()
        request.includesSubentities = false
        
        
        do {
            let fetchedBookmarks = (try container.viewContext.fetch(request)).filter { $0.mode == mode.rawValue }.compactMap { $0.id }
            return fetchedBookmarks
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fetchSavedProgress(for mode: TestMode) -> [(String, Progress)] {
        let request: NSFetchRequest<ProgressEntity> = ProgressEntity.fetchRequest()
        request.includesSubentities = false

        do {
            let fetchedProgress: [(String, Progress)] = (try container.viewContext.fetch(request))
                .filter { $0.mode == mode.rawValue }
                .compactMap({ ($0.id, Progress(rawValue: $0.progress ?? "incomplete")) as? (String, Progress) })
                .compactMap({ ($0.0, $0.1) })
            return fetchedProgress
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }


    
    func updateBookmarks(for mode: TestMode, id: String) {
        let request: NSFetchRequest<BookmarkEntity> = BookmarkEntity.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "id == %@", id),
            NSPredicate(format: "mode == %@", mode.rawValue)
        ])
        
        do {
            let bookmarks = try container.viewContext.fetch(request)
            if let bookmark = bookmarks.first {
                container.viewContext.delete(bookmark)
                saveData()
            } else {
                let newBookmark = BookmarkEntity(context: container.viewContext)
                newBookmark.id = id
                newBookmark.mode = mode.rawValue
                saveData()
            }
        } catch let error {
            print("Failed to fetch bookmark with id \(id) and mode \(mode): \(error.localizedDescription)")
        }
    }
    
    func updateProgress(for mode: TestMode, key:(String, Progress)) {
        let request: NSFetchRequest<ProgressEntity> = ProgressEntity.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "id == %@", key.0),
            NSPredicate(format: "mode == %@", mode.rawValue)
        ])

        
        do {
            let progresses = try container.viewContext.fetch(request)
            if let progressEntity = progresses.first {
                // If there is an entity with the given id, update the progress
                progressEntity.progress = key.1.rawValue
                print(progressEntity)
            } else {
                // If there is no such id, create a new entity and set the progress
                let newProgress = ProgressEntity(context: container.viewContext)
                newProgress.id = key.0
                newProgress.mode = mode.rawValue
                newProgress.progress = key.1.rawValue
                print(newProgress)

            }
            saveData()
        } catch let error {
            print("Failed to fetch or update progress with id \(key.0) and mode \(mode): \(error.localizedDescription)")
        }
    }


    
    func saveData() {
        do {
            try container.viewContext.save()
            print("data saved")
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
