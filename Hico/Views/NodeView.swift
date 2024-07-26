//
//  NodeView.swift
//  Hico
//
//  Created by Tomas Bobko on 24.07.24.
//

import SwiftUI

struct NodeView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @StateObject var favouritesManager = FavouritesManager.shared
    let node: Node?

    var body: some View {
        if let node = node {
            switch node.type {
                case .manual:
                    return AnyView(
                        Text(node.language?.title ?? "")
                    )
                case .document:
                    return AnyView(
                        WebView(fileURL: ZipManager.shared.documentURL(at: node.language?.path))
                            .navigationTitle(node.language?.title ?? "")
                            .toolbar {
                                ToolbarItem(placement: .topBarTrailing) {
                                    Button {
                                        favouritesManager.toggleFavourites(nodeId: node.id, in: viewContext)
                                    } label: {
                                        favIndicator(node: node)
                                    }
                                }
                            }
                    )
                case .folder:
                    return AnyView(
                        Text("Folder")
                    )
                case .part:
                    return AnyView(
                        Text("Part")
                    )
            }
        } else {
            return AnyView(
                Text("No data to show")
            )
        }
    }

    private func favIndicator(node: Node) -> some View {
        Button {
            print("did Tap node:\(node.language?.title)")
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
        NodeView(
            node: Node(
                id: "id1",
                nodeId: "nodeId1",
                type: .document,
                chapterNumber: nil,
                chapterNumberUsed: nil,
                language: Language(name: "en_US", title: "Duck", path: nil),
                nodes: [
                    Node(
                        id: "id2",
                        nodeId: "nodeId2",
                        type: .part,
                        chapterNumber: "1",
                        chapterNumberUsed: true,
                        language: Language(
                            name: "en_US",
                            title: "Introduction",
                            path: nil
                        ),
                        nodes: [
                            Node(
                                id: "id3",
                                nodeId: "nodeId3",
                                type: .document,
                                chapterNumber: "2",
                                chapterNumberUsed: true,
                                language: Language(
                                    name: "en_US",
                                    title: "Duck Overview",
                                    path: "duck/DUCK.html"
                                ),
                                nodes: nil
                            )
                        ]
                    )
                ]
            )
        )
    }
}
