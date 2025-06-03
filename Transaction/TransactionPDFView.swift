//
//  TransactionPDFView.swift
//  PDFReportGenerator
//
//  Created by Adarsh Pandey on 30/05/25.
//

import SwiftUI

struct TransactionPDFView: View {
    @Environment(\.dismiss) var dismiss

    @State private var isSharing = false

    let pdfURL: URL?

    var body: some View {
        NavigationStack {
            VStack {
                if let url = pdfURL {
                    PDFViewRepresentable(url: url)
                        .border(Color.gray, width: 1)
                }

                Spacer()

                Button {
                    isSharing = true
                } label: {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(height: 40)
                        .foregroundColor(.cyan)
                        .overlay {
                            Label("Share PDF", systemImage: "square.and.arrow.up")
                                .foregroundColor(.white)
                                .bold()
                        }
                }
                .sheet(isPresented: $isSharing) {
                    if let url = pdfURL {
                        ShareSheetRepresentable(activityItems: [url])
                    }
                }
            }
            .padding()
            .navigationTitle("Transaction_Report_\(UUID().uuidString).pdf")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .bold()
                }
            }
        }
    }
}
