//
//  ContentView.swift
//  Lottie_Demo
//
//  Created by 김태윤 on 2023/02/23.
//


import SwiftUI
// transition vs transaction
struct ContentView: View {
    @State private var isAppear = false
    var body: some View {
        ZStack{
            mainView
            lottieView
        }
    }
    var mainView:some View{
        ZStack{
            Rectangle()
                .fill(.blue)
                .frame(width: 300,height: 300)
            MetalView().edgesIgnoringSafeArea(.all)
        }
        .padding()
    }
    var lottieView:some View{
        ZStack{
            if isAppear{
                WebView(url: "https://www.naver.com")
                    .animation(.easeInOut,value: isAppear)
            }else{
                HStack{
                    LottieView().transition(.opacity).padding()
                }
            }
        }
        .onAppear(){
            DispatchQueue.main.asyncAfter(deadline: .now()+1.25) {
                withAnimation() {
                    isAppear.toggle()
                }
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
