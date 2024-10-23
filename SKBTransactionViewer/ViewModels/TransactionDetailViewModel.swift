//
//  TransactionDetailViewModel.swift
//  SKBTransactionViewer
//
//  Created by Dmitry Mikhailov on 23.10.2024.
//

import Foundation

// MARK: - TransactionDetailViewModel

@MainActor
final class TransactionDetailViewModel: ObservableObject {
  @Published var transactions: [TransactionModel] = []
  @Published var total: Decimal = 0.0
  let sku: String

  init(
    sku: String,
    transactions: [Transaction],
    converter: CurrencyConverterProtocol
  ) {
    self.sku = sku

    transformTransactions(transactions, converter)
  }

  private func transformTransactions(_ allTransactions: [Transaction] = [], _ converter: CurrencyConverterProtocol) {
    let filteredTransactions = allTransactions.filter { $0.sku == sku }
    var total = Decimal(0)
    var transactionModels: [TransactionModel] = []

    for transaction in filteredTransactions {
      if let amountInGBP = converter.convert(amount: transaction.amount, from: transaction.currency, to: "GBP") {
        total += amountInGBP
        transactionModels.append(TransactionModel(transaction: transaction, amount: amountInGBP))
      }
    }

    transactions = transactionModels
    self.total = total.rounded(to: 2)
  }
}

