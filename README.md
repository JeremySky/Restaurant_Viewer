# 🍽️ Yelp Restaurant Explorer

An iOS app leveraging **Yelp's Search API** 🍕 and **Swift's CoreLocation** 📍 to display restaurants based on user-selected criteria like category and sort order 🔍. Browse nearby dining spots 🌆✨ with a responsive, card-based UI 🃏 built with **SwiftUI** and modern **async/await concurrency**.

---

## 🚀 Features

- Fetch restaurants asynchronously using **Yelp's Search API** 🍴  
- Use **CoreLocation** 📍 to get the user's current location  
- Search and sort restaurants by **category** 🍔, 🍣, 🍕 and **sort order** 🔍  
- **Card stack interface** 🃏 with smooth **animations**:
  - Tap **Next** ➡️ card animates off-screen left  
  - Tap **Previous** ⬅️ card animates to center from left  
- **Favorite restaurants 💖** persisted across app launches using **local storage / UserDefaults**  
- Handles **errors gracefully** ⚠️:
  - Location errors 📌  
  - Network errors 🌐  
  - API/data decoding errors 🛠️  
- **Dynamic layouts** for iPhone & iPad 📱💻:
  - Portrait & landscape orientation 🔄  
  - Split-screen multitasking on iPad 🖼️  
- **Modularized services** 🏗️:
  - `LocationService` and `YelpSearchService` are fully modular  
  - Easy **dependency injection** for testing and flexibility  
  - Includes **mock data providers** for different states: `loading`, `empty`, `loaded`  
- Written with **clean architecture principles**, **MVVM pattern**, and **modular Swift code** for maintainability

---

## 🛠️ Requirements

- iOS 16+ 🍏  
- Xcode 15+ 💻  
- Swift 5.9+ 🐦  
- Yelp API Key 🔑

---

## ⚡ Setup

1. Obtain a **Yelp API Key** by creating an app at [Yelp Developers](https://www.yelp.com/developers) 🔑  
2. Open the project in Xcode 💻  
3. In `YelpSearchServices.swift`, replace the placeholder with your API Key:

```swift
private let apiKey = "API_KEY_HERE"
