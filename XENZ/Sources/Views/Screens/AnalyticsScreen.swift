import SwiftUI

struct AnalyticsScreen: View {
    @ObservedObject var store: BankingStore

    @State private var selectedTimeRange = "This Month"
    private let timeRanges = ["This Week", "This Month", "All Time"]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        timeRangePicker

                        totalSpentCard

                        categoryBreakdownSection

                        monthlyInsightsSection
                    }
                    .padding(20)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("Analytics")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var timeRangePicker: some View {
        HStack(spacing: 8) {
            ForEach(timeRanges, id: \.self) { range in
                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    selectedTimeRange = range
                } label: {
                    Text(range)
                        .font(.system(size: 13, weight: .semibold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .foregroundStyle(selectedTimeRange == range ? Color.black : Color.white)
                        .background(
                            Capsule()
                                .fill(selectedTimeRange == range ? Color.white : Color(white: 0.12))
                        )
                }
            }
        }
    }

    private var totalSpent: Double {
        store.transactions
            .filter { $0.type == .expense }
            .reduce(0) { $0 + $1.amount }
    }

    private var totalIncome: Double {
        store.transactions
            .filter { $0.type == .income }
            .reduce(0) { $0 + $1.amount }
    }

    private var totalSpentCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("TOTAL SPENT")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundStyle(Color(white: 0.5))
                .tracking(1.5)

            Text("€\(String(format: "%.2f", totalSpent))")
                .font(.system(size: 36, weight: .bold))
                .foregroundStyle(.white)

            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("EXPENSES")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundStyle(Color(white: 0.45))
                    Text("€\(String(format: "%.2f", totalSpent))")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                }

                Divider().background(Color(white: 0.2))

                VStack(alignment: .leading, spacing: 2) {
                    Text("INCOME")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundStyle(Color(white: 0.45))
                    Text("+ €\(String(format: "%.2f", totalIncome))")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color(red: 0.35, green: 0.9, blue: 0.55))
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(white: 0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .strokeBorder(Color(white: 0.14), lineWidth: 1)
                )
        )
    }

    private var categoryBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("SPENDING BY CATEGORY")
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundStyle(Color(white: 0.5))
                .tracking(1.5)

            let grouped = Dictionary(grouping: store.transactions.filter { $0.type == .expense }, by: { $0.category })
            let sorted = grouped.sorted {
                $0.value.reduce(0) { $0 + $1.amount } > $1.value.reduce(0) { $0 + $1.amount }
            }

            VStack(spacing: 12) {
                ForEach(sorted, id: \.key) { cat, txs in
                    let catTotal = txs.reduce(0) { $0 + $1.amount }
                    let pct = totalSpent > 0 ? (catTotal / totalSpent) : 0.0

                    VStack(spacing: 6) {
                        HStack {
                            Image(systemName: cat.defaultIcon)
                                .font(.system(size: 13))
                                .foregroundStyle(Color(white: 0.7))
                            Text(cat.rawValue)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.white)

                            Spacer()

                            Text("€\(String(format: "%.2f", catTotal)) (\(Int(pct * 100))%)")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(Color(white: 0.75))
                        }

                        GeometryReader { proxy in
                            ZStack(alignment: .leading) {
                                Capsule().fill(Color(white: 0.15))
                                Capsule().fill(Color.white)
                                    .frame(width: proxy.size.width * CGFloat(pct))
                            }
                        }
                        .frame(height: 6)
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(white: 0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .strokeBorder(Color(white: 0.14), lineWidth: 1)
                    )
            )
        }
    }

    private var monthlyInsightsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("FINANCIAL INSIGHTS")
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundStyle(Color(white: 0.5))
                .tracking(1.5)

            HStack(spacing: 12) {
                Image(systemName: "sparkles")
                    .font(.system(size: 18))
                    .foregroundStyle(.white)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Gaming & Subscriptions")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                    Text("Your top expenses this week are Discord Nitro (€9.99) and Roblox Robux.")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(Color(white: 0.5))
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color(white: 0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .strokeBorder(Color(white: 0.14), lineWidth: 1)
                    )
            )
        }
    }
}
