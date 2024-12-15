//
//  WeatherViewModel.swift
//  Weather App
//
//  Created by Ishita Ginoya on 14/12/24.
//

import Foundation

class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherResponse?
    @Published var errorMessage: String?
    private var weatherWebService: WeatherWebServiceProtocol
    
    init(weatherWebService: WeatherWebServiceProtocol) {
        self.weatherWebService = weatherWebService
    }
    
    func fetchWeather(for location: String) async {
        do {
            try await withCheckedThrowingContinuation { continuation in
                weatherWebService.fetchWeather(for: location) { response, statusCode in
                    if statusCode == 404 {
                        self.errorMessage = "City not found. Please check your search."
                    } else {
                        self.weather = response
                        Defaults().saveCity(location)
                        continuation.resume()
                    }
                } failure: { error in
                    self.errorMessage = "Failed to fetch weather: \(error.localizedDescription)"
                    continuation.resume(throwing: error)
                }
            }
        } catch {
            self.errorMessage = "Unable to load data. Please try again."
        }
    }
    
    func onTextfieldTap() {
        self.weather = nil
    }
}
