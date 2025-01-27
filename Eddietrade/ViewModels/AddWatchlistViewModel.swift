//
//  AddWatchlistViewModel.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/25/25.
//

import Foundation
import Dependencies
import SwiftUI

@MainActor
@Observable
class AddWatchlistViewModel {
    var name = ""
    var alert: AlertViewModel?
    var isLoading = false
    
    func createWatchlist(dismiss: () -> Void) async {
        guard !name.isEmpty else {
            showAlert(title: "Watchlist Error", message: "Please enter a name")
            return
        }
        
        defer {
            isLoading = false
        }
        
        isLoading = true
        
        let watchlist = Watchlist(name: name)
        
        do {
            @Dependency(\.watchlistService) var watchlistService
            let _ = try await watchlistService.createWatchlist(watchlist)
            dismiss()
        } catch {
            showAlert(title: "Watchlist Error", message: "Could not create watchlist")
        }
    }
    
    private func showAlert(title: String, message: String) {
        alert = .init(title: title, message: message)
    }
}
