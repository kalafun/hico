//
//  NodeContentListView.swift
//  Hico
//
//  Created by Tomas Bobko on 26.07.24.
//

import SwiftUI

struct NodeContentListView: View {

    let node: Node

    @StateObject var favouritesManager = FavouritesManager.shared
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        nodeContentFor(node: node)
    }

    func nodeContentFor(node: Node) -> some View {
        if let nodes = node.nodes {
            AnyView(
                ForEach(nodes, id: \.id) { node in
                    DisclosureGroup(
                        content: { nodeContentFor(node: node) },
                        label: {
                            listRow(for: node)
                        }
                    )
                }
            )
        } else {
            AnyView(
                NavigationLink(value: node, label: {
                    listRow(for: node)
                })
                .frame(height: 30)
            )
        }
    }

    private func listRow(for node: Node) -> some View {
        HStack(spacing: 0) {
            if let chapterNumber = node.chapterNumber {
                Text(chapterNumber.description + " - ")
            }
            Text((node.language?.title ?? ""))

            Spacer()
            favIndicator(node: node)
        }
    }

    private func favIndicator(node: Node) -> some View {
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
    NavigationStack {
        List {
            NodeContentListView(node: Node.mocked)
        }
    }
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
