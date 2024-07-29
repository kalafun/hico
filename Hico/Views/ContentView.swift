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
                        ListRow(node: node)
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
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
