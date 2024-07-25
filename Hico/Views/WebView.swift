//
//  WebView.swift
//  Hico
//
//  Created by Tomas Bobko on 24.07.24.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {

    let fileURL: URL?

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let fileURL = fileURL else { return }
        guard let htmlString = try? String(contentsOf: fileURL, encoding: .utf8) else { return }
        webView.loadHTMLString(htmlString, baseURL: fileURL)
    }
}

#Preview {
    WebView(fileURL: nil)
}
