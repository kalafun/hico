//
//  Structure.swift
//  Hico
//
//  Created by Tomas Bobko on 24.07.24.
//

struct Structure: Decodable {
    let content: Content
}

struct Content: Decodable {
    let navigationStructure: NavigationStructure

    enum CodingKeys: String, CodingKey {
        case navigationStructure = "navigationstructure"
    }
}

struct NavigationStructure: Decodable {
    let id: String
    let name: String
    let version: String
    let view: ViewItem

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case version
        case view
    }
}

struct ViewItem: Decodable {
    let name: String
    let type: String
    let node: Node

    enum CodingKeys: String, CodingKey {
        case name
        case type
        case node
    }
}

struct Node: Decodable {

    let id: String
    let nodeId: String
    let type: NodeType
    let chapterNumber: String?
    let chapterNumberUsed: Bool?
    let language: Language?
    let nodes: [Node]? // Optional to handle nested nodes

    enum CodingKeys: String, CodingKey {
        case id
        case nodeId = "node_id"
        case type
        case chapterNumber = "chapternumber"
        case chapterNumberUsed = "chapternumberused"
        case language
        case nodes = "node"
    }
}

extension Node {
    
    static var mocked: Node {
        Node(
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
        )

    }
}

extension Node: Equatable, Hashable {
    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Language: Decodable {
    let name: String
    let title: String
    let path: String?

    enum CodingKeys: String, CodingKey {
        case name
        case title
        case path
    }
}

enum NodeType: String, Decodable {
    case manual
    case part
    case document
    case folder
}
