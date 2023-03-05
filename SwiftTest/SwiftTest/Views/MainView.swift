//
//  MainView.swift
//  SwiftTest
//
//  Created by Stjepko Zrncic on 26/02/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            TabView {
                ProductsViewAsyncAwait(randomError: false)
                    .tabItem {
                        Label("Async/Await", systemImage: "1.circle.fill")
                    }
                
                ProductsViewAsyncAwait(randomError: true)
                    .tabItem {
                        Label("Async/Await error", systemImage: "2.circle.fill")
                    }
                ProductsViewCombine(randomError: false)
                    .tabItem {
                        Label("Combine", systemImage: "3.circle.fill")
                    }
                ProductsViewCombine(randomError: true)
                    .tabItem {
                        Label("Combine error", systemImage: "4.circle.fill")
                    }
            }.navigationTitle("Products")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
