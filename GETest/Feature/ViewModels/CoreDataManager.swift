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
    func fetchSavedBookmarks(for mode: TestMode) -> [Int] {
        let request: NSFetchRequest<BookmarkEntity> = BookmarkEntity.fetchRequest()
        request.includesSubentities = false
        
        
        do {
            let fetchedBookmarks = (try container.viewContext.fetch(request)).filter { $0.mode == mode.rawValue }.compactMap { Int($0.id) }
            return fetchedBookmarks
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fetchSavedProgress(for mode: TestMode) -> [[Int:String]] {
        let request: NSFetchRequest<ProgressEntity> = ProgressEntity.fetchRequest()
        request.includesSubentities = false
        
        
        do {
            let fetchedProgress = (try container.viewContext.fetch(request))
                .filter { $0.mode == mode.rawValue }
                .compactMap { [Int($0.id):String($0.progress ?? "incomplete")] }
            return fetchedProgress
        } catch let error {
            print(error.localizedDescription)
            return [[:]]
        }
    }
    
    func updateBookmarks(for mode: TestMode, id: Int) {
        let request: NSFetchRequest<BookmarkEntity> = BookmarkEntity.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "id == %d", id),
            NSPredicate(format: "mode == %@", mode.rawValue)
        ])
        
        do {
            let bookmarks = try container.viewContext.fetch(request)
            if let bookmark = bookmarks.first {
                container.viewContext.delete(bookmark)
                saveData()
            } else {
                let newBookmark = BookmarkEntity(context: container.viewContext)
                newBookmark.id = Int16(id)
                newBookmark.mode = mode.rawValue
                saveData()
            }
        } catch let error {
            print("Failed to fetch bookmark with id \(id) and mode \(mode): \(error)")
        }
    }
    
    func updateProgress(for mode: TestMode, id: Int, progress: Progress) {
        let request: NSFetchRequest<ProgressEntity> = ProgressEntity.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "id == %d", id),
            NSPredicate(format: "mode == %@", mode.rawValue)
        ])
        
        do {
            let progresses = try container.viewContext.fetch(request)
            if let progressEntity = progresses.first {
                // If there is an entity with the given id, update the progress
                progressEntity.progress = progress.rawValue
                print(progressEntity)
            } else {
                // If there is no such id, create a new entity and set the progress
                let newProgress = ProgressEntity(context: container.viewContext)
                newProgress.id = Int16(id)
                newProgress.mode = mode.rawValue
                newProgress.progress = progress.rawValue
                print(newProgress)

            }
            saveData()
        } catch let error {
            print("Failed to fetch or update progress with id \(id) and mode \(mode): \(error)")
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
