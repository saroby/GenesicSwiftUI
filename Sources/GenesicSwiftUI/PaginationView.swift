import SwiftUI

public struct PaginationView: View {
    @Binding var currentPage: Int
    let totalPages: Int
    let maxVisiblePages: Int
    let color: Color

    public init(
        currentPage: Binding<Int>,
        totalPages: Int,
        maxVisiblePages: Int = 5,
        color: Color = .blue
    ) {
        self._currentPage = currentPage
        self.totalPages = totalPages
        self.maxVisiblePages = maxVisiblePages
        self.color = color
    }

    private var visiblePages: [Int] {
        let half = maxVisiblePages / 2
        let start = max(1, min(currentPage - half, totalPages - maxVisiblePages + 1))
        let end = min(totalPages, start + maxVisiblePages - 1)
        return Array(start...end)
    }

    public var body: some View {
        HStack(spacing: 8) {
            // Previous button
            Button(action: {
                if currentPage > 1 {
                    currentPage -= 1
                }
            }) {
                Image(systemName: "chevron.left")
                    .font(.subheadline)
                    .foregroundColor(currentPage > 1 ? color : .secondary)
                    .frame(width: 32, height: 32)
                    .background(Color(.systemGray6))
                    .cornerRadius(6)
            }
            .buttonStyle(LabelButtonStyle())
            .disabled(currentPage <= 1)

            // First page
            if !visiblePages.contains(1) && totalPages > 1 {
                pageButton(1)
                if visiblePages.first! > 2 {
                    Text("...")
                        .foregroundColor(.secondary)
                }
            }

            // Visible pages
            ForEach(visiblePages, id: \.self) { page in
                pageButton(page)
            }

            // Last page
            if !visiblePages.contains(totalPages) && totalPages > 1 {
                if visiblePages.last! < totalPages - 1 {
                    Text("...")
                        .foregroundColor(.secondary)
                }
                pageButton(totalPages)
            }

            // Next button
            Button(action: {
                if currentPage < totalPages {
                    currentPage += 1
                }
            }) {
                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .foregroundColor(currentPage < totalPages ? color : .secondary)
                    .frame(width: 32, height: 32)
                    .background(Color(.systemGray6))
                    .cornerRadius(6)
            }
            .buttonStyle(LabelButtonStyle())
            .disabled(currentPage >= totalPages)
        }
    }

    private func pageButton(_ page: Int) -> some View {
        Button(action: {
            currentPage = page
        }) {
            Text("\(page)")
                .font(.subheadline)
                .fontWeight(currentPage == page ? .semibold : .regular)
                .foregroundColor(currentPage == page ? .white : .primary)
                .frame(width: 32, height: 32)
                .background(currentPage == page ? color : Color(.systemGray6))
                .cornerRadius(6)
        }
        .buttonStyle(LabelButtonStyle())
    }
}

#Preview {
    struct PaginationPreview: View {
        @State private var page1 = 3
        @State private var page2 = 1
        @State private var page3 = 10

        var body: some View {
            VStack(spacing: 40) {
                VStack(spacing: 12) {
                    Text("Page \(page1) of 10")
                        .font(.headline)
                    PaginationView(currentPage: $page1, totalPages: 10)
                }

                VStack(spacing: 12) {
                    Text("Page \(page2) of 20")
                        .font(.headline)
                    PaginationView(currentPage: $page2, totalPages: 20, color: .green)
                }

                VStack(spacing: 12) {
                    Text("Page \(page3) of 100")
                        .font(.headline)
                    PaginationView(currentPage: $page3, totalPages: 100, maxVisiblePages: 7, color: .purple)
                }
            }
            .padding()
        }
    }

    return PaginationPreview()
}
