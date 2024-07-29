//
//  ListRow.swift
//  Hico
//
//  Created by Tomas Bobko on 29.07.24.
//

import SwiftUI

struct ListRow: View {

    let node: Node

    var body: some View {
        HStack(spacing: 0) {
            if let chapterNumber = node.chapterNumber {
                Text(chapterNumber.description + " - ")
            }
            Text((node.language?.title ?? ""))

            Spacer()
            FavIndicator(node: node)
        }
    }
}

#Preview {
    ListRow(node: Node.mocked)
}
