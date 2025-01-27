//
//  AddWatchlistView.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/25/25.
//

import SwiftUI

struct AddWatchlistView: View {
    @Environment(\.dismiss) var dismiss
    @State var viewModel = AddWatchlistViewModel()
    
    var body: some View {
        NavigationView {
            List {
                TextField("Name", text: $viewModel.name)
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        Task {
                            await viewModel.createWatchlist { dismiss() }
                        }
                    } label: {
                        Text("Create")
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
            }
            .alert(model: $viewModel.alert)
            .loadingOverlay(isLoading: Binding(get: {
                viewModel.isLoading
            }, set: { _ in
            }))
            .navigationTitle("Create Watchlist")
        }
    }
}

#Preview {
    AddWatchlistView()
}
