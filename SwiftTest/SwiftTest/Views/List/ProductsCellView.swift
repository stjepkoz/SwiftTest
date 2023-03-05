//
//  ProductsCellView.swift
//  SwiftTest
//
//  Created by Stjepko Zrncic on 26/02/23.
//

import SwiftUI

struct ProductsCellView: View {
    let product: Product
    
    var body: some View {
        HStack() {
            AsyncImageView(url: product.thumbnail)
                .scaledToFit()
                .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                Text(product.title)
                Text("$\(product.price, specifier: "%.2f")")
            }
            Spacer()
            Text("Rating: \(product.rating, specifier: "%.2f")")
        }
    }
}

struct ProductsCellView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsCellView(product: ProductModelMock.dummy)
    }
}
