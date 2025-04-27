# 🛠️ Mac App Updater

A native macOS app built with Swift + SwiftUI that helps you **manage, check, and update** all your installed apps in **one place**.

![screenshot](screenshot.png) <!-- You can later add a real screenshot here -->

---

## ✨ Features

- 🚀 **Discover all installed apps**

  - Mac App Store apps (`mas`)
  - Homebrew cask apps (`brew`)
  - Manually installed apps (via System Profiler)

- 🔄 **Check for available updates**

  - Detect outdated apps automatically
  - Supports App Store & Homebrew apps

- 🛠️ **One-click updates**

  - Update individual apps
  - Update all outdated apps at once (with confirmation)

- 🔎 **Search apps**

  - Instantly filter apps by name

- 🔔 **Desktop notifications**

  - Get notified when an app is updated successfully

- 🧹 **Clean and simple UI**

  - Built with SwiftUI for macOS

- 🛡️ **Handles missing tools**
  - Warns if `mas` or `brew` are missing
  - Future-proof design to allow auto-install assistance

---

## 📸 App Screenshots

> _(Screenshots coming soon — Add images after building)_

- App List with Update Status
- Search Bar to filter apps
- Loading Spinner during refresh
- Desktop Notifications after successful updates

---

## ⚙️ Requirements

- macOS 13 or later
- [Homebrew](https://brew.sh/) installed (for brew apps management)
- [mas-cli](https://github.com/mas-cli/mas) installed (for App Store apps management)

> You can install `mas` easily via:
>
> ```bash
> brew install mas
> ```

---

## 🛠️ How It Works

| Feature         | Technology                                        |
| :-------------- | :------------------------------------------------ |
| App Discovery   | `system_profiler`, `mas list`, `brew list --cask` |
| Update Checking | `mas outdated`, `brew outdated`                   |
| App Updating    | `mas upgrade`, `brew upgrade`                     |
| Notifications   | `UserNotifications` framework                     |
| UI              | SwiftUI                                           |

---

## 📦 Installation (soon)

- Local Build via Xcode
- Soon: Prebuilt `.app` and `.dmg` installer!

---

## 🧑‍💻 Development

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/mac-app-updater.git
   ```
