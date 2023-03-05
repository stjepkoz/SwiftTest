//
//  ProductsViewCombine.swift
//  SwiftTest
//
//  Created by Stjepko Zrncic on 26/02/23.
//

import SwiftUI
import Combine

struct ProductsViewCombine: View {
    @StateObject private var vm = ProductsStoreCombine()
    var randomError: Bool
    
    var body: some View {
        ListView(products: vm.products,
                 error: vm.error,
                 isLoading: vm.loading) {
            vm.fetchProducts(randomError: randomError)
        }
    }
}

struct ProductsViewCombine_Previews: PreviewProvider {
    static var previews: some View {
        ProductsViewCombine(randomError: false)
    }
}

class ProductsStoreCombine: ObservableObject {
    @Published var products = [Product]()
    @Published var loading = true
    @Published var error: APIError?
    
    private let apiClient = APIClient()
    private var subscription: AnyCancellable?
    
    func fetchProducts(randomError: Bool) {
        var urlString: String {
            if randomError && Bool.random() {
                return "https://dummyjson.com/products1111"
            } else {
                return "https://dummyjson.com/products"
            }
        }
        loading = true
        error = nil
        subscription = apiClient.getPublisher(url: urlString, type: Products.self)
            .sink { [weak self] completion in
                self?.loading = false
                switch completion {
                case .failure(let error):
                    print(error)
                    self?.error = error as? APIError
                    self?.products = []
                case .finished: break
                }
            } receiveValue: {[weak self] productsObject  in
                self?.products = productsObject.products
            }
        
    }
}
