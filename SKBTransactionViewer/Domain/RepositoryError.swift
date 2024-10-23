//
//  RepositoryError.swift
//  SKBTransactionViewer
//
//  Created by Dmitry Mikhailov on 23.10.2024.
//
import Foundation

// MARK: - RepositoryError

enum RepositoryError: Error {
  case dataNotFound
  case dataIsEmpty
  case dataNotDecodable(Error)

  var localizedDescription: String {
    switch self {
    case .dataNotFound:
      return "Data not found"
    case .dataIsEmpty:
      return "Data is empty"
    case let .dataNotDecodable(error):
      return "Failed to decode data \(error.localizedDescription)"
    }
  }
}
