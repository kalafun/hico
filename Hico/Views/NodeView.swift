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
    @Binding var selectedNode: Node?

    var body: some View {
        Group {
            if let selectedNode = selectedNode {
                switch selectedNode.type {
                    case .manual:
                        Text(selectedNode.language?.title ?? "")
                    case .document:
                        WebView(fileURL: ZipManager.shared.documentURL(at: selectedNode.language?.path))
                            .navigationTitle(selectedNode.language?.title ?? "")
                            .toolbar {
                                ToolbarItem(placement: .topBarTrailing) {
                                    Button {
                                        favouritesManager.toggleFavourites(nodeId: selectedNode.id, in: viewContext)
                                    } label: {
                                        favIndicator(node: selectedNode)
                                    }
                                }
                            }
                    case .part, .folder:
                        List(selection: $selectedNode) {
                            NodeContentListView(node: selectedNode)
                        }
                        .padding(.top, 60)
                        .navigationTitle(selectedNode.language?.title ?? "")
                        .toolbarTitleDisplayMode(.inline)
                }
            }
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
        NodeView(
            selectedNode: .constant(Node(
                id: "id1",
                nodeId: "nodeId1",
                type: .part,
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
            ))
        )
    }
}
