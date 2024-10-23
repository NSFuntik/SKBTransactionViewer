//
//  CurrencyConverterService.swift
//  SKBTransactionViewer
//
//  Created by Dmitry Mikhailov on 23.10.2024.
//

import Foundation

// MARK: - CurrencyConverterService

final class CurrencyConverterService: CurrencyConverterProtocol {
  private var ratesCache: [String: [Rate]] = [:]

  init(rates: [Rate]) {
    for rate in rates {
      ratesCache[rate.from, default: []].append(rate)
    }
  }

  /// Converts amount from one currency to another
  func convert(amount: Decimal, from: String, to: String) -> Decimal? {
    var visited = Set<String>()
    guard let rate = findRate(from: from, to: to, visited: &visited) else {
      return nil
    }

    return (amount * rate).rounded(to: 2)
  }

  /// Finds exchange rate for given currencies
  private func findRate(
    from: String,
    to: String,
    visited: inout Set<String>
  ) -> Decimal? {
    guard from != to else { return Decimal(1) }
    visited.insert(from)
    guard let rates = ratesCache[from] else { return nil }
    for rate in rates {
      if !visited.contains(rate.to) {
        if let nextRate = findRate(from: rate.to,
                                   to: to,
                                   visited: &visited)
        {
          return rate.rate * nextRate
        }
      }
    }
    return nil
  }
}

extension Decimal {
  func rounded(to places: Int) -> Decimal {
    var original = self
    var result = Decimal()
    NSDecimalRound(&result, &original, places, .bankers)
    return result
  }
}
