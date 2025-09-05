LegitCheck: AI-Powered Financial Safety for Indian Investors

LegitCheck is a mobile application built with Flutter that empowers Indian retail investors to combat financial fraud. It provides two core features: instant offline verification of SEBI-registered professionals and an AI-powered credibility check for corporate announcements using the Gemini API.

🌟 Core Features
LegitCheck offers a powerful, two-in-one verification system to protect investors from common fraudulent activities.

1. Instant SEBI Verification
Instantly verify if any investment adviser, stock broker, or portfolio manager is officially registered with the Securities and Exchange Board of India (SEBI).

Offline First: The verification works without an internet connection, using a comprehensive on-device database.

Multi-Language Support: Full support for English, Hindi, Tamil, Telugu, Kannada, and Marathi.

Advanced Filtering: Easily filter results by professional category to find exactly who you're looking for.

2. AI Credibility Analysis
Paste any corporate announcement or news article into the app for an instant, AI-powered analysis.

Real-time AI Scoring: A secure back-end powered by the Gemini API provides a clear credibility score (High, Low, or Unverifiable).

Detailed Justification: The AI provides a clear, bulleted list of reasons for its score, helping users spot red flags, unrealistic claims, and promotional language.

Serverless & Scalable: The back-end is built as a serverless function on Google Cloud Run, ensuring it's fast and cost-effective.

🛠️ Tech Stack
This project uses a modern, cross-platform stack to deliver a robust user experience.

Component

Technology

Front-End

Flutter, Dart

Back-End

Python, Flask, Gunicorn

Deployment

Google Cloud Run (Serverless)

AI

Google Gemini API

Database

SQLite (for offline on-device asset databases)

Localization

flutter_localizations, intl

🚀 Getting Started
To get a local copy up and running, follow these simple steps.

Prerequisites
Flutter: Ensure you have the Flutter SDK installed.

Python: Python 3.7+ is required for the back-end.

Google Cloud SDK: Required for deploying the back-end.

Front-End (Flutter App) Setup
Clone the repository:

git clone [https://github.com/your-username/legitcheck.git](https://github.com/your-username/legitcheck.git)
cd legitcheck

Install dependencies:

flutter pub get

Run the app:

flutter run

Back-End (Python/Flask) Setup
Navigate to the backend directory:

cd legitcheck_backend

Install Python packages:

pip install -r requirements.txt

Set the Gemini API Key:

On Mac/Linux:

export GEMINI_API_KEY="YOUR_API_KEY"

On Windows:

set GEMINI_API_KEY="YOUR_API_KEY"

Run the local server:

python app.py

The server will be running at http://localhost:8080.

☁️ Deployment
The back-end is designed to be deployed as a serverless container on Google Cloud Run. Once the Google Cloud SDK is configured, you can deploy the entire back-end with a single command from the legitcheck_backend directory:

gcloud run deploy legitcheck-backend --source . --region asia-south1 --allow-unauthenticated --set-env-vars=GEMINI_API_KEY="YOUR_API_KEY"

License
This project is licensed under the MIT License - see the LICENSE file for details.
