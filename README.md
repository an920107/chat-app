# Chat APP

## Description

A simple chat app for the assignment of Line intern.

## Feature

- Chat rooms and history are based on account.

  - The first-time users can create an account by email, password, and a display name.

  - Users can create chat rooms by searching for others' email.

- The data are stored in Firebase.

  > There are security rules set up for Firestore, so [`firebase_options.dart`](lib/firebase_options.dart) being public is okay.

  - Chat history can be restored at any device.

- Offline chat history.

  - Because the data is also stored in local database, the user can still access the chat history although there is no network.

## Development

- There is a workflow (CI) set up for this repository.

  - When a **pull requests opened**, it will run `flutter analyse` to check the basic coding rules.

  - When a **tag pushed**, it will run checks mentioned before, and then build the apk file and release it.

- The design pattern is **MVVM**.
