# MaternalCare – AI-Powered Maternal Health Monitoring System

A comprehensive healthcare solution designed for maternal health monitoring and risk assessment during pregnancy. This project includes AI-powered risk prediction for pregnant women and healthcare provider management interfaces, built with Flutter for cross-platform mobile deployment.

---

# Tech Stack

### Languages
- Dart
- JavaScript

### Flutter
- Flutter (Latest Stable)
- Dart SDK 3.12.2+

### Flutter Packages
- `flutter_riverpod` – State Management
- `go_router` – Navigation & Routing
- `onnxruntime` – On-device AI inference
- `fl_chart` – Health data visualization
- `google_fonts` – Typography

---

# Project Structure

This repository contains **three independent applications**:

## 1. MaternalCare (`flutter-app-main`)
Healthcare provider / ASHA worker application with AI-powered pregnancy risk assessment.

## 2. Patient App (`patient_app_maai-main`)
Patient-facing application for expecting mothers to monitor their pregnancy.

## 3. MAAAi (`MAAAi-main`)
Doctor dashboard and healthcare management platform.

---

# How It Works

The **MaternalCare** app serves as the primary interface for ASHA workers and healthcare providers.

It uses:

- ONNX Runtime for on-device pregnancy risk prediction
- Riverpod for state management
- Go Router for navigation

Healthcare workers collect patient information, perform screening, and receive AI-generated pregnancy risk predictions.

The **Patient App** allows expecting mothers to monitor their pregnancy journey.

The **MAAAi Dashboard** enables doctors to monitor patients, manage appointments, and review recommendations.

---

# Getting Started

## Prerequisites

- Flutter SDK (Latest Stable)
- Dart SDK 3.12.2+
- Android Studio / VS Code
- Android SDK or iOS tools
- Git

---

# Clone Repository

```bash
git clone https://github.com/sachinyadavcoder/Hack4Humanity-Hackathon-project

cd Hack4Humanity-Hackathon-project
```

---

# Verify Flutter

```bash
flutter doctor
```

---

# Run MaternalCare App

```bash
cd flutter-app-main

flutter pub get

flutter run
```

---

# Run Patient App

```bash
cd patient_app_maai-main

flutter pub get

flutter run
```

---

# Build Release APK

```bash
flutter build apk
```

For iOS (macOS only):

```bash
flutter build ios
```

---

# Features

- AI-powered pregnancy risk prediction
- Healthcare provider dashboard
- Patient monitoring
- Cross-platform support (Android & iOS)
- Material Design UI
- Riverpod architecture
- Interactive health charts

---

# MAAAi – Doctor Dashboard Platform

## Overview

MAAAi is a full-stack doctor dashboard platform that allows healthcare professionals to manage patients, appointments, notifications, and AI-generated recommendations.

---

# Backend

### Tech Stack

- Node.js
- Express.js
- MongoDB
- Mongoose
- JWT Authentication
- bcryptjs
- Nodemailer
- Multer
- Nodemon
- CORS
- Morgan
- dotenv

---

# Frontend

### Tech Stack

- React 18
- Vite
- Tailwind CSS
- React Hook Form
- React Router
- Axios
- Recharts
- React Table

---

# Backend Features

- User Authentication
- Patient Management
- AI Recommendations
- Notification System
- Appointment Scheduling
- Doctor Profiles
- Dashboard Analytics

---

# Frontend Features

- Doctor Dashboard
- Patient Directory
- Appointment Calendar
- Analytics Dashboard
- Recommendation Engine
- Notification Center
- Responsive UI

---

# API Routes

| Endpoint | Description |
|----------|-------------|
| `/auth` | Authentication |
| `/dashboard` | Dashboard statistics |
| `/patients` | Patient CRUD |
| `/recommendations` | AI Recommendations |
| `/notifications` | Notifications |
| `/profile` | Doctor Profile |
| `/appointments` | Appointment Management |

---

# Backend Installation

```bash
cd MAAAi-main/backend

npm install
```

Create a `.env` file:

```env
PORT=5000
MONGODB_URI=your_mongodb_uri
JWT_SECRET=your_jwt_secret
CLIENT_ORIGIN=http://localhost:5173
```

Run development server:

```bash
npm run dev
```

Run production server:

```bash
npm start
```
