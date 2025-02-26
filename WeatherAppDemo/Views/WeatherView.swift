//
//  WeatherView.swift
//  WeatherAppDemo
//
//  Created by Tahzjeen-Amir on 2/11/25.
//

import SwiftUI

struct WeatherView: View {
    var weather: ResponseBody

  
    private func kelvinToCelsius(_ kelvin: Double) -> Double {
        return kelvin - 273.15
    }

    private func formatWindSpeed(_ speed: Double) -> String {
        return String(format: "%.1f m/s", speed)
    }

        private func getWeatherIconUrl(icon: String) -> URL? {
        let baseUrl = "https://openweathermap.org/img/wn/"
        return URL(string: "\(baseUrl)\(icon)@2x.png")
    }

    var body: some View {
        VStack {
           
            Text(weather.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 20)

        
            if let iconUrl = getWeatherIconUrl(icon: weather.weather.first?.icon ?? "") {
                AsyncImage(url: iconUrl) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                } placeholder: {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
            }

            Text(weather.weather.first?.description.capitalized ?? "No Description")
                .font(.title2)
                .foregroundColor(.white)
                .padding(.top, 5)

          
            Text("\(kelvinToCelsius(weather.main.temp), specifier: "%.1f")°C")
                .font(.system(size: 50))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 10)

            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Humidity:")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("\(weather.main.humidity)%")
                        .foregroundColor(.white)
                }

                HStack {
                    Text("Wind Speed:")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text(formatWindSpeed(weather.wind.speed))
                        .foregroundColor(.white)
                }

                HStack {
                    Text("Pressure:")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("\(weather.main.pressure) hPa")
                        .foregroundColor(.white)
                }
            }
            .padding(.top, 20)

            Spacer()
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding([.leading, .trailing], 20)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weather: ResponseBody(
            coord: ResponseBody.CoordinatesResponse(lon: 0.0, lat: 0.0),
            weather: [ResponseBody.WeatherResponse(id: 0, main: "Clear", description: "clear sky", icon: "01d")],
            main: ResponseBody.MainResponse(temp: 300.15, pressure: 1015, humidity: 60),
            name: "Sample City",
            wind: ResponseBody.WindResponse(speed: 5.0, deg: 180)
        ))
            .preferredColorScheme(.dark)
    }
}
