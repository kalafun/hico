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
                            ListRow(node: node)
                        }
                    )
                }
            )
        } else {
            AnyView(
                NavigationLink(value: node, label: {
                    ListRow(node: node)
                })
                .frame(height: 30)
            )
        }
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
