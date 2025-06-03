//
//  PDFViewRepresentable.swift
//  PDFReportGenerator
//
//  Created by Adarsh Pandey on 30/05/25.
//

import Foundation
import PDFKit
import SwiftUI

struct PDFViewRepresentable: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PDFKit.PDFView {
        let pdfView = PDFKit.PDFView()
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: PDFKit.PDFView, context: Context) { }
}
