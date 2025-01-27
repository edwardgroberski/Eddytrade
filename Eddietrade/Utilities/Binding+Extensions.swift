//
//  Binding+Extensions.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/24/25.
//

import SwiftUI

extension Binding where Value == Bool {
    init(mappedTo bindingToOptional: Binding<(some Sendable)?>) {
        self.init {
            bindingToOptional.wrappedValue != nil
        } set: { newValue, transaction in
            withTransaction(transaction) {
                if !newValue {
                    bindingToOptional.wrappedValue = nil
                }
            }
        }
    }
}

extension Binding {
    func whenNotNil<Wrapped: Sendable>() -> Binding<Bool> where Value == Wrapped? {
        Binding<Bool>(mappedTo: self)
    }
}
