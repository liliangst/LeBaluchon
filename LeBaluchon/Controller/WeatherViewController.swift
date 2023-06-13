//
//  WeatherViewController.swift
//  LeBaluchon
//
//  Created by Lilian Grasset on 30/05/2023.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet var swipeGestureRecognizer: UISwipeGestureRecognizer!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Local Weather View
    @IBOutlet weak var localCityLabel: UILabel!
    @IBOutlet weak var localTemperatureLabel: UILabel!
    @IBOutlet weak var localWeatherImage: UIImageView!
    
    // New York Weather View
    @IBOutlet weak var nyCityLabel: UILabel!
    @IBOutlet weak var nyTemperatureLabel: UILabel!
    @IBOutlet weak var nyWeatherImage: UIImageView!
    
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        swipeGestureRecognizer.addTarget(self, action: #selector(callWeatherService))
        callWeatherService()
    }
    
    private func toggleActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        activityIndicator.isHidden = !show
    }
}

extension WeatherViewController {
    @objc func callWeatherService() {
        toggleActivityIndicator(show: true)
        WeatherService.shared.fetchBothWeatherData(at: .newYork, and: .local) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weatherDataList):
                    self.refreshNYWeather(weatherData: weatherDataList[0])
                    self.refreshLocalWeather(weatherData: weatherDataList[1])
                case .failure(let error):
                    self.displayError(error)
                }
                self.toggleActivityIndicator(show: false)
            }
        }
    }
}

extension WeatherViewController {
    func refreshLocalWeather(weatherData: WeatherData) {
        localCityLabel.text = weatherData.name
        localWeatherImage.image = UIImage(systemName: weatherData.icon)
        localTemperatureLabel.text = "\(weatherData.temperature) °C"
    }
    
    func refreshNYWeather(weatherData: WeatherData) {
        nyCityLabel.text = weatherData.name
        nyWeatherImage.image = UIImage(systemName: weatherData.icon)
        nyTemperatureLabel.text = "\(weatherData.temperature) °C"
    }
}

extension WeatherViewController {
    func displayError(_ error: WeatherServiceError) {
        switch error {
        case .noData:
            displayAlert("Il y a eu une erreur lors de la réception des données.")
        case .wrongStatusCode:
            displayAlert("Il y a eu une erreur côté serveur.")
        case .decodingError:
            displayAlert("Il y a eu une erreur lors du décodage des données.")
        }
    }

    private func displayAlert(_ text: String) {
        let alertVC = UIAlertController(title: "Oups!",
                                        message: text, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        alertVC.addAction(UIAlertAction(title: "Réessayer", style: .default, handler: { _ in
            self.callWeatherService()
        }))
        return self.present(alertVC, animated: true, completion: nil)
    }
}
