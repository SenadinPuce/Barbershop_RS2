# Barbershop Management System

This project is a comprehensive solution for barbershop management. It includes a desktop application built with Flutter for employees and a mobile app for clients, also developed in Flutter. The backend is powered by a .NET Web API, with communication facilitated through RabbitMQ. A console application serves as an email notification service, triggered by RabbitMQ events. The system utilizes a SQL Server database for data storage.

## Login Credentials

### Mobile App
- **Username:** mobile
- **Password:** test

### Desktop App

#### Administrator Login
- **Username:** desktop
- **Password:** test

#### Employee Logins
- **Username:** barber1
- **Password:** test

- **Username:** barber2
- **Password:** test

## How to Start the Applications

### 1. Clone the Repository
Clone the repository to your local machine using Git:
```
git clone https://github.com/SenadinPuce/Barbershop_RS2.git

```

### 2. Start the Project with Docker
Use Docker to start the project by navigating to the root directory and typing:
```
docker-compose up --build

```

### 3. Open the Flutter Applications
Navigate to the respective directories for the mobile and desktop applications:

For the mobile app:
```
cd UI/barbershop_mobile

```

For the desktop app:
```
cd UI/barbershop_admin

```

### 4. Fetch dependencies using Flutter:
```
flutter pub get

```

### 5. Run the Flutter applications:
```
flutter run

```


## Payment Integration (Stripe)

Below is a test card number that you can use during checkout:

- **Card Number:**
  ```
  4242 4242 4242 4242

  ```
- **Expiration Date:** Any future date
- **CVC:** Any 3-digit number

>[!NOTE]
>To simulate successful payments, use the provided test card number. For more information about testing with Stripe, refer to their [documentation](https://stripe.com/docs/testing). 

>[!CAUTION] 
>Please ensure you are in a test environment and do not use real payment information during testing.





