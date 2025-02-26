//
//  ContentView.swift
//  WeatherAppDemo
//
//  Created by Tahzjeen-Amir on 2/10/25.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var weather: ResponseBody?
    @State var errorMessage: String?
    
    var body: some View {
        VStack {
            if let location = locationManager.location {
                if let weatherData = weather {
                    WeatherView(weather: weatherData)
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                } else {
                    Text("Fetching weather data...")
                        .onAppear {
                            fetchWeather(for: location)
                        }
                }

                Text("Your coordinates are: \(location.longitude), \(location.latitude)")
            } else if locationManager.isLoading {
                LoadingView()
            } else {
                WelcomeView()
                    .environmentObject(locationManager)
            }
        }
        .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
        .preferredColorScheme(.dark)
    }

    private func fetchWeather(for location: CLLocationCoordinate2D) {
        Task {
            do {
                weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
            } catch {
                errorMessage = "Error getting weather: \(error.localizedDescription)"
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
