//
//  ProductListView.swift
//  SKBTransactionViewer
//
//  Created by Dmitry Mikhailov on 23.10.2024.
//

import SwiftUI

// MARK: - ProductModel

struct ProductModel: Identifiable {
  let id = UUID()
  let sku: String
  let transactions: [Transaction]
}

// MARK: - ProductListView

struct ProductListView: View {
  @ObservedObject var viewModel: ProductListViewModel
  let coordinator: AppCoordinator

  var body: some View {
    List(viewModel.products, id: \.sku) { product in
      NavigationLink(
        destination: coordinator.makeTransactionDetailView(sku: product.sku, transactions: product.transactions)
      ) {
        HStack {
          Text(product.sku)
            .font(.headline)
          Spacer()
          Text("\(product.transactions.endIndex) transactions")
            .foregroundStyle(.secondary)
            .font(.footnote)
        }
      }
    }
    .navigationTitle("Products")
  }
}

#Preview {
  let coordinator = AppCoordinator(repository: PlistTransactionsRepository())
  coordinator.start()
}
