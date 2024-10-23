//
//  Rate.swift
//  SKBTransactionViewer
//
//  Created by Dmitry Mikhailov on 23.10.2024.
//
import Foundation

/// Represents currency conversion rates.
struct Rate: Codable {
  /// Source currency
  let from: String
  /// Target currency
  let to: String
  /// Exchange rate
  let rate: Decimal

  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    from = try container.decode(String.self, forKey: .from)
    to = try container.decode(String.self, forKey: .to)
    let rate = try container.decode(String.self, forKey: .rate)
    self.rate = Decimal(string: rate) ?? 0
  }
}
