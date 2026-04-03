# Kharch Tracker

A modern personal finance companion app built with Flutter. Kharch Tracker helps you monitor your transactions, set and achieve savings goals, and gain insights into your spending habits through clear, interactive charts.

## Features

- **Dashboard:** Get a quick overview of your total balance, overall income, expenses, and weekly spending breakdown.
- **Transactions Management:** Easily view, search, and filter your daily transactions (Income vs. Expense). 
- **Goal Tracking:** Set savings goals, track your progress with beautiful circular indicators, and maintain savings streaks.
- **Deep Insights:** Detailed analytics including category-wise spending pie charts and monthly trends to understand your financial health.
- **Security:** Biometric authentication ensures your sensitive financial data remains private.
- **Data Export:** Export your transaction data securely to CSV format.

## Screenshots

### Home
<div align="center">
  <img src="assets/images/home.png" alt="Home" width="200" style="margin: 10px;" />
  <img src="assets/images/home2.png" alt="Home 2" width="200" style="margin: 10px;" />
  <img src="assets/images/homeDark.png" alt="Home Dark" width="200" style="margin: 10px;" />
</div>

### Transactions
<div align="center">
  <img src="assets/images/transaction.png" alt="Transactions" width="200" style="margin: 10px;" />
  <img src="assets/images/transactionDark.png" alt="Transactions Dark" width="200" style="margin: 10px;" />
  <img src="assets/images/add_new_transection.png" alt="Add Transaction" width="200" style="margin: 10px;" />
</div>

### Goals
<div align="center">
  <img src="assets/images/goals.png" alt="Goals" width="200" style="margin: 10px;" />
  <img src="assets/images/goals2.png" alt="Goals 2" width="200" style="margin: 10px;" />
  <img src="assets/images/goalDark.png" alt="Goals Dark" width="200" style="margin: 10px;" />
  <img src="assets/images/add_new_goal.png" alt="Add Goal" width="200" style="margin: 10px;" />
</div>

### Insights
<div align="center">
  <img src="assets/images/insight.png" alt="Insights" width="200" style="margin: 10px;" />
  <img src="assets/images/insight2.png" alt="Insights 2" width="200" style="margin: 10px;" />
  <img src="assets/images/insight3.png" alt="Insights 3" width="200" style="margin: 10px;" />
  <img src="assets/images/insight4.png" alt="Insights 4" width="200" style="margin: 10px;" />
  <img src="assets/images/insightDark.png" alt="Insights Dark" width="200" style="margin: 10px;" />
</div>

### Settings
<div align="center">
  <img src="assets/images/settings.png" alt="Settings" width="200" style="margin: 10px;" />
  <img src="assets/images/settingsDark.png" alt="Settings Dark" width="200" style="margin: 10px;" />
</div>

## Technologies & Architecture

- **Framework:** Flutter
- **State Management:** BLoC (`flutter_bloc`)
- **Navigation:** `go_router`
- **Database:** `sqflite` (Local SQLite database)
- **UI/Charts:** `fl_chart`, `google_fonts`, `flutter_animate`, and `shimmer` for a premium user experience
- **Native Utilities:** `local_auth` for security, `share_plus` and `csv` for data export
