//
//  WeatherWebService.swift
//  Weather App
//
//  Created by Ishita Ginoya on 14/12/24.
//

import Foundation
import Alamofire

protocol WeatherWebServiceProtocol {
    func fetchWeather(for city: String,
                          success: @escaping (WeatherResponse, Int) -> Void,
                          failure: @escaping (Error) -> Void)
}

class WeatherWebService: WebService, WeatherWebServiceProtocol {
    
    private let baseURL = "https://api.weatherapi.com/v1/current.json"
    private let apiKey = "3989680e5f3449c9b19122405241512"

    func fetchWeather(for city: String,
                      success: @escaping (WeatherResponse, Int) -> Void,
                      failure: @escaping (Error) -> Void) {
        let parameters: [String: Any] = [
            "key": apiKey,
            "q": city,
            "aqi": "no"
        ]
        
        request(url: baseURL, method: .get, parameter: parameters, headers: nil, responseType: WeatherResponse.self,
                success: { response, statusCode in
            success(response, statusCode)
        },
                failure: { error in
            failure(error)
        })
    }
}
