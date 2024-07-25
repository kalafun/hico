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
    //    @Environment(\.managedObjectContext) private var viewContext

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

                if let node = content?.navigationStructure.view.node {
                    List(selection: $selectedNode) {
                        nodeContentFor(node: node)
                    }
                    .navigationTitle(content?.navigationStructure.view.node.language?.title ?? "")

                }
            }
        } detail: {
            NodeView(node: selectedNode)
                .ignoresSafeArea()
        }
        .navigationSplitViewStyle(.balanced)
        .onAppear {
            ZipManager.shared.unzipPackage()
            ZipManager.shared.printExtractedFiles()
            parsePackageContent()
        }
    }

    func nodeContentFor(node: Node) -> some View {
        if let nodes = node.nodes {
            AnyView(
                ForEach(nodes, id: \.id) { node in
                    DisclosureGroup(
                        content: { nodeContentFor(node: node) },
                        label: {
                            HStack(spacing: 0) {
                                if let chapterNumber = node.chapterNumber {
                                    Text(chapterNumber.description + " - ")
                                }
                                Text((node.language?.title ?? ""))

                                Spacer()
                                favIndicator(node: node)
                            }
                        }
                    )
                }
            )
        } else {
            AnyView(
                NavigationLink(value: node, label: {
                    HStack(spacing: 0) {
                        Text("\(node.language?.title ?? "")")

                        Spacer()
                        favIndicator(node: node)
                    }
                })
                .frame(height: 30)
            )
        }
    }

    private func favIndicator(node: Node) -> some View {
        Button {
            print("did Tap node:\(node.language?.title)")
        } label: {
            // TODO: Show filled heart when the content is favourited
            Image(systemName: "heart")
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func parsePackageContent() {
        do {
            let data = try Data(contentsOf: ZipManager.shared.structureURL)
            let structure = try XMLDecoder().decode(Structure.self, from: data)
            self.content = structure.content
            print(content!)
        } catch {
            print("error getting data representation from structure.xml")
        }
    }
}

#Preview {
    ContentView()
}
