# Internal Corporate Application

## Overview

This application is designed for **internal corporate use**. It provides a unified platform for employee authentication, access to corporate services, AI-powered assistance, and an internal news feed.

The system is built with a modern microservice-friendly architecture, secure authentication, and scalable data handling.

---

## Architecture & Core Technologies

- **Authentication & Authorization**
  - Full authentication flow via **Keycloak**
  - Keycloak runs in a **separate container**
  - Users authenticate using **login and password**
  - After successful authentication, an **access token** is issued to the client
  - All further requests are authorized using this token

- **API**
  - Communication between client and backend is performed via **GraphQL**
  - All GraphQL requests require a valid `access_token`

- **Data Storage**
  - **PostgreSQL** — persistent storage for user and application data
  - **Redis** — caching layer to improve performance and reduce database load

- **External Integrations**
  - Integration with a corporate website to retrieve the **news feed**
  - Integration with external enterprise systems:
    - **Bitrix**
    - **Directum**

---

## Application Sections

### 🏠 Home
- Displays the **corporate news feed**
- News is retrieved via integration with the external website

### 🤖 AI
- AI-powered **agents for corporate assistance**
- Designed to help employees with internal processes, information, and tasks

### 🧩 Services
- Centralized access to **external corporate services**
- Current integrations include:
  - Bitrix
  - Directum

### 👤 Profile
- **Employee profile card**
- Stores and displays user-related information from the system

---

## Security

- Authentication handled exclusively by **Keycloak**
- No credentials are stored on the client
- Access to APIs is protected via **JWT access tokens**
- Role-based and token-based access control can be extended via Keycloak

---

## Intended Usage

⚠️ This application is intended **only for internal corporate use** and is not designed for public access.

---

## Notes

- The system is containerized and designed for deployment in a controlled internal environment
- The architecture allows easy extension with new services, integrations, and AI agents

---

