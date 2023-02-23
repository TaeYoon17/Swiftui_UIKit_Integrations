//
//  WebView.swift
//  Lottie_Demo
//
//  Created by 김태윤 on 2023/02/23.
//

import Foundation
import SwiftUI
import WebKit
struct WebView: UIViewRepresentable{
    var url:URL?
    typealias UIViewType = WKWebView
    init(url: String) {
        self.url = URL(string: url)
    }
    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView(frame: .zero)
        view.load(URLRequest(url: url ?? URL(string: "https:www.naver.com")!,cachePolicy: .returnCacheDataElseLoad))
        return view
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {
        
    }
    
}

struct MyWebView_Previews: PreviewProvider{
    static var previews: some View{
        WebView(url: "https://www.daum.net")
    }
}
