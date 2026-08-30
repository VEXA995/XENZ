import SwiftUI

enum TabItem: Int, CaseIterable {
    case home = 0
    case analytics = 1
    case transfer = 2
    case cards = 3
    case settings = 4

    var title: String {
        switch self {
        case .home:      return "Home"
        case .analytics: return "Analytics"
        case .transfer:  return ""
        case .cards:     return "Cards"
        case .settings:  return "Settings"
        }
    }

    var iconName: String {
        switch self {
        case .home:      return "house.fill"
        case .analytics: return "chart.bar.fill"
        case .transfer:  return "arrow.left.arrow.right"
        case .cards:     return "creditcard.fill"
        case .settings:  return "gearshape.fill"
        }
    }
}

struct MainTabView: View {
    @StateObject private var store = BankingStore()
    @State private var selectedTab: TabItem = .home
    @State private var showTransferSheet = false
    @State private var isSplashFinished = false

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .home:
                    HomeScreen(store: store)
                case .analytics:
                    AnalyticsScreen(store: store)
                case .transfer:
                    HomeScreen(store: store)
                case .cards:
                    CardsScreen(store: store)
                case .settings:
                    SettingsScreen(store: store)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            floatingTabBar
                .padding(.horizontal, 20)
                .padding(.bottom, 12)

            if !isSplashFinished {
                LoadingSplashScreen(isFinished: $isSplashFinished)
                    .transition(.opacity.combined(with: .scale(scale: 1.04)))
                    .zIndex(10)
            }
        }
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: $showTransferSheet) {
            SendMoneySheet(store: store)
        }
    }

    private var floatingTabBar: some View {
        HStack(spacing: 0) {
            tabButton(.home)
            tabButton(.analytics)

            centerTransferButton

            tabButton(.cards)
            tabButton(.settings)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(Color(white: 0.08).opacity(0.96))
                .overlay(
                    Capsule()
                        .strokeBorder(Color(white: 0.18), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.75), radius: 24, x: 0, y: 10)
        )
    }

    private func tabButton(_ tab: TabItem) -> some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 3) {
                Image(systemName: tab.iconName)
                    .font(.system(size: 17, weight: selectedTab == tab ? .semibold : .regular))
                    .foregroundStyle(selectedTab == tab ? Color.white : Color(white: 0.38))
                    .frame(height: 22)

                Text(tab.title)
                    .font(.system(size: 9, weight: selectedTab == tab ? .semibold : .regular))
                    .foregroundStyle(selectedTab == tab ? Color.white : Color(white: 0.38))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(selectedTab == tab ? Color(white: 0.16) : Color.clear)
                    .padding(.horizontal, 4)
            )
        }
        .buttonStyle(.plain)
    }

    private var centerTransferButton: some View {
        Button {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            showTransferSheet = true
        } label: {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 42, height: 42)
                    .shadow(color: Color.white.opacity(0.2), radius: 8, x: 0, y: 2)

                Image(systemName: "arrow.left.arrow.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.black)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}
