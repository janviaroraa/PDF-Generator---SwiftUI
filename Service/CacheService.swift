//
//  CacheService.swift
//  PDFReportGenerator
//
//  Created by Janvi Arora on 31/05/25.
//

import Foundation

class CacheService {
    static let shared = CacheService()

    private let cacheKey: NSString = "pdfCache"
    private var cachedData = NSCache<NSString, NSArray>()

    private init() { }

    func save(_ transactions: [TransactionModel]) {
        cachedData.setObject(transactions as NSArray, forKey: cacheKey)
    }

    func get() -> [TransactionModel]? {
        cachedData.object(forKey: cacheKey) as? [TransactionModel]
    }
}
