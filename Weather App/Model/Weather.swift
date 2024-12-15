//
//  Weather.swift
//  Weather App
//
//  Created by Ishita Ginoya on 14/12/24.
//

import Foundation

import Foundation

// Top-level structure that contains location and current weather data
struct WeatherResponse: Decodable {
    let location: Location
    let current: CurrentWeather
}

// Location information structure
struct Location: Decodable {
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let tz_id: String
    let localtime: String
}

// Current weather information structure
struct CurrentWeather: Decodable {
    let last_updated: String
    let temp_c: Double
    let temp_f: Double
    let feelslike_c: Double
    let feelslike_f: Double
    let condition: WeatherCondition
    let wind_mph: Double
    let wind_kph: Double
    let wind_degree: Int
    let wind_dir: String
    let pressure_mb: Double
    let pressure_in: Double
    let precip_mm: Double
    let precip_in: Double
    let humidity: Int
    let cloud: Int
    let is_day: Int
    let uv: Double
    let gust_mph: Double
    let gust_kph: Double
}

// Weather condition structure
struct WeatherCondition: Decodable {
    let text: String
    let icon: String
    let code: Int
}
