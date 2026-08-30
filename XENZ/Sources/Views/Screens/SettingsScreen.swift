import SwiftUI

struct SettingsScreen: View {
    @ObservedObject var store: BankingStore
    @Environment(\.dismiss) private var dismiss
    @State private var showResetConfirmation = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        profileCard

                        accountDetailsSection

                        securitySection

                        preferencesSection

                        dangerZoneSection

                        appFooter
                    }
                    .padding(20)
                    .padding(.bottom, 60)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(.white)
                }
            }
            .alert("Reset All Data?", isPresented: $showResetConfirmation) {
                Button("Reset to Default (€82.87)", role: .destructive) {
                    store.resetToDefaults()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will restore your balance to €82.87 and reset your transactions (Discord, Roblox, Eneba, Amazon).")
            }
        }
    }

    private var profileCard: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color(white: 0.16))
                    .frame(width: 60, height: 60)
                    .overlay(Circle().strokeBorder(Color(white: 0.25), lineWidth: 1.5))

                if let iconPath = Bundle.main.path(forResource: "app_icon", ofType: "png"),
                   let uiImg = UIImage(contentsOfFile: iconPath) {
                    Image(uiImage: uiImg)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 56, height: 56)
                        .clipShape(Circle())
                } else {
                    Text(String(store.userProfile.name.prefix(3)))
                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                        .foregroundStyle(.white)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(store.userProfile.name)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)

                    Text("PRIME")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .foregroundStyle(.black)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(.white))
                }

                Text(store.userProfile.tag)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color(white: 0.5))

                Text("Verified Identity • Tier 1 Bank Account")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundStyle(Color(white: 0.4))
            }

            Spacer()
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(white: 0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .strokeBorder(Color(white: 0.14), lineWidth: 1)
                )
        )
    }

    private var accountDetailsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("ACCOUNT & IBAN")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundStyle(Color(white: 0.5))
                .tracking(1.5)

            VStack(spacing: 12) {
                settingRow(title: "Account Name", value: store.account.name)
                Divider().background(Color(white: 0.14))
                settingRow(title: "IBAN", value: store.account.iban, isMonospace: true)
                Divider().background(Color(white: 0.14))
                settingRow(title: "BIC / SWIFT", value: store.account.bic, isMonospace: true)
                Divider().background(Color(white: 0.14))
                settingRow(title: "Current Balance", value: store.account.formattedBalance)
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

    private var securitySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("SECURITY & ACCESS")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundStyle(Color(white: 0.5))
                .tracking(1.5)

            VStack(spacing: 12) {
                toggleRow(
                    title: "Face ID / Biometric Lock",
                    subtitle: "Require biometric scan for transfers",
                    icon: "faceid",
                    isOn: $store.userProfile.isBiometricsEnabled
                )

                Divider().background(Color(white: 0.14))

                toggleRow(
                    title: "Push Notifications",
                    subtitle: "Instant alerts for outgoing transfers",
                    icon: "bell.badge.fill",
                    isOn: $store.userProfile.isPushNotificationsEnabled
                )
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

    private var preferencesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("PREFERENCES")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundStyle(Color(white: 0.5))
                .tracking(1.5)

            VStack(spacing: 12) {
                settingRow(title: "Default Currency", value: "EUR (€)")
                Divider().background(Color(white: 0.14))
                settingRow(title: "Interface Theme", value: "OLED Pitch Black")
                Divider().background(Color(white: 0.14))
                settingRow(title: "Region", value: "Germany (SEPA)")
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

    private var dangerZoneSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("DATA MANAGEMENT")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundStyle(Color(white: 0.5))
                .tracking(1.5)

            Button {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                showResetConfirmation = true
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color.red)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Reset to Default Balance")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.red)
                        Text("Restores balance to €82.87 and default history")
                            .font(.system(size: 11))
                            .foregroundStyle(Color(white: 0.45))
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 12))
                        .foregroundStyle(Color(white: 0.3))
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color(white: 0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .strokeBorder(Color.red.opacity(0.3), lineWidth: 1)
                        )
                )
            }
            .buttonStyle(.plain)
        }
    }

    private var appFooter: some View {
        VStack(spacing: 4) {
            Text("XENZ BANKING OS v1.0.0")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundStyle(Color(white: 0.4))
                .tracking(2)
            Text("End-to-End Encrypted Financial Core")
                .font(.system(size: 10))
                .foregroundStyle(Color(white: 0.25))
        }
        .padding(.top, 10)
    }

    private func settingRow(title: String, value: String, isMonospace: Bool = false) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color(white: 0.7))
            Spacer()
            Text(value)
                .font(isMonospace ? .system(size: 13, weight: .medium, design: .monospaced) : .system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
        }
    }

    private func toggleRow(title: String, subtitle: String, icon: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(.white)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundStyle(Color(white: 0.45))
            }

            Spacer()

            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(Color.white)
        }
    }
}
