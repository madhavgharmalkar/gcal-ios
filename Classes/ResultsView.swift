//
//  ResultsView.swift
//  Gaudiya Calendar
//
//  Created by Madhav Gharmalkar on 10/21/22.
//

import Foundation
import SwiftUI

struct WebView: UIViewRepresentable {
    var html: String

    func makeUIView(context _: Context) -> WKWebView {
        let wb = WKWebView()
        wb.loadHTMLString(html, baseURL: nil)
        return wb
    }

    func updateUIView(_ webView: WKWebView, context _: Context) {
        webView.loadHTMLString(html, baseURL: nil)
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(html: "<h1>hello world!</h1>")
    }
}
