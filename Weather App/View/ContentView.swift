//
//  ContentView.swift
//  Weather App
//
//  Created by Ishita Ginoya on 14/12/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: WeatherViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @State private var location: String = ""
    @State private var isLoading: Bool = false
    @State private var isDetailViewVisible: Bool = true
    
    init(weatherWebService: WeatherWebServiceProtocol = WeatherWebService()) {
        _viewModel = StateObject(wrappedValue: WeatherViewModel(weatherWebService: weatherWebService as! WeatherWebService))
        }
    
    var body: some View {
        VStack {
            searchBarView
            Spacer()
            mainContentView
        }
        .padding()
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            loadInitialWeather()
        }
        .navigationTitle("Weather App")
    }
    
    // MARK: - Search Bar View
    private var searchBarView: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 45)
                
                HStack {
                    TextField("Search Location", text: $location)
                        .padding(.leading, 10)
                        .padding(.trailing, 45)
                        .frame(height: 45)
                        .textInputAutocapitalization(.words)
                        .disableAutocorrection(true)
                        .submitLabel(.search)
                        .onTapGesture {
                            viewModel.onTextfieldTap()
                            isDetailViewVisible = false
                        }
                        .onSubmit {
                            Task {
                                isLoading = true
                                await viewModel.fetchWeather(for: location)
                                isLoading = false
                            }
                        }
                    
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Main Content View
    private var mainContentView: some View {
        Group {
            if Defaults().loadCity() == nil {
                noCityView
            } else if isLoading {
                loadingView
            } else if let weather = viewModel.weather {
                weatherContentView(weather)
            } else if let errorMessage = viewModel.errorMessage {
                errorView(errorMessage)
            } else if !networkMonitor.isConnected {
                errorView("No network")
            }
        }
    }
    
    // MARK: - No City View
    private var noCityView: some View {
        VStack {
            Text("No City Selected")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.black)
                .padding(.bottom)
            Text("Please search for a city")
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.black)
                .padding(.top)
        }
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .padding()
    }
    
    // MARK: - Weather Content View
    private func weatherContentView(_ weather: WeatherResponse) -> some View {
        VStack {
            if (isDetailViewVisible) {
                weatherDetailView(weather)
                    .frame(maxHeight: .infinity, alignment: .center)
            } else {
                weatherCardView(weather)
                    .padding(.top, 16)
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }
    
    // MARK: - Weather Card View
    private func weatherCardView(_ weather: WeatherResponse) -> some View {
        Button(action: {
            isDetailViewVisible = true
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(weather.location.name)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                    Text("\(weather.current.temp_c, specifier: "%.0f")")
                        .font(.system(size: 60, weight: .semibold))
                        .foregroundColor(.black)
                }
                .padding(.leading, 16)
                .padding(.trailing, 16)
                .padding(.top, 4)
                
                Spacer()
                
                if let iconURL = URL(string: "https:\(weather.current.condition.icon)") {
                    AsyncImage(url: iconURL) { image in
                        image.resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .padding(.trailing, 16)
                    } placeholder: {
                        Image(systemName: "sun.max.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    }
                }
            }
            .frame(height: 117)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(15)
            .padding(.horizontal)
        }
        .padding(.bottom, 20)
    }
    
    // MARK: - Weather Detail View
    private func weatherDetailView(_ weather: WeatherResponse) -> some View {
        VStack {
            
            let iconURL = weather.current.condition.icon
            if let url = URL(string: "https:\(iconURL)") {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100, alignment: .center)
                } placeholder: {
                    Image(systemName: "sun.max.fill")                         .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
            } else {
                Image(systemName: "sun.max.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
            }
            
            HStack {
                Text(weather.location.name)
                    .font(.system(size: 30, weight: .bold))
                .padding(.top)
                Image("arrow")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            
            HStack(alignment: .top) {
                Text("\(weather.current.temp_c, specifier: "%.0f")")
                    .font(.system(size: 70, weight: .semibold))
                Text("°")
                    .font(.system(size: 30, weight: .regular))
            }
            
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 274, height: 75)
                .cornerRadius(16)
                .overlay {
                    HStack {
                        weatherDetailRow(label: "Humidity", value: "\(weather.current.humidity)%")
                        Spacer()
                        weatherDetailRow(label: "UV", value: "\(Int(weather.current.uv))")
                        Spacer()
                        weatherDetailRow(label: "Feels Like", value: "\(weather.current.feelslike_c)")
                    }
                    .padding(.leading, 24)
                    .padding(.trailing, 24)
                }
        }
        .padding()
    }
    
    // MARK: - Weather Detail Row View
    private func weatherDetailRow(label: String, value: String) -> some View {
        VStack {
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.gray)
            Text(value)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.gray)
                .padding(.top, 1)
        }
    }
    
    // MARK: - Error View
    private func errorView(_ message: String) -> some View {
        Text(message)
            .font(.title2)
            .foregroundColor(.red)
            .padding()
    }
    
    // MARK: - Load Initial Weather from Defaults
    private func loadInitialWeather() {
        if let savedCity = Defaults().loadCity(), !savedCity.isEmpty {
            Task {
                isLoading = true
                await viewModel.fetchWeather(for: savedCity)
                isLoading = false
            }
        }
    }
}

#Preview {
    ContentView()
}
