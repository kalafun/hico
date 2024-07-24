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

    var body: some View {
        NavigationView {
            Text("Hello")
                .onAppear {
                    ZipManager.shared.unzipPackage()
                    ZipManager.shared.printExtractedFiles()

                    do {
                        let data = try Data(contentsOf: ZipManager.shared.structureURL)
                        let content = try XMLDecoder().decode(Structure.self, from: data)
                        print(content)
                    } catch {
                        print("error getting data representation from structure.xml")
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
