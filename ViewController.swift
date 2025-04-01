//
//  ViewController.swift
//  WeatherApp
//
//  Created by Aita Macbook on 4/1/25.
//

import UIKit

class ViewController: UIViewController {
    private let cityTextField: UITextField = {
            let textField = UITextField()
            textField.placeholder = "Введите город"
            textField.borderStyle = .roundedRect
            textField.textAlignment = .center
        textField.layer.cornerRadius = 10
                textField.layer.masksToBounds = true
                textField.font = UIFont.systemFont(ofSize: 18, weight: .medium)
                textField.backgroundColor = UIColor.white.withAlphaComponent(0.8)
                textField.layer.shadowColor = UIColor.black.cgColor
                textField.layer.shadowOffset = CGSize(width: 0, height: 2)
                textField.layer.shadowOpacity = 0.3
                textField.layer.shadowRadius = 4
            return textField
        }()
        
        private lazy var getWeatherButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Показать текущую погоду", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
                    button.layer.cornerRadius = 10
                    button.backgroundColor = UIColor.blue
                    button.setTitleColor(.white, for: .normal)
                    button.layer.shadowColor = UIColor.black.cgColor
                    button.layer.shadowOffset = CGSize(width: 0, height: 2)
                    button.layer.shadowOpacity = 0.3
                    button.layer.shadowRadius = 4
            button.addTarget(self, action: #selector(fetchWeather), for: .touchUpInside)
            return button
        }()
        
        private let weatherLabel: UILabel = {
            let label = UILabel()
            label.text = "Здесь будет температура"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            label.numberOfLines = 0
            label.textColor = .white
                    label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                    label.layer.cornerRadius = 10
                    label.layer.masksToBounds = true
                   
            return label
        }()
    
        

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
           }
           
           private func setupUI() {
               view.backgroundColor = .white
                       view.addSubview(cityTextField)
                       view.addSubview(getWeatherButton)
                       view.addSubview(weatherLabel)
               
               let stackView = UIStackView(arrangedSubviews: [cityTextField, getWeatherButton, weatherLabel])
               stackView.axis = .vertical
               stackView.spacing = 15
               stackView.translatesAutoresizingMaskIntoConstraints = false
               view.addSubview(stackView)
               
               NSLayoutConstraint.activate([
                   stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                   stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                   stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                   stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
               ])
           }
           
           @objc private func fetchWeather() {
               guard let city = cityTextField.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                     !city.isEmpty else {
                   weatherLabel.text = "Введите название города"
                   return
               }
               
               let apiKey = "ab39a85f86fdec8d10302e383aec3130"  
               let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
               
               guard let url = URL(string: urlString) else { return }
               
               let task = URLSession.shared.dataTask(with: url) { data, response, error in
                   if let error = error {
                       DispatchQueue.main.async {
                           self.weatherLabel.text = "Ошибка: \(error.localizedDescription)"
                       }
                       return
                   }
                   
                   guard let data = data else { return }
                   
                   do {
                       let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                       DispatchQueue.main.async {
                           self.weatherLabel.text = "Температура в \(weatherResponse.name) сейчас: \(weatherResponse.main.temp)°C"
                       }
                   } catch {
                       DispatchQueue.main.async {
                           self.weatherLabel.text = "Ошибка загрузки данных"
                       }
                   }
               }
               
               task.resume()
           }
       }

       struct WeatherResponse: Codable {
           let name: String
           let main: Main
       }

       struct Main: Codable {
           let temp: Double
       }
        // Do any additional setup after loading the view.
    




