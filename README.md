# Ivoire-Jobs

## Team Members

| Github Handle | Name                       |
|---------------|----------------------------|
| popokola      | Charles Parameswaralingam  |
| JustGritt     | Alexis Tan                 |
| alexdieudonne | Alexandre Sebon Dieudonne  |
| WhaleAid      | Walid Khalqallah           |

## Details of Features

### GOLANG

#### Alexandre Sebon Dieudonne
- Setup project structure
- Login
- Register
- Logger setup
- User Model, User Repository
- JWT, password utility, basic configurations, and basic validator setup
- Auth middleware for user
- Helper Controller abstraction for all controllers

#### Alexis Tan
- Ban controller: full CRUD + Model + Repository
- Report controller: full CRUD + Model + Repository
- Member controller: full CRUD + Model + Repository
- Rating controller: full CRUD + Model + Repository
- Seeder for dev database

#### Walid Khalqallah
- Setup Swagger
- Category controller: full CRUD + Model + Repository
- Contact Model + Repository
- NotificationPreference controller: full CRUD + Model + Repository (pair programming with Charles)
- Templates for emails

#### Charles Parameswaralingam
- S3 service, Mailer service, Notification service, Stripe service and setup of all config objects for them
- CronJob
- Command for seeder
- Websocket controller
- Stripe controller
- Room controller: full CRUD + Model + Repository
- Refresh controller: full CRUD + Model + Repository
- Notification controller: full CRUD + Model + Repository
- Log controller: full CRUD + Model + Repository
- DashboardStat controller: full CRUD + Model + Repository
- Configuration controller: full CRUD + Model + Repository
- Booking controller: full CRUD + Model + Repository
- Service controller: full CRUD + Model + Repository
- Custom Validator and App middleware for feature flipping

### FLUTTER

#### Charles Parameswaralingam
- Admin refactor structure
- Landing Page of App: [Ivoire-Jobs](https://ivoire-jobs.vercel.app)
- Dashboard Page in admin panel
- Settings Page in admin panel
- Guard for routes and Admin Login and Logout using BLoC
- Manage Teams: see and create new admin for the app
- Trending Section in APK
- Notification Preference in APK (enable push notifications, etc.)

#### Walid Khalqallah
- Partie members dashboard admin
- Approuver ou rejeter les demandes de devenir prestataire
- Page categories sur la dashboard
- écran booking
- Admin logs & pagination
- Service workflow
- Bookings workflow
- Bug Fix
