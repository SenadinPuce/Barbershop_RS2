# Barbershop Management System

This project is a comprehensive solution for barbershop management, featuring a desktop application developed using Flutter for employee management and a Flutter-based mobile app tailored for client interactions. 
The backend architecture consists of a primary .NET Web API serving as the central backend for the desktop and mobile applications. Additionally, a separate .NET Web API is dedicated specifically to the email notification service.

Communication between components is facilitated through RabbitMQ messaging, enabling efficient event-based interactions. 
The main .NET Web API handles core business logic and data management, while the separate email notification service API manages and dispatches email alerts triggered by system events.

For testing purposes, the email notification service uses the following credentials to authenticate with the email server:

Email: 
>barbershop_rs2@outlook.com
Password: 
>Barbershop!
>
These credentials are employed to verify the functionality of the email sending process within the system.

All data is stored and managed in a SQL Server database, ensuring a reliable and scalable foundation for the entire system.

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

## Outlook mail credentials 


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





