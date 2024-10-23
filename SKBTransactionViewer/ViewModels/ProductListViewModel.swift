//
//  ProductListViewModel.swift
//  SKBTransactionViewer
//
//  Created by Dmitry Mikhailov on 23.10.2024.
//

import Foundation

// MARK: - ProductListViewModel

@MainActor
class ProductListViewModel: ObservableObject {
  @Published var products: [ProductModel] = []
  @Published var errorMessage: String? = nil

  private let repository: TransactionsRepositoryProtocol

  init(
    repository: TransactionsRepositoryProtocol = PlistTransactionsRepository()
  ) {
    self.repository = repository
    loadProducts()
  }

  private func loadProducts() {
    repository.fetchTransactions { [weak self] in
      guard let self else { return }
      switch $0 {
      case let .success(transactions):
        let groupedTransactions = Dictionary(grouping: transactions, by: { $0.sku })
        let productModels = groupedTransactions.map { ProductModel(sku: $0.key, transactions: $0.value) }
        DispatchQueue.main.async {
          self.products = productModels.sorted(by: { $0.sku < $1.sku })
        }
      case let .failure(error):
        errorMessage = ("Error loading transactions: \(error)")
      }
    }
  }
}
