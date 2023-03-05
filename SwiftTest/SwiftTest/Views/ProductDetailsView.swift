//
//  ProductDetailsView.swift
//  SwiftTest
//
//  Created by Stjepko Zrncic on 26/02/23.
//

import SwiftUI

struct ProductDetailsView: View {
    let product: Product
    
    var body: some View {
        HStack() {
            VStack(alignment: .leading) {
                AsyncImageView(url: product.thumbnail)
                    //.background(Color.red)
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 200)
                Text(product.title)
                    .font(.system(size: 36))
                Text(product.brand)
                Text(product.description)
                Text("Category: \(product.category)")
                Text("Rating: \(product.rating)")
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            Spacer()
        }
          
    }
}

struct ProductDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailsView(product: ProductModelMock.dummy)
    }
}
