//
//  View+AlertViewModel.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/24/25.
//

import SwiftUI

struct AlertViewModel {
    let title: String
    let message: String
}

extension View {
    func alert(model: Binding<AlertViewModel?>) -> some View {
        alert(
            Text(model.wrappedValue?.title ?? ""),
            isPresented: model.whenNotNil(),
            presenting: model.wrappedValue)
        { _ in
        } message: { model in
            Text(model.message)
        }
    }
}
