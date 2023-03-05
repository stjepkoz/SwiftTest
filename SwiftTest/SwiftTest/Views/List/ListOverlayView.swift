//
//  ListOverlay.swift
//  SwiftTest
//
//  Created by Stjepko Zrncic on 28/02/23.
//

import SwiftUI

struct ListOverlayView: View {
    let isLoading: Bool
    let products: [Product]
    let error: APIError?
    
    var body: some View {
        Group {
            if isLoading && products.isEmpty {
                ProgressView("Fetching data, please wait...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
            }
            if let error = error {
                Text(error.localizedDescription)
            }
        }
    }
}

struct ListOverlay_Previews: PreviewProvider {
    static var previews: some View {
        ListOverlayView(isLoading: true, products: [], error: nil)
    }
}
