//
//  NodeView.swift
//  Hico
//
//  Created by Tomas Bobko on 24.07.24.
//

import SwiftUI

struct NodeView: View {

    @State var node: Node

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .navigationTitle(node.language?.title ?? "")
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
