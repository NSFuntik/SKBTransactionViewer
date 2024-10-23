//
//  TransactionsRepositoryProtocol.swift
//  SKBTransactionViewer
//
//  Created by Dmitry Mikhailov on 23.10.2024.
//
import Foundation

/// A base behaviour for fetching Transactions
protocol TransactionsRepositoryProtocol {
  func fetchRates(_ completion: @escaping (Result<[Rate], Error>) -> Void) -> Void
  func fetchTransactions(_ completion: @escaping (Result<[Transaction], Error>) -> Void)  -> Void
}
