# ♾️ Acessibilizando

**Technology for a more accessible, inclusive, and equal world.**

## ♾️ About the project

Acessibilizando is a project created with the purpose of making information about accessibility in public and private places more accessible to the people who need it.

The project uses technology to help people find places that meet their accessibility needs, while also allowing the community to share experiences, ratings, and information about those places.

The project has a particular focus on the needs of autistic people, considering aspects that are often overlooked by traditional approaches to accessibility.

> 🧩 Accessibility is not a privilege. It is a right.

## 🧩 Autism and accessibility

Acessibilizando aims to contribute to a world where people with different needs can participate in society with autonomy, safety, dignity, and equality.

For autistic people, aspects such as:

* 🔊 Noise levels
* 💡 Sensory stimuli
* 🧩 Environmental characteristics
* ♿ Physical accessibility
* 🧠 Environmental predictability
* 🗣️ Communication and service

can significantly affect their experience in a particular place.

The goal is not to define which places are "good" or "bad", but to provide useful information so each person can make their own decisions according to their individual needs.

## 🌎 Our values

### ⚖️ Equality

Everyone should have equal opportunities to participate in society, regardless of their characteristics or needs.

### ♿ Accessibility

Accessible information is a fundamental part of an accessible society.

### 🧩 Inclusion

Differences should never become barriers to social participation.

### 🤝 Respect

Every person has different needs, experiences, and perspectives. Those differences deserve respect.

### 🧠 Neurodiversity

Neurological diversity is part of human diversity. The project aims to contribute to a society that recognizes and respects different ways of experiencing and interacting with the world.

### 🔓 Autonomy

Information should empower people to make their own decisions rather than make those decisions for them.

### 🌱 Community

Acessibilizando is designed as a tool built with the community and for the community.

## 🗺️ How it works

The core idea is to allow users to discover places and access information related to their accessibility.

The main architecture is:

```text
                    🧑 User
                       │
                       ▼
                📱 Mobile App
                 Flutter / Dart
                       │
                       │ HTTP / JSON
                       ▼
                 🌐 REST API
                Django + DRF
                       │
                       ▼
                 🗄️ PostgreSQL
```

Places can be associated with accessibility information and reviewed by users.

The overall rating of a place is calculated from community reviews, allowing different users to contribute to a collective understanding of that location.

## 📍 Places

Acessibilizando separates the identity of a place from the accessibility information associated with it.

This approach allows the system to evolve and support different types of accessibility information and criteria without requiring the entire data structure to be rebuilt.

The project can store different characteristics related to accessibility and the user's experience at a particular place.

## ⭐ Reviews

Reviews are an important part of the collaborative nature of Acessibilizando.

Any user can review a place.

The final rating of a place is based on the average of the community's reviews.

Each user remains responsible for managing their own review.

> 💬 One person's experience can help another person decide whether a place is suitable for their needs.

## 🛠️ Technologies

The project uses a separated architecture consisting of a mobile application, REST API, and database.

### 📱 Mobile

* Dart
* Flutter

The mobile application is responsible for the user interface and communication with the API.

### 🐍 Backend

* Python
* Django
* Django REST Framework (DRF)

The backend handles business logic, authentication, user management, places, reviews, and accessibility information.

The API follows a REST architecture, allowing different clients to consume the same data.

### 🗄️ Database

* PostgreSQL

PostgreSQL is used as the main database of the application.

The choice provides a solid foundation for the project's growth, considering the need to store users, places, reviews, and different types of accessibility information.

## 🏗️ Architecture

The project follows an API-oriented architecture:

```text
┌─────────────────────────────┐
│       📱 Flutter App        │
│           Dart              │
└──────────────┬──────────────┘
               │
               │ HTTP / JSON
               ▼
┌─────────────────────────────┐
│       🌐 REST API           │
│     Django + DRF            │
│                             │
│  • Authentication           │
│  • Users                    │
│  • Places                   │
│  • Accessibility            │
│  • Reviews                  │
└──────────────┬──────────────┘
               │
               │ ORM
               ▼
┌─────────────────────────────┐
│       🗄️ PostgreSQL         │
└─────────────────────────────┘
```

This separation allows each layer of the project to evolve independently.

## 🚧 Project status

🚀 **In development**

Acessibilizando is being developed incrementally.

New accessibility criteria, features, and improvements will be introduced as the project evolves.

## 🎯 Goals

The project aims to:

* ♿ Make accessibility information easier to access
* 🧩 Contribute to the inclusion of autistic people
* 🤝 Encourage community collaboration
* 🌎 Make information about places more accessible
* 🧠 Consider different sensory and accessibility needs
* ⚖️ Promote equality and autonomy
* 💻 Use technology to address a real social problem

## ❤️ Why "Acessibilizando"?

The name represents a simple idea:

> **We are making the world more accessible, one place at a time.**

Accessibility should not be something considered only after a problem appears.

It should be part of the way we build spaces, services, and technologies from the beginning.

## 🤝 Contributing

Acessibilizando believes in the power of community.

Contributions, suggestions, ideas, and constructive criticism are welcome.

If you believe technology can help build a more accessible and inclusive society, you are part of the idea behind this project.

## 📜 License

To be defined.
