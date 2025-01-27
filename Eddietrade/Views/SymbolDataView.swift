//
//  SymbolDataView.swift
//  Eddietrade
//
//  Created by Edward Groberski on 1/26/25.
//

import SwiftUI

struct SymbolDataView: View {
    @State var viewModel: SymbolDataViewModel
    
    init(viewModel: SymbolDataViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Text(viewModel.symbol)
                .font(.title2)
            
            Spacer()
            VStack(alignment: .leading) {
                Text("Bid Price: $\(viewModel.bidPrice)")
                Text("Ask Price: $\(viewModel.askPrice)")
                Text("Last Price: $\(viewModel.lastPrice)")
            }
        }
        .padding(8)
        .task {
            viewModel.pollMarketData()
        }
        .onDisappear {
            viewModel.cancelPollMarketData()
        }
    }
}

#Preview {
    SymbolDataView(viewModel: SymbolDataViewModel(symbol: "AA"))
}
