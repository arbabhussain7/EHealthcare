# Ehealthcare App 🏥

The Ehealthcare app revolutionizes healthcare by connecting patients with doctors, pharmacists, riders, and administrators, offering seamless video consultations and medication delivery. Built using GetX state management and the MVC architecture, the app ensures an efficient and user-friendly experience for both patients and healthcare providers.

## Features

- **Patient Registration with OTP**: Secure onboarding using OTP authentication.
- **Doctor Selection & Consultation**: Patients can browse categories, select doctors, schedule appointments, and make payments.
- **Video Consultations**: Integrated Google Meet links for virtual consultations.
- **Pharmacy Orders**: Patients can order prescribed medicines directly from the app.
- **Medicine Delivery**: Shipment tracking feature for timely delivery of medicines by riders.
- **Role-Based Functionality**: Separate workflows for doctors, patients, pharmacists, riders, and admins.

## Technologies Used

- **Flutter** & **Dart**: For app development.
- **Firebase**: Backend for authentication, data storage, and real-time updates.
- **GetX**: State management for handling app logic and navigation.
- **MVC Architecture**: Organized and modular app structure.

## How It Works

1. **Patient Journey**:
   - Registers with OTP verification.
   - Chooses a doctor from the relevant category.
   - Schedules a consultation and sends payment for the doctor’s fee.
   - Receives a Google Meet link after the doctor accepts the request.
   - Consults with the doctor via video call.
   - Proceeds to order prescribed medicines from the pharmacist.

2. **Doctor Workflow**:
   - Reviews patient consultation requests.
   - Accepts requests and shares Google Meet links for consultations.

3. **Pharmacist & Rider**:
   - Pharmacists manage medicine orders.
   - Riders handle delivery and update shipment statuses.

## Getting Started

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/arbabhussain7/ehealthcare-app.git
   cd ehealthcare-app
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Set Up Firebase**:
   - Add `google-services.json` and `GoogleService-Info.plist` files.
   - Configure Firebase Authentication for OTP.

4. **Run the App**:
   ```bash
   flutter run
   ```

## Code Structure

- **lib/controllers/**: Handles app logic and state using GetX.
- **lib/models/**: Defines data models for users, appointments, and orders.
- **lib/views/**: Contains all UI components and screens.
- **lib/services/**: Integrates external services like Google Meet and Firebase.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

For questions, suggestions, or contributions, please reach out at [arbabhussain414@gmail.com](arbabhussain414@gmail.com).
