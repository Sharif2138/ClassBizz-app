# ClassBizz

ClassBizz is a modern classroom engagement and session management system designed for lecturers and students. It enables real‑time session participation, live leaderboards, reviews, and performance tracking across multiple sessions.

---

##  Features

###  **User Authentication**

The app includes a full authentication flow under the `screens/authentication/` directory:

* Email & password login
* Google Sign‑In
* Registration
* Password recovery

###  **Sessions Management**

Lecturers can:

* Create sessions
* Start/end sessions
* Monitor live participation
* View attendees and award points

Students can:

* Join a session
* Earn points
* View progress live
* Leave and rejoin with session‑specific points preserved

###  **Reviews System**

Each **session document** contains a **subcollection `reviews`**, where students can leave:

* A star rating (1–5)
* A written description

Lecturers can view all reviews under the session.

Firestore structure:

```
sessions/
  sessionId/
    attendees/
      uid
    reviews/
      reviewId
```

### **Points System**

There are two levels of points:

* **User points** → Total points across all sessions
* **Attendee points** → Points earned within a specific session

When a student joins a session:

* Their attendee record begins at 0
* Points accumulate live
* Using `FieldValue.increment`, points are synced both to the attendee and user profiles

When a student leaves and rejoins:

* They keep their previous session points
* Their global user points remain unchanged unless new points are awarded

---

## Project Structure

```
lib/
 ├── models/
 ├── providers/
 ├── services/
 ├── screens/
 │    ├── authentication/
 │    ├── student/
 │    ├── lecturer/
 │    ├── widgets
 │    └── shared/
 
```

---

## Getting Started

### 1 Clone the repository

```
git clone <repo-url>
cd classbizz
```

### 2 Install dependencies

```
flutter pub get
```

### 3 Configure Firebase

* Add `google-services.json` (Android)
* Add `GoogleService-Info.plist` (iOS)
* Enable Firestore, Authentication & Google Sign‑In

### 4 Run the app

```
flutter run
```

---

## 🧪 Firestore Collections Overview

```
users/
  uid
sessions/
  sessionId
    attendees/
      uid
    reviews/
      reviewId
```

---

##  Screens Overview

### Authentication

Stored in `screens/authentication/`:

* LoginScreen
* RegisterScreen
* EmailVerifcationScreen
* GoogleSignIn integration

### Student Screens

* Dashboard
* Join Session Dialog
* Live Leaderboard
* Review Screen
* Profile
* Leaderboard

### Lecturer Screens

* Dashboard
* Create Session
* Manage Live Session
* Profile
* Session Reviews
* live leaderboard

---

##  Tech Stack

* **Flutter** (UI)
* **Firebase Auth**
* **Cloud Firestore**
* **Provider** for state management

---

