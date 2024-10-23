//
//  Coordinator.swift
//  SKBTransactionViewer
//
//  Created by Dmitry Mikhailov on 23.10.2024.
//

import SwiftUI
import UIKit

// MARK: - AppCoordinator

@MainActor
final class AppCoordinator {
  // Add UIKit
  var navigationController: UINavigationController?

  private let repository: TransactionsRepositoryProtocol
  private var converter: CurrencyConverterProtocol

  init(navigationController: UINavigationController? = nil,
       repository: TransactionsRepositoryProtocol)
  {
    self.navigationController = navigationController
    self.repository = repository
    converter = CurrencyConverterService(rates: [])
  }

  func start() -> some View {
    let productListViewModel = ProductListViewModel(repository: repository)
    return NavigationStack {
      ProductListView(viewModel: productListViewModel, coordinator: self)
        .task {
          self.repository.fetchRates {
            switch $0 {
            case let .success(rates):
              self.converter = CurrencyConverterService(rates: rates)
            case .failure:
              return
            }
          }
        }
    }
  }

  func makeTransactionDetailView(
    sku: String,
    transactions: [Transaction]
  ) -> some View {
    let transactionDetailViewModel = TransactionDetailViewModel(
      sku: sku,
      transactions: transactions,
      converter: converter
    )

    return TransactionDetailView(viewModel: transactionDetailViewModel)
  }
}

// MARK: UIKit

extension AppCoordinator {
  func start() {
    let productListViewModel = ProductListViewModel(repository: repository)
    let productListView = ProductListView(viewModel: productListViewModel, coordinator: self)
    let hostingProductListView = UIHostingController(rootView: productListView)
    navigationController?.pushViewController(hostingProductListView, animated: true)
  }

  func makeTransactionDetailView(
    sku: String,
    transactions: [Transaction]
  ) {
    let transactionDetailViewModel = TransactionDetailViewModel(
      sku: sku,
      transactions: transactions,
      converter: converter
    )

    let transactionDetailView = TransactionDetailView(viewModel: transactionDetailViewModel)
    let hostingTransactionDetailView = UIHostingController(rootView: transactionDetailView)
    navigationController?.pushViewController(hostingTransactionDetailView, animated: true)
  }
}
