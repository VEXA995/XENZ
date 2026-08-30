# Xenz — Minimalist iOS Banking App

<div align="center">
  <h3>Pitch-Black OLED Neobank Experience</h3>
  <p>Sleek, fluid, and high-performance financial management app built with native SwiftUI.</p>
</div>

---

## Features

- **OLED Deep Black Aesthetic**: Ultra-clean interface with pure blacks, elevated cards, and high-contrast typography.
- **Floating Bottom Bar**: Floating glassmorphic navigation capsule suspended above the bottom screen edge.
- **Total Balance & Accounts**:
  - Initialized with **€82.87** balance and monthly performance indicators.
  - Main Account with realistic German IBAN (`DE12 3456 7890 1234 5678 90`).
- **Instant SEPA Transfers**:
  - Full money sending sheet with IBAN formatting, preset amounts (€5, €10, €20, €50, Max), note reference, category selector, and biometric confirmation.
  - Interactive balance deduction with haptics and top dynamic island in-app notification banner.
- **Receive & Deposit**:
  - Dedicated QR Code payment screen with instant IBAN copy and system share sheet.
  - Deposit flow for Apple Pay, Credit Card, and Instant SEPA top-ups.
- **Pre-Seeded Realistic Transactions**:
  - **Today**: Discord Nitro (`- €9.99`), Roblox (`- €1.19`), Roblox (`- €1.19`).
  - **Recent**: Eneba (`- €14.99`), Amazon Prime (`- €24.50`), Starbucks (`- €5.45`), Uber (`- €18.75`), Pocket Money Deposit (`+ €145.00`).
- **Multi-Card Wallet Stack**:
  - Obsidian Metal, Cyber Neon Virtual, and Titanium Silver cards.
  - Tap-to-flip for full card number and security code (CVV).
  - Instant card freeze toggle, online purchase lock, and spending limit visualizer.
- **Spending Analytics**:
  - Monthly expense breakdown across Gaming, Subscriptions, Shopping, and Food.
- **Profile & Security**:
  - Personalized for **047** with Face ID app lock toggles, biometric preferences, and balance reset functionality.

---

## Tech Stack

- **Framework**: SwiftUI (iOS 17+)
- **Architecture**: MVVM with Combine (`ObservableObject`, `@Published`, `UserDefaults` JSON persistence)
- **Design System**: Native SF Symbols, custom dark palettes, spring physics transitions
- **CI/CD**: GitHub Actions Xcode release build pipeline

---

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/VEXA995/XENZ.git
   ```
2. Open `XENZ.xcodeproj` in Xcode 15/16.
3. Select any iOS 17+ Simulator or physical device and press **Cmd + R**.
