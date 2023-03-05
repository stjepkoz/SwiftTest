//
//  ListView.swift
//  SwiftTest
//
//  Created by Stjepko Zrncic on 28/02/23.
//

import SwiftUI

struct ListView: View {
    let products: [Product]
    let error: APIError?
    let isLoading: Bool
    let task: () async -> Void
    
    var body: some View {
        List(products, id: \.id) { product in
            NavigationLink(destination: ProductDetailsView(product: product),
                           label: { ProductsCellView(product: product)})
            .customize()
            
        }
        .listStyle(.plain)
        .task {
            await task()
        }
        .refreshable {
            await task()
        }
        .overlay {
            ListOverlayView(isLoading: isLoading,
                            products: products,
                            error: error)
        }
        .animation(.default,
                   value: products)
        .navigationTitle("Products")
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(products: [], error: nil, isLoading: false, task: {})
    }
}
