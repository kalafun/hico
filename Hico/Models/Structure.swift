//
//  Structure.swift
//  Hico
//
//  Created by Tomas Bobko on 24.07.24.
//

import Foundation

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
    let type: String
    let chapterNumber: String?
    let chapterNumberUsed: Bool?
    let language: Language
    let nodes: [Node]?

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
