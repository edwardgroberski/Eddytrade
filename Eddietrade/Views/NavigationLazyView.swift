//
//  NavigationLazyView.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/26/25.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
