//
//  NavigationLink+Customize.swift
//  SwiftTest
//
//  Created by Stjepko Zrncic on 26/02/23.
//

import Foundation
import SwiftUI

extension NavigationLink {
    public func customize() -> some View {
        return self
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)).listRowSeparator(.hidden)
            .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
            .background(Color.gray)
            .cornerRadius(5)
    }
}
