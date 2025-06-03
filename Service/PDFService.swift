import Foundation
import PDFKit
import UIKit

class PDFService {

    static func generatePDF(from transactions: [TransactionModel], title: String) -> URL {
        let pdfMetaData = [
            kCGPDFContextCreator: "TransactionApp",
            kCGPDFContextAuthor: "User",
            kCGPDFContextTitle: title
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageSize = CGSize(width: 595, height: 842)
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize), format: format)

        let userDetails = [
            "Name: Adarsh Pandey",
            "Email: adarsh.pandey@gmail.com",
            "Mobile Number: 9876543210",
            "Card Number: ••••••••••••6217",
            "Card Type: PERSONAL",
            "Address: LUCKNOW"
        ]

        let dateRange = "01-Jan-2025 to 01-Apr-2025"

        let pdfData = renderer.pdfData { context in
            var currentPage = 1
            var transactionIndex = 0

            while transactionIndex < transactions.count {
                context.beginPage()
                let ctx = context.cgContext

                var y: CGFloat = 40
                let leftX: CGFloat = 40
                let rightX: CGFloat = 450

                // Fonts
                let userAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 12)]
                let boldAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 14)]
                let pageFooterAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 9),
                    .foregroundColor: UIColor.gray
                ]

                // Paragraph style
                let centerAlignStyle = NSMutableParagraphStyle()
                centerAlignStyle.alignment = .center

                let tableHeaderAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 11),
                    .foregroundColor: UIColor.white,
                    .paragraphStyle: centerAlignStyle
                ]

                let cellAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 10),
                    .paragraphStyle: centerAlignStyle
                ]

                // User Info (Left)
                for detail in userDetails {
                    NSAttributedString(string: detail, attributes: userAttributes)
                        .draw(in: CGRect(x: leftX, y: y, width: 300, height: 15))
                    y += 16
                }

                // OmniCard Logo (Right)
                if let logo = UIImage(named: "Omni-Card-logo")?.cgImage {
                    let logoRect = CGRect(x: rightX, y: 40, width: 100, height: 40)
                    ctx.draw(logo, in: logoRect)
                }

                y += 15

                NSAttributedString(string: "\(title): \(dateRange)", attributes: boldAttributes)
                    .draw(in: CGRect(x: leftX, y: y, width: 500, height: 20))

                y += 30

                // Table setup
                let headers = ["Date", "Narration", "Transaction ID", "Status", "Credit", "Debit"]
                let columnWidths: [CGFloat] = [90, 110, 100, 80, 60, 60]
                let rowHeight: CGFloat = 40
                let tableWidth = columnWidths.reduce(0, +)

                // Draw header background
                ctx.setFillColor(UIColor.darkGray.cgColor)
                ctx.fill(CGRect(x: leftX, y: y, width: tableWidth, height: rowHeight))

                // Draw header text with padding
                var x = leftX
                let padding: CGFloat = 4
                for (i, header) in headers.enumerated() {
                    let rect = CGRect(x: x + padding, y: y + padding, width: columnWidths[i] - 2 * padding, height: rowHeight - 2 * padding)
                    NSAttributedString(string: header, attributes: tableHeaderAttributes).draw(in: rect)
                    x += columnWidths[i]
                }

                // Draw header borders
                ctx.setStrokeColor(UIColor.black.cgColor)
                ctx.setLineWidth(1.0)

                ctx.move(to: CGPoint(x: leftX, y: y + rowHeight))
                ctx.addLine(to: CGPoint(x: leftX + tableWidth, y: y + rowHeight))
                ctx.strokePath()

                var verticalX = leftX
                for width in columnWidths {
                    ctx.move(to: CGPoint(x: verticalX, y: y))
                    ctx.addLine(to: CGPoint(x: verticalX, y: y + rowHeight))
                    ctx.strokePath()
                    verticalX += width
                }
                ctx.move(to: CGPoint(x: verticalX, y: y))
                ctx.addLine(to: CGPoint(x: verticalX, y: y + rowHeight))
                ctx.strokePath()

                y += rowHeight

                // Table rows
                while transactionIndex < transactions.count && y + rowHeight < pageSize.height - 60 {
                    let t = transactions[transactionIndex]
                    let values = [
                        t.date ?? "-", t.narration ?? "-", t.transactionId ?? "-",
                        t.status ?? "-", t.credit ?? "-", "-"
                    ]

                    x = leftX
                    for (i, value) in values.enumerated() {
                        let rect = CGRect(x: x + padding, y: y + padding, width: columnWidths[i] - 2 * padding, height: rowHeight - 2 * padding)
                        NSAttributedString(string: value, attributes: cellAttributes).draw(in: rect)
                        x += columnWidths[i]
                    }

                    // Draw horizontal row line
                    ctx.move(to: CGPoint(x: leftX, y: y))
                    ctx.addLine(to: CGPoint(x: leftX + tableWidth, y: y))
                    ctx.strokePath()

                    // Draw vertical lines
                    verticalX = leftX
                    for width in columnWidths {
                        ctx.move(to: CGPoint(x: verticalX, y: y))
                        ctx.addLine(to: CGPoint(x: verticalX, y: y + rowHeight))
                        ctx.strokePath()
                        verticalX += width
                    }
                    ctx.move(to: CGPoint(x: verticalX, y: y))
                    ctx.addLine(to: CGPoint(x: verticalX, y: y + rowHeight))
                    ctx.strokePath()

                    y += rowHeight
                    transactionIndex += 1
                }

                // Bottom border
                ctx.move(to: CGPoint(x: leftX, y: y))
                ctx.addLine(to: CGPoint(x: leftX + tableWidth, y: y))
                ctx.strokePath()

                // Footer
                let footer = "Page \(currentPage)"
                NSAttributedString(string: footer, attributes: pageFooterAttributes)
                    .draw(in: CGRect(x: leftX, y: pageSize.height - 30, width: 200, height: 15))

                currentPage += 1
            }
        }

        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(title).pdf")
        try? pdfData.write(to: tempURL)
        return tempURL
    }
}
