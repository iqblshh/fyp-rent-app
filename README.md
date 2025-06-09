# 🚗 Smart Toy Car Renting System

A **Flutter-based Toy Car Renting System** enhanced with **MQTT + Python** for real-time QR code scanning via webcam and automated rental tracking.

---

## 🧩 Features

### 🖥️ Flutter App
- 📦 **Rental Management** – Tracks car items, types, start/end times, payments, and late returns
- 📊 **Dashboard Charts**
  - Rentals and sales over date/day
  - Rental counts by item type
  - Late returns by item type
- 💰 Total sales, rental count, average sales on dashboard
- 🗃 Local persistence using **Sqflite**

### 📡 Python MQTT Scanner
- 📷 **OpenCV** + **ZBar** webcam-based QR code scanner
- 🔌 Publishes scanned rental info (e.g., rent item ID) to **MQTT broker**
- 🔄 Flutter app listens via MQTT and updates rental status in real time

---

## 🚀 Getting Started

### 1. Flutter App

```bash
git clone https://github.com/iqblshh/fyp-rent-app.git
cd smart-toy-car-renting-system
flutter pub get
flutter run
