//
//  NodeView.swift
//  Hico
//
//  Created by Tomas Bobko on 24.07.24.
//

import SwiftUI

struct NodeView: View {

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
}

#Preview {
    NavigationStack {
        NodeView(
            node: Node(
                id: "id1",
                nodeId: "nodeId1",
                type: .manual,
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
