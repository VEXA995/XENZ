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

            customTabBar

            if !isSplashFinished {
                LoadingSplashScreen(isFinished: $isSplashFinished)
                    .transition(.opacity.combined(with: .scale(scale: 1.05)))
                    .zIndex(10)
            }
        }
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: $showTransferSheet) {
            SendMoneySheet(store: store)
        }
    }

    private var customTabBar: some View {
        HStack(spacing: 0) {
            tabButton(.home)
            tabButton(.analytics)

            centerTransferButton

            tabButton(.cards)
            tabButton(.settings)
        }
        .padding(.horizontal, 14)
        .padding(.top, 12)
        .padding(.bottom, 24)
        .background(
            Color.black
                .overlay(
                    Rectangle()
                        .fill(Color(white: 0.12))
                        .frame(height: 1),
                    alignment: .top
                )
                .ignoresSafeArea(edges: .bottom)
        )
    }

    private func tabButton(_ tab: TabItem) -> some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: tab.iconName)
                    .font(.system(size: 20, weight: .regular))
                    .foregroundStyle(selectedTab == tab ? Color.white : Color(white: 0.35))

                Text(tab.title)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(selectedTab == tab ? Color.white : Color(white: 0.35))
            }
            .frame(maxWidth: .infinity)
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
                    .fill(Color(white: 0.18))
                    .frame(width: 48, height: 48)
                    .overlay(Circle().strokeBorder(Color(white: 0.28), lineWidth: 1))

                Image(systemName: "arrow.left.arrow.right")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}
