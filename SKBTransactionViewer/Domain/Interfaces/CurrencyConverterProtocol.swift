//
//  CurrencyConverterProtocol.swift
//  SKBTransactionViewer
//
//  Created by Dmitry Mikhailov on 23.10.2024.
//
import Foundation

protocol CurrencyConverterProtocol {
  func convert(amount: Decimal, from: String, to: String) -> Decimal?
}
