{\rtf1\ansi\ansicpg1252\cocoartf2870
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;\f1\fnil\fcharset0 HelveticaNeue-Bold;\f2\fnil\fcharset0 Menlo-Regular;
\f3\fnil\fcharset0 HelveticaNeue;\f4\fnil\fcharset0 .AppleSystemUIFontMonospaced-Regular;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
{\*\listtable{\list\listtemplateid1\listhybrid{\listlevel\levelnfc23\levelnfcn23\leveljc0\leveljcn0\levelfollow0\levelstartat1\levelspace360\levelindent0{\*\levelmarker \{disc\}}{\leveltext\leveltemplateid1\'01\uc0\u8226 ;}{\levelnumbers;}\fi-360\li720\lin720 }{\listname ;}\listid1}}
{\*\listoverridetable{\listoverride\listid1\listoverridecount0\ls1}}
\paperw11900\paperh16840\margl1440\margr1440\vieww34000\viewh18800\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 \
A comprehensive healthcare solution designed for maternal health monitoring and risk assessment during pregnancy. This project includes AI-powered risk prediction for pregnant women and healthcare provider management interfaces, built with Flutter for cross-platform mobile deployment.\
\
## Stack\
\
- **Language(s):** Dart, Flutter\
- **Framework / runtime:** Flutter (latest stable), Dart SDK 3.12.2+\
- **Notable libraries:** \
  - `flutter_riverpod` (3.3.2) - State management\
  - `go_router` (14.0.0+) - Navigation and routing\
  - `onnxruntime` (1.4.1) - On-device ML inference for pregnancy risk prediction\
  - `fl_chart` (0.69.0) - Data visualization for health metrics\
  - `google_fonts` (6.2.1+) - Typography\
\
## Overview\
\
This repository contains **three independent Flutter applications** for a maternal health monitoring ecosystem:\
\
1. **MaternalCare (flutter-app-main)** - Core healthcare provider/ASHA worker application with AI-powered pregnancy risk assessment\
2. **Patient App (patient_app_maai-main)** - Patient-facing application for expecting mothers\
3. **MaAAi (MAAAi-main)** - Additional health services module\
\
\
**How it fits together:**\
\
The MaternalCare app serves as the core provider interface with AI-powered risk assessment leveraging an ONNX-based pregnancy risk model. Using Riverpod for reactive state management and Go Router for structured navigation, the app guides healthcare workers through patient data collection and displays risk-stratified insights. The Patient App provides a complementary interface for expecting mothers to monitor their health journey, while MaAAi handles specialized health service workflows.\
\
## How to run it\
\
### Prerequisites\
- Flutter SDK (latest stable recommended)\
- Dart SDK 3.12.2+ (included with Flutter)\
- Android Studio or VS Code with Flutter extensions\
- Android SDK / iOS deployment tools (as needed)\
- Git\
\
### Get Started\
\
1. **Clone the repository:**\
   ```bash\
   git clone https://github.com/sachinyadavcoder/Hack4Humanity-Hackathon-project\
   cd Hack4Humanity-Hackathon-project\
2. Verify Flutter Installation\
flutter doctor\
\
3.Run MaternalCare App:\
	-cd flutter-app-main\
	flutter pub get\
	flutter run\
\
4. Run patient app:\
	cd patient_app_maai-main\
	flutter pub get\
	flutter run\
\
5. For release builds\
	flutter build apk       # Android\
	flutter build ios       # iOS (macOS only)\
\
\pard\pardeftab560\sa40\partightenfactor0

\f1\b\fs32 \cf0 Features\
\pard\pardeftab560\pardirnatural\partightenfactor0
\ls1\ilvl0
\f2\b0\fs18 \cf0 {\listtext	\uc0\u8226 	}
\f1\b\fs26 AI-Powered Risk Assessment:
\f3\b0 \'a0On-device ML inference using ONNX runtime for pregnancy risk prediction\
\ls1\ilvl0
\f2\fs18 {\listtext	\uc0\u8226 	}
\f1\b\fs26 Provider Dashboard:
\f3\b0 \'a0Healthcare worker interface for patient data management\
\ls1\ilvl0
\f2\fs18 {\listtext	\uc0\u8226 	}
\f1\b\fs26 Patient Monitoring:
\f3\b0 \'a0Health tracking and alert system for expecting mothers\
\ls1\ilvl0
\f2\fs18 {\listtext	\uc0\u8226 	}
\f1\b\fs26 Cross-Platform:
\f3\b0 \'a0Deploy on Android and iOS with a single codebase\
\ls1\ilvl0
\f2\fs18 {\listtext	\uc0\u8226 	}
\f1\b\fs26 Modern UI:
\f3\b0 \'a0Material Design with custom theming and Google Fonts integration\
\ls1\ilvl0
\f2\fs18 {\listtext	\uc0\u8226 	}
\f1\b\fs26 State Management:
\f3\b0 \'a0Efficient Riverpod-based reactive architecture\
\pard\pardeftab560\partightenfactor0

\f2\fs18 \cf0   \'95	
\f1\b\fs26 Data Visualization:
\f3\b0 \'a0Charts and graphs for health metrics via fl_chart\
\
\
\
---\
\
# MAAAi-main: Doctor Dashboard Platform\
\
##Overview\
The MAAAi-main project is a full-stack application featuring an AI-powered doctor dashboard system. It provides healthcare professionals with tools to manage patients, track recommendations, schedule appointments, and receive notifications.\
\
### Tech Stack\
\
**Backend:**\
- **Runtime:** Node.js\
- **Framework:** Express.js\
- **Database:** MongoDB with Mongoose ODM\
- **Authentication:** JWT (JSON Web Tokens)\
- **Security:** bcryptjs for password hashing\
- **Email:** Nodemailer\
- **File Upload:** Multer\
- **Development:** Nodemon\
- **Utilities:** CORS, Morgan logging, dotenv\
\
**Frontend:**\
- **Framework:** React 18.3.1\
- **Build Tool:** Vite 6.0.7\
- **Styling:** Tailwind CSS 3.4.17\
- **Forms:** React Hook Form 7.54.2\
- **Routing:** React Router DOM 6.28.1\
- **HTTP Client:** Axios 1.7.9\
- **Data Visualization:** Recharts 2.15.0\
- **Tables:** React Table 7.8.0\
\
### Project Features\
\
#### Backend Features (`MAAAi-main/backend`)\
- **Authentication System** - User registration, login, JWT token management\
- **Patient Management** - CRUD operations for patient profiles and records\
- **AI Recommendations** - Algorithm-based health recommendations\
- **Notification System** - Real-time alerts and updates\
- **Appointment Management** - Schedule and manage doctor appointments\
- **Doctor Profiles** - Professional profiles and specializations\
- **Dashboard Analytics** - Comprehensive health metrics and statistics\
\
#### Frontend Features (`MAAAi-main/frontend`)\
- **Doctor Dashboard** - Central hub for managing patients and tasks\
- **Patient Directory** - View and search patient information\
- **Appointment Calendar** - Visual appointment scheduling\
- **Analytics Dashboard** - Real-time health metrics and charts\
- **Recommendation Engine** - AI-powered health suggestions\
- **Notification Center** - Alert management\
- **Responsive Design** - Mobile and desktop compatible UI\
\
\pard\pardeftab560\slleading20\partightenfactor0

\f4\fs24 \cf0 ### API Routes\
\
The backend provides the following API endpoints:\
\
- `/auth` - Authentication (login, register, token validation)\
- `/dashboard` - Dashboard statistics and analytics\
- `/patients` - Patient CRUD operations\
- `/recommendations` - Health recommendations\
- `/notifications` - Notification management\
- `/profile` - Doctor profile management\
- `/appointments` - Appointment scheduling and management\
\
### Installation & Setup\
\
#### Backend Setup\
\
```bash\
cd MAAAi-main/backend\
\
# Install dependencies\
npm install\
\
# Create .env file with required variables\
# PORT=5000\
# MONGODB_URI=your_mongodb_uri\
# JWT_SECRET=your_jwt_secret\
# CLIENT_ORIGIN=http://localhost:5173\
\
# Run development server\
npm run dev\
\
# Run with production server\
npm start\
}