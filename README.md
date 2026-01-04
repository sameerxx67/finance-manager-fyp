
# Zenthory – Finance Manager App (FYP)

Zenthory is a Flutter-based Android Finance Manager application developed as a Final Year Project (FYP).  
The application helps users manage their income, expenses, budgets, and financial reports efficiently in an offline environment.

---

## 📌 Project Overview

Managing personal finances is an important daily task. This application provides a simple and effective solution for tracking income and expenses, setting monthly budgets, and analyzing financial data through reports and charts.

The app is designed as a single-user offline Android application focusing on simplicity, privacy, and ease of use.

---

## ✨ Features

- Add income and expenses  
- Category-wise transaction management  
- Monthly and yearly financial reports  
- Budget creation and monitoring  
- Visual charts for financial analysis  
- Currency selection (PKR, USD, EUR, etc.)  
- Light mode and Dark mode support  
- Offline data storage using SQLite  
- Clean and user-friendly interface  

---

## 🧩 App Screens

- Dashboard  
- Add Income  
- Add Expense  
- Budget Management  
- Reports & Charts  
- Settings (Currency & Theme)

---

## 🛠 Technologies Used

- Flutter  
- Dart  
- SQLite  
- Provider (State Management)

---

## 📂 Project Structure

```

lib/
├── screens/        # UI screens (dashboard, income, expense, reports)
├── models/         # Data models
├── database/       # SQLite database helper
├── providers/      # State management
└── main.dart       # Application entry point

````

---

## 📶 Offline Support

This application works completely offline.  
All user financial data is stored locally using SQLite, ensuring data privacy, fast access, and no internet dependency.

---
## Backend Setup (Docker)

The backend service is containerized using Docker.

### To Run Backend

```bash
docker compose up --build
Backend Runs On
http://localhost:3000

## ▶️ How to Run the Project

1. Clone the repository  
   ```bash
   git clone <repository-url>
````


