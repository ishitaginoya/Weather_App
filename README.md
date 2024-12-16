# Weather Tracker App

A weather tracking application built using **Swift** and **SwiftUI**. This app demonstrates clean architecture, MVVM design pattern, and seamless API integration.

## Features

### 1. Home Screen
- Displays weather information for a saved city:
  - **City Name**
  - **Temperature**
  - **Weather Condition** (with icon)
  - **Humidity** (% value)
  - **UV Index**
  - **Feels Like Temperature**
- Prompts the user to search for a city if none is saved.
- Allows updating the displayed city via a search bar.

### 2. Search Functionality
- Users can search for cities by name.
- Displays a search result card for the queried city.
- Tapping on a result updates the home screen and saves the city.

### 3. Data Persistence
- Utilizes **UserDefaults** to persist the selected city across app launches.
- Automatically reloads the saved city's weather data on launch.


## Technologies Used

- **Programming Language:** Swift
- **Framework:** SwiftUI
- **Architecture:** MVVM
- **Local Storage:** UserDefaults
- **API Integration:** WeatherAPI
- **Dependency Injection:** Protocol-oriented programming


## License

This project is licensed under the MIT License. See the LICENSE file for details.
