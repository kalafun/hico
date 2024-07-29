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
                        WebView(fileURL: PackageManager.shared.documentURL(at: selectedNode.language?.path))
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
            selectedNode: .constant(Node.mocked)
        )
    }
}
