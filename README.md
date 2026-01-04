
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
- Backend integration

---

## 🧩 App Screens

- Dashboard  
- Add Income  
- Add Expense  
- Budget Management  
- Reports & Charts  
- Settings (Currency & Theme)
- Docker & Docker Compose

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
## ▶️ How to Run This Project

### Prerequisites
- Flutter SDK installed
- Android Studio or VS Code
- Android emulator or physical Android device
- Docker & Docker Compose (for backend)

### Steps

1. Clone the repository
   ```bash
   git clone <repository-url>


## Backend Setup (Docker)

The backend service is containerized using Docker.

### To Run Backend

```bash
docker compose up --build
Backend Runs On
http://localhost:3000


````
## 🚀 Future Enhancements

- User Authentications (login/ signup)
- Cloud Backup And Synchronization
- Multi-user Support
- Export Reports As Pdf or Csv
- Integration with Banking or payment APIs



---
## 🙏 Acknowledgements

I would like to express my sincere gratitude to my university teachers and supervisors for their guidance and support throughout the development of this Final Year Project.  
I am also thankful to the open-source community and Flutter documentation for providing valuable resources and learning materials.

---

## ⚠️ Disclaimer

This application is developed solely for **academic and learning purposes** as a Final Year Project (FYP).  
The data used in the application is for demonstration only and does not represent real financial information.

The developer is not responsible for any misuse of tiis application.



