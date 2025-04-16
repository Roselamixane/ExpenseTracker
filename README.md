<p align="center">
  <img width="140" src="lib\assets\icon\appLogo.png" />  
  <h1 align="center">Wealthify</h1>
  <h3 align="center">An User friendly financial management app for expense tracking and budgeting built with automated transaction recording features.</h3>
</p>


<p align="center">
  <a href="#" alt="Version"><img src="https://img.shields.io/badge/Version-1.0.4-brightgreen.svg?style=for-the-badge" /></a>
<!--   <a href="https://github.com/rahulpalanivel/Wealthify/blob/master/LICENSE" alt="Version"><img src="https://img.shields.io/badge/License-MIT-brightgreen.svg?style=for-the-badge" /></a> -->
  <a href="https://github.com/rahulpalanivel/Wealthify/releases" alt="Version"><img src="https://img.shields.io/badge/Download-apk-blue?style=for-the-badge" /></a>
</p>

## About

Wealthify is an app built primarly for expense tracking and budgeting, it is designed to fulfill all the requirements of an expense tracker with a simple and user-friendly interface. The user has options to automate the primary task of manually recording transactions leading to an efficient and smooth user-experiance. The app is cross platform developed using the flutter sdk and Dart language. All the transaction details and records are stored locally within the device using hive database. Provider state management is used to maintain the flow of data. The app runs completely offline and requires no network access. Various graphs are used for better visualization of transactions which can be further categorized by Year, month and day. Users can also set budgets for various transaction categories chosen for a specific month or year. Users can manually add new transaction records or the app can automate the process by either processing the users bank statement or by processing the payment confirmation sms sent from users Bank(both requires permission from user). Overall the app aims to provide an efficient way to analyze and visualize the users financial transactions, while ensuring a smooth experience.

## Screenshots

<table>
    <tr>
        <td>First Screen </td>
        <td>Home Page</td>
        <td>Summary Page</td>
    </tr>
    <tr>
        <td><img src="lib\assets\screenshots\ss2.jpg" width=270 height=525></td>
        <td><img src="lib\assets\screenshots\ss3.jpg" width=270 height=525></td>
        <td><img src="lib\assets\screenshots\ss1.jpg" width=270 height=525></td>
    </tr>
</table>

<table>
    <tr>
        <td>Transactions by Category </td>
        <td>Transactions by Month</td>
        <td>Transactions by Date</td>
    </tr>
    <tr>
        <td><img src="lib\assets\screenshots\ss4.jpg" width=270 height=525></td>
        <td><img src="lib\assets\screenshots\ss7.jpg" width=270 height=525></td>
        <td><img src="lib\assets\screenshots\ss8.jpg" width=270 height=525></td>
    </tr>
</table>

<table>
    <tr>
        <td>Transactions Records </td>
        <td>Budgeting</td>
    </tr>
    <tr>
        <td><img src="lib\assets\screenshots\ss6.jpg" width=270 height=525></td>
        <td><img src="lib\assets\screenshots\ss5.jpg" width=270 height=525></td>
    </tr>
</table>

## Features

- Analyze financial transactions by year/month/day.
- Graphs to help with visualizing transactions.
- Automated the process of adding new transaction records by:
  - Processing and extracting data from users bank statements.
  - Reading payment confirmation sms sent from users Bank.
  - Both process above require user permission.
- Completely offline, all data is stored locally on user device.
- Budgeting feature to help manage transactions efficiently.

## Demo

https://github.com/user-attachments/assets/21f16e68-7c97-448e-98bb-7f45168503b4

## Tech Stack

**Language:** Dart

**Framework:** Flutter

**Database:** Hive

**State Management:** Provider

## Permission

Requires users permission to:

- read contents of local storage
- read users text messages (sms)

## Support

For any support or help, feel free to reach out via email palanivelrahul45@gmail.com .
