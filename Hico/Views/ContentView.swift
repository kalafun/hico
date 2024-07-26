//
//  ContentView.swift
//  Hico
//
//  Created by Tomas Bobko on 24.07.24.
//

import SwiftUI
import CoreData
import XMLCoder

enum PickerSelection {
    case content, favourites
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @StateObject var favouritesManager = FavouritesManager.shared

    @State var content: Content?
    @State var selectedNode: Node?
    @State var pickerSelection = PickerSelection.content

    var body: some View {
        NavigationSplitView {
            VStack {
                Picker(selection: $pickerSelection) {
                    Text("Content").tag(PickerSelection.content)
                    Text("Favourites").tag(PickerSelection.favourites)
                } label: {
                    Text("Pick between navigation and Favourites")
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                if pickerSelection == .content {
                    if let node = content?.navigationStructure.view.node {
                        List(selection: $selectedNode) {
                            NodeContentListView(node: node)
                        }
                        .navigationTitle(content?.navigationStructure.view.node.language?.title ?? "")
                    }
                } else if pickerSelection == .favourites {
                    List(selection: $selectedNode) {
                        if let content = content {
                            let favouriteNodes = favouritesManager.getFavoriteNodesDetails(from: content)
                            ForEach(favouriteNodes, id: \.id) { node in
                                NavigationLink(value: node) {
                                    listRow(for: node)
                                }
                            }
                        }
                    }
                    .navigationTitle("Favourites")
                }
            }
        } detail: {
            NodeView(node: selectedNode, selectedNode: $selectedNode)
                .ignoresSafeArea()
        }
        .navigationSplitViewStyle(.balanced)
        .onAppear {
            ZipManager.shared.unzipPackage()
            ZipManager.shared.printExtractedFiles()
            parsePackageContent()
            favouritesManager.loadFavorites(context: viewContext)
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

    private func parsePackageContent() {
        do {
            let data = try Data(contentsOf: ZipManager.shared.structureURL)
            let structure = try XMLDecoder().decode(Structure.self, from: data)
            self.content = structure.content
            print(content ?? "Content nil")
        } catch {
            print("error getting data representation from structure.xml")
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

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
