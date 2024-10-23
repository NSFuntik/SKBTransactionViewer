//
//  TransactionDetailView.swift
//  SKBTransactionViewer
//
//  Created by Dmitry Mikhailov on 23.10.2024.
//

import SwiftUI

// MARK: - TransactionModel

struct TransactionModel: Identifiable {
  let id = UUID()
  let transaction: Transaction
  let amount: Decimal
}

// MARK: - TransactionDetailView

struct TransactionDetailView: View {
  @ObservedObject var viewModel: TransactionDetailViewModel

  var body: some View {
    List {
      Section("Total: \((viewModel.total.formatted(.currency(code: "GBP"))))") {
        ForEach(viewModel.transactions, id: \.id) { transaction in
          HStack {
            Text(transaction.transaction.amount.formatted(.currency(code: transaction.transaction.currency)))
              .font(.subheadline)
            Spacer()
            Text(transaction.amount.formatted(.currency(code: "GBP")))
              .font(.headline)
          }
        }
      }
    }
    .navigationTitle("Transactions for \(viewModel.sku)")
  }
}
