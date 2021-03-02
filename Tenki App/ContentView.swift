//
//  ContentView.swift
//  Tenki App
//
//  Created by ethancr0wn on 2021/03/02.
//

import CoreLocation
import SwiftUI

struct ContentView: View {
    @State private var location: String = ""
    @State var forecast: Forecast? = nil
    let dateFormatter = DateFormatter()
    init() {
        dateFormatter.dateFormat = "E, MMM. d"
    }
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Enter location", text: $location)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button {
                        getWeatherForecast(for: location )
                    } label: {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .font(.title3)
                    }
                }
                if let forecast = forecast {
                    List(forecast.daily, id: \.dt) { day in
                        VStack(alignment: .leading) {
                            Text(dateFormatter.string(from: day.dt))
                                .fontWeight(.bold)
                            HStack(alignment: .top) {
                                Image(systemName:"hourglass")
                                    .font(.title)
                                    .frame(width: 50, height: 50)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray))
                                VStack(alignment: .leading) {
                                    Text(day.weather[0].description)
                                    Text("High: \(day.temp.max)")
                                    Text("Low: \(day.temp.min)")
                                    Text("Clouds: \(day.clouds)")
                                    Text("POP: \(day.pop)")
                                    Text("Humidity: \(day.humidity)")
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }else {
                    Spacer()
                }
            }
            .padding(.horizontal)
            .navigationTitle("Tenki App")
        }
    }
    func getWeatherForecast(for location: String) {
        let apiService = APIService.shared
        CLGeocoder().geocodeAddressString(location) { (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let lat = placemarks?.first?.location?.coordinate.latitude,
               let lon = placemarks?.first?.location?.coordinate.longitude {
                apiService.getJSON(urlString: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=current,minutely,hourly,alerts&appid=c4e51dbcfd5cb2f515914f75c033d76b",
                                   dateDecodingStrategy: .secondsSince1970) {
                    (result: Result<Forecast, APIService.APIError>)
                    in
                    switch result {
                    case .success(let forecast):
                        self.forecast = forecast
                    //                        for day in forecast.daily {
                    //                            print(day.dt)
                    //                        }
                    case .failure(let apiError):
                        switch apiError {
                        case .error(let errorString):
                            print(errorString)
                        }
                    }
                }
                
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


