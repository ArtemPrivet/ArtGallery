//
//  CoreDataManager.swift
//  ArtGallery
//
//  Created by Artem Orlov on 23.01.24.
//

import CoreData
import Domain

final class CoreDataManager: NSObject {

    static let shared = CoreDataManager()

    private override init() {
        super.init()
    }

    lazy var mainContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()

    lazy var persistentContainer: NSPersistentContainer = {

            let container = NSPersistentContainer(name: "ArtGalleryCore")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {

                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()

    func newFetchRequest<T: NSManagedObject>(entityType: T.Type, context: NSManagedObjectContext,
                                                    predicate: String? = nil,
                                                    fetchLimit: Int? = nil,
                                                    args: [Any]? = nil) -> NSFetchRequest<T> {
        let fetchRequest = entityType.fetchRequest() as! NSFetchRequest<T>
        if let predicate = predicate {
            fetchRequest.predicate = NSPredicate(format: predicate, argumentArray: args)
        }

        if let fetchLimit = fetchLimit {
            fetchRequest.fetchLimit = fetchLimit
        }

        return fetchRequest
    }

    func saveArtworks(_ artworks: [ArtworkModel], context: NSManagedObjectContext) {
        for artwork in artworks {
            let dataModel = ArtworkDataModel(context: context)
            dataModel.id = Int64(artwork.id)
            dataModel.title = artwork.title
            dataModel.imageID = artwork.imageID
            if let artistID = artwork.artistID {
                dataModel.artistID = Int64(artistID)
            }
            if let thumbnailWidth = artwork.thumbnail?.width, let thumbnailHeight = artwork.thumbnail?.height {
                let thumbnailEntity = ImageSizeDataModel(context: context)
                thumbnailEntity.width = Int16(thumbnailWidth)
                thumbnailEntity.height = Int16(thumbnailHeight)

                dataModel.thumbnail = thumbnailEntity
            }

            do {
                try context.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }

    func fetchArtworks(context: NSManagedObjectContext, completion: ([ArtworkDataModel]?) -> Void) {
        context.performAndWait {
            let request = newFetchRequest(entityType: ArtworkDataModel.self, context: context)
            let artworks = try? context.fetch(request)
            completion(artworks)
        }
    }
}
