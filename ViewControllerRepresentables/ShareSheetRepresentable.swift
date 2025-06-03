//
//  ShareSheetRepresentable.swift
//  PDFReportGenerator
//
//  Created by Janvi Arora on 31/05/25.
//

import SwiftUI
import UIKit

struct ShareSheetRepresentable: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) { }
}
