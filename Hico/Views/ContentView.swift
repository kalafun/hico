//
//  ContentView.swift
//  Hico
//
//  Created by Tomas Bobko on 24.07.24.
//

import SwiftUI
import CoreData
import XMLCoder

struct ContentView: View {
    //    @Environment(\.managedObjectContext) private var viewContext

    @State var content: Content?

    var body: some View {
        NavigationSplitView {
            if let node = content?.navigationStructure.view.node {
                List {
                    nodeContentFor(node: node)
                }
                .navigationTitle(content?.navigationStructure.view.node.language?.title ?? "")
            }
        } content: {
            Text("Content")
        } detail: {
            Text("Detail")
        }
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
                            }
                        }
                    )
                }
            )
        } else {
            AnyView(
                Text("\(node.language?.title ?? "")")
                    .frame(height: 30)
            )
        }
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
