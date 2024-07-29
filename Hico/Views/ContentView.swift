//
//  ContentView.swift
//  Hico
//
//  Created by Tomas Bobko on 24.07.24.
//

import SwiftUI
import CoreData

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
                pickerView

                if pickerSelection == .content {
                    contentList
                } else if pickerSelection == .favourites {
                    favouritesList
                }
            }
        } detail: {
            NodeView(selectedNode: $selectedNode)
                .ignoresSafeArea(edges: .bottom)
        }
        .navigationSplitViewStyle(.balanced)
        .onAppear {
            PackageManager.shared.unzipPackage()
            PackageManager.shared.printExtractedFiles()
            self.content = PackageManager.shared.parsePackageContent()
            favouritesManager.loadFavorites(context: viewContext)
        }
    }

    private var contentList: some View {
        List(selection: $selectedNode) {
            if let node = content?.navigationStructure.view.node {
                NodeContentListView(node: node)
            }
        }
        .navigationTitle(content?.navigationStructure.view.node.language?.title ?? "")
    }

    private var favouritesList: some View {
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

    private var pickerView: some View {
        Picker(selection: $pickerSelection) {
            Text("Content").tag(PickerSelection.content)
            Text("Favourites").tag(PickerSelection.favourites)
        } label: {
            Text("Pick between navigation and Favourites")
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
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
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
