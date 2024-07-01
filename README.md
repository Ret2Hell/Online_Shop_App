# Online Shop App

This is a Flutter project for an online shop app. The app allows users to browse products, add them to their cart, and manage their cart items. It uses Supabase for user authentication and product management, and the Provider package for state management.

## Features

- **User Authentication**: Users can sign up, log in, and manage their accounts using Supabase.
- **Product Management**: Products are uploaded and managed through Supabase.
- **Cart Management**: Each user can add items to their cart and manage their cart items.
- **State Management**: The Provider package is used for state management between the product info screen and the cart list, ensuring that items in the cart are only fetched once when the user starts the app.
- **Responsive UI**: The app is designed to work on various screen sizes and orientations.
- **Animated Widgets**: The app includes animations such as a refresh feature and a curved navigation bar.

## Screens

- **Home Screen**: Displays a list of products available in the shop.
- **Product Info Screen**: Displays detailed information about a product and allows users to add it to their cart.
- **Cart List**: Displays the items in the user's cart and allows for managing them.
- **User Account Screen**: This feature is still under development.
- **Payment Mechanism**: This feature is still under development.

## Getting Started

### Prerequisites

- Flutter SDK
- Supabase account
- Android Studio setup (Follow the [installation guide](https://docs.flutter.dev/get-started/install/windows/mobile))
- Set up a Supabase project and obtain your API keys

### Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/your-repo.git
    ```
2. Navigate to the project directory:
    ```bash
    cd your-repo
    ```
3. Install dependencies:
    ```bash
    flutter pub get
    ```
4. Set up your Supabase credentials in the `environment_keys.dart` file:
    ```
    online_shop/lib/src/config/environment_keys.dart
    ```

### Running the App

To run the app on your local machine, use the following command:
```bash
flutter run
