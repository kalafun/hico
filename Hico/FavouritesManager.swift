//
//  FavouritesController.swift
//  Hico
//
//  Created by Tomas Bobko on 26.07.24.
//

import CoreData
import SwiftUI

@MainActor
class FavouritesManager: ObservableObject {

    static let shared = FavouritesManager()

    private init() { }

    @Published private(set) var favoriteNodes: [String] = []

    func loadFavorites(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<CDNode> = CDNode.fetchRequest()

        do {
            let results = try context.fetch(fetchRequest)
            self.favoriteNodes = results.map { $0.id ?? "" }
        } catch {
            print("Failed to fetch favorite nodes: \(error)")
        }
    }

    func toggleFavourites(nodeId: String, in context: NSManagedObjectContext) {
        if nodeIsInfavourites(nodeId: nodeId, in: context) {
            if let cdNode = getNode(by: nodeId, context: context) {
                removeFromFavourites(node: cdNode, context: context)
            } else {
                print("Node with Id not found, can't delete it")
            }
        } else {
            addItemToFavourites(nodeId: nodeId, in: context)
        }
    }

    func addItemToFavourites(nodeId: String, in context: NSManagedObjectContext) {
        withAnimation {
            let newItem = CDNode(context: context)
            newItem.createdAt = Date()
            newItem.id = nodeId

            do {
                try context.save()
                loadFavorites(context: context)
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    func removeFromFavourites(node: CDNode, context: NSManagedObjectContext) {
        context.delete(node)

        do {
            try context.save()
            loadFavorites(context: context)
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    func getNode(by nodeId: String, context: NSManagedObjectContext) -> CDNode? {
        let fetchRequest: NSFetchRequest<CDNode> = CDNode.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", nodeId)
        fetchRequest.fetchLimit = 1

        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error fetching node: \(error)")
            return nil
        }
    }

    func nodeIsInfavourites(nodeId: String, in context: NSManagedObjectContext) -> Bool {
        favoriteNodes.contains(nodeId)
    }
}
