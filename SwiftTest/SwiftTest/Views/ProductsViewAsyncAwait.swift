//
//  ContentView.swift
//  SwiftTest
//
//  Created by Stjepko Zrncic on 19/02/23.
//

import SwiftUI

struct ProductsViewAsyncAwait: View {
    @StateObject private var vm = ProductsStoreAsyncAwait()
    var randomError: Bool
    
    var body: some View {
        ListView(products: vm.products,
                 error: vm.error,
                 isLoading: vm.loading) {
            await vm.fetchProductsAsync(randomError: randomError)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsViewAsyncAwait(randomError: false)
    }
}

class ProductsStoreAsyncAwait: ObservableObject {
    @Published var products = [Product]()
    @Published var loading = true
    @Published var error: APIError?
    
    private let apiClient = APIClient()
    
    @MainActor
    func fetchProductsAsync(randomError: Bool) async {
        loading = true
        error = nil
        do {
            var urlString: String {
                if randomError && Bool.random() {
                    return "https://dummyjson.com/products1111"
                } else {
                    return "https://dummyjson.com/products"
                }
            }
            products = try await apiClient.get(url: urlString, type: Products.self).products
        } catch {
            self.error = error as? APIError
            products = []
        }
        loading = false
    }
}
