//
//  Transaction.swift
//  SKBTransactionViewer
//
//  Created by Dmitry Mikhailov on 23.10.2024.
//
import Foundation
/// Represents a product transaction
struct Transaction: Codable, Identifiable {
  var id: UUID = .init()
  /// Stock Keeping Unit
  let sku: String
  /// Transaction amount
  let amount: Decimal
  /// Currency of the transaction
  let currency: String
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = UUID()
    self.sku = try container.decode(String.self, forKey: .sku)
    let amount = try container.decode(String.self, forKey: .amount)
    self.amount = Decimal(string: amount) ?? 0
    self.currency = try container.decode(String.self, forKey: .currency)
  }
}
