//
//  HomeViewModel.swift
//  PDFReportGenerator
//
//  Created by Adarsh Pandey on 30/05/25.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var buttonTitle: String = "Generate PDF"
    @Published var transactions = [TransactionModel]()

    init() {

    }

    @MainActor
    func generatePDF() async throws {
        if let cachedData = CacheService.shared.get() {
            transactions = cachedData
            return
        }

        let fetchedData = try await APIService.fetchData()
        transactions = fetchedData
        CacheService.shared.save(fetchedData)
    }

    @MainActor
    func generatePdfUrl() -> URL? {
        PDFService.generatePDF(from: transactions, title: "Transaction Report")
    }
}
