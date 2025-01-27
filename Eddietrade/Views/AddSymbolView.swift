//
//  AddSymbolView.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/25/25.
//

import SwiftUI

struct AddSymbolView: View {
    @Environment(\.dismiss) var dismiss
    @State var viewModel: AddSymbolViewModel
    
    init(viewModel: AddSymbolViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            List(viewModel.symbolSearchResultViewModels) { symbol in
                SymbolSearchResultView(viewModel: symbol)
                    .onTapGesture {
                        viewModel.selectedSymbol(symbol) {
                            dismiss()
                        }
                    }
            }
            .searchable(text: $viewModel.searchText, prompt: "Symbol")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
            .navigationTitle("Add Symbol")
        }
    }
}

#Preview {
    AddSymbolView(viewModel: AddSymbolViewModel(watchlist: watchList1))
}
