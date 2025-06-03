//
//  TransactionModel.swift
//  PDFReportGenerator
//
//  Created by Adarsh Pandey on 30/05/25.
//

import Foundation

struct TransactionModel: Codable {
    let date: String?
    let narration: String?
    let transactionId: String?
    let status: String?
    let credit: String?
}
