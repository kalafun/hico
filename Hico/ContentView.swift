//
//  ContentView.swift
//  Hico
//
//  Created by Tomas Bobko on 24.07.24.
//

import SwiftUI
import CoreData

struct ContentView: View {
//    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationView {
            Text("Hello")
                .onAppear {
                    ZipManager.shared.unzipPackage()
                    ZipManager.shared.printExtractedFiles()
                }
        }
    }
}

#Preview {
    ContentView()
}
