//
//  HomeView.swift
//  PDFReportGenerator
//
//  Created by Adarsh Pandey on 30/05/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    @State private var isPresented = false
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Button {
                        isLoading = true

                        Task {
                            do {
                                try await viewModel.generatePDF()
                                isPresented = true
                                isLoading = false
                            } catch {
                                print(error.localizedDescription)
                                isLoading = false
                            }
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: UIScreen.main.bounds.width / 1.5, height: 70)
                            .foregroundColor(.cyan)
                            .overlay {
                                Text(viewModel.buttonTitle)
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .bold()
                            }
                    }
                }

                if isLoading {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)

                    ProgressView()
                        .scaleEffect(1)
                        .tint(.white)
                }
            }
            .navigationTitle("PDF Report Generator")
            .fullScreenCover(isPresented: $isPresented) {
                TransactionPDFView(pdfURL: viewModel.generatePdfUrl())
            }
        }
    }
}

#Preview {
    HomeView()
}
