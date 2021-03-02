//
//  ForecastListViewModel.swift
//  Tenki App
//
//  Created by ethancr0wn on 2021/03/02.
//

import CoreLocation
import Foundation


class ForecastListViewModel: ObservableObject {
    @Published var forecasts: [ForecastViewModel] = []
    var location: String = ""
    
    func getWeatherForecast() {
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
                        DispatchQueue.main.async {
                            self.forecasts = forecast.daily.map { ForecastViewModel(forecast: $0)}
                        }
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
