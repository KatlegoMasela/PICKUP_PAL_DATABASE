# PickUpPal Database 

**PickUpPal** is a Smart Scholar Transport Monitoring Solution developed to provide a secure, scalable, and user-friendly platform for managing school transportation in South Africa. It enables real-time student tracking, verified driver management, seamless parent-driver communication, and financial processing within a centralized system.

---

## Key Features

- **Verified Driver & Vehicle Management**  
  Secure onboarding and verification for all drivers and vehicles.

- **Real-Time Attendance Monitoring**  
  Accurate tracking of student pickups and drop-offs.

- **Direct Communication**  
  In-app messaging between parents, drivers, and administrators.

- **Emergency SOS System**  
  Immediate alerts triggered by drivers in emergency scenarios.

- **Payment Processing**  
  Multiple secure payment options and automated billing.

- **Rating & Feedback System**  
  Parents can review and rate trip experiences.

- **Dynamic Scheduling**  
  Accommodates multiple time zones and flexible route planning.

---

## Database Structure

### Core Modules

#### User Management
- Centralized user table for parents, drivers, and administrators  
- Linked student profiles with parent mappings  
- Emergency contact storage and verification tracking  

#### Fleet Management
- Vehicle specifications and assignments  
- Route and shift scheduling  
- School information including contact data  

#### Trip Management
- Scheduled and historical trip data  
- Stop-by-stop trip location tracking  
- Attendance records for each student  

#### Financial System
- Secure parent payments and driver payouts  
- Route-based fare structure  
- Saved payment methods for convenience  

#### Communication & Safety
- In-app messaging system for all users  
- Real-time alerts and emergency triggers  
- Post-trip feedback from parents  

#### Security & Compliance
- Document storage for user verification  
- Full audit trail of system activity  
- User creation tracking and event logging  

---

## Technology Stack

- **Database**: MySQL, MySQL Workbench


---

## Installation & Setup

### Prerequisites
- MySQL server with administrative privileges  
- Secure access credentials and role-based permissions  

### Setup Steps
- Create the PickUpPal database  
- Run the full schema creation script to set up tables and relationships  
- Load sample data for testing and development  
- Enable automated events for scheduled tasks  

---

## User Roles & Permissions

### Admin
- Full access to all data and configurations  
- User and system management  
- Access to system-wide reports  

### Driver
- View assigned trips  
- Log attendance and send alerts  
- Communicate with parents and admins  

### Parent
- View trip schedules and student status  
- Make secure payments  
- Rate trips and communicate with drivers  

---

## Stored Procedures

- **User Management**: Handles registration and email validation  
- **Trip Booking**: Assigns trips based on route and availability  
- **Reporting**: Generates trip summaries and attendance logs  
- **Financial Calculations**: Automates driver payouts and fare calculations  

---

## Triggers & Automation

- Enforce data validation (e.g., phone numbers)  
- Auto-update trip statuses based on attendance  
- Calculate payments automatically  
- Log all user activity and account creation events  
- Identify missed pickups on a scheduled basis  

---

## Security Features

- AES-based encryption for sensitive data like emails and phone numbers  
- Role-based access control to restrict permissions  
- Comprehensive audit logs for user and system actions  
- Secure key management for encrypted fields  

---

## Scheduling & Location Management

- Support for multiple time zones and shift types  
  - Early shift (e.g., 7:00 AM – 2:00 PM)  
  - Late shift (e.g., 8:30 AM – 3:30 PM)  
  - After-school care (e.g., 4:00 PM – 6:00 PM)  

- Flexible pickup/drop-off locations including home, daycare, or temporary sites  

---

## Payment System

### Supported Methods
- Credit and debit cards  
- Mobile wallets (e.g., Vodacom MPesa, MTN Mobile Money)  
- Bank transfers  

### Features
- Automated monthly billing  
- Transparent pricing with upfront estimates  
- Secure driver payouts  
- No hidden fees  

---

## Sample Data Coverage

The sample database includes:

- 30+ user profiles (parents, drivers, admins)  
- 30+ student records with school assignments  
- 30+ verified drivers with vehicle mapping  
- Predefined routes and schedules  
- Communication logs, alerts, and financial transactions  
- Full audit and system logs  

---

## Future Enhancements

- **AI Integration**  
  - Predictive analytics for route optimization  
  - Trip delay forecasting  
  - Intelligent route-student matching  

- **Advanced Features**  
  - Real-time GPS tracking  
  - Push notifications in mobile apps  
  - Integration with school management systems  
  - Advanced analytics and reporting dashboard  

---

## Support & Maintenance

- Regular data backups and recovery plans  
- Index tuning and query optimization  
- Security updates and patching  
- Real-time system monitoring and alerting  

