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
        NavigationStack {
            NodeView(node: content?.navigationStructure.view.node)
        }
        .onAppear {
            ZipManager.shared.unzipPackage()
            ZipManager.shared.printExtractedFiles()
            parsePackageContent()
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
