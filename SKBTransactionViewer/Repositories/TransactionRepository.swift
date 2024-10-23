//
//  DataServiceProtocol.swift
//  SKBTransactionViewer
//
//  Created by Dmitry Mikhailov on 23.10.2024.
//

import Foundation
import OSLog

// MARK: - PlistTransactionsRepository

let log = Logger(subsystem: "SKBTransactionViewer", category: "TransactionRepository")

// MARK: - PlistTransactionsRepository

final class PlistTransactionsRepository: TransactionsRepositoryProtocol {
  init() {}
  private let queue = DispatchQueue(label: "com.transactions.repository.queue", qos: .userInitiated)
  private let decoder = PropertyListDecoder()

  /// Load transactions using the universal fetch method
  func fetchTransactions(_ completion: @escaping (Result<[Transaction], Error>) -> Void) {
    fetch(from: "transactions", completion: completion)
  }

  /// Load rates using the universal fetch method
  func fetchRates(_ completion: @escaping (Result<[Rate], Error>) -> Void) {
    fetch(from: "rates", completion: completion)
  }
}

private extension PlistTransactionsRepository {
  /// Universal fetch method for any decodable type
  private func fetch<T: Decodable>(from fileName: String, completion: @escaping (Result<[T], Error>) -> Void) {
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "plist") else {
      completion(.failure(RepositoryError.dataNotFound))
      return
    }

    queue.async { [weak self] in
      guard let self = self else { return }
      do {
        let data = try Data(contentsOf: url)
        let decodedData = try self.decoder.decode([T].self, from: data)

        DispatchQueue.main.async {
          log.error("Fetched data from \(fileName).plist \(decodedData)")
          completion(decodedData.isEmpty ? .failure(RepositoryError.dataIsEmpty) : .success(decodedData))
        }
      } catch {
        log.error("Failed to fetch data from \(fileName).plist \(error.localizedDescription)")
        DispatchQueue.main.async {
          completion(.failure(RepositoryError.dataNotDecodable(error)))
        }
      }
    }
  }
}
