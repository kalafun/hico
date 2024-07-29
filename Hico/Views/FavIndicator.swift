//
//  FavIndicator.swift
//  Hico
//
//  Created by Tomas Bobko on 29.07.24.
//

import SwiftUI

struct FavIndicator: View {

    let node: Node

    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var favouritesManager = FavouritesManager.shared

    var body: some View {
        Button {
            favouritesManager.toggleFavourites(nodeId: node.nodeId, in: viewContext)
        } label: {
            if favouritesManager.nodeIsInfavourites(nodeId: node.nodeId, in: viewContext) {
                Image(systemName: "heart.fill")
            } else {
                Image(systemName: "heart")
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FavIndicator(node: Node.mocked)
}
