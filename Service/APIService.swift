//
//  APIService.swift
//  PDFReportGenerator
//
//  Created by Adarsh Pandey on 30/05/25.
//

import Foundation

enum APIServiceError: Error {
    case invalidURL
    case invalidResponse
    case decodingFailed
}

class APIService {

    static func fetchData() async throws -> [TransactionModel] {
        let urlString = "https://run.mocky.io/v3/a0252c7c-0c84-4a5c-ba18-fcd3a380227f"

        guard let url = URL(string: urlString) else {
            throw APIServiceError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw APIServiceError.invalidResponse
        }

        do {
            return try JSONDecoder().decode([TransactionModel].self, from: data)
        } catch {
            throw APIServiceError.decodingFailed
        }
    }
}
