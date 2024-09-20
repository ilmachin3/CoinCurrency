//
//  NetworkManager.swift
//  Converter
//
//  Created by Илья Дышлюк on 14.09.2024.
//
import Foundation
import UIKit

class NetworkManager {
    private let apiKey = "42ec6bd65fd648bab53fe2391934c9f2" // Замените на ваш API ключ
    private let baseURL = "https://openexchangerates.org/api"

    func fetchLatestRates(completion: @escaping ([String: Double]) -> Void) {
        let urlString = "\(baseURL)/latest.json?app_id=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching rates: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received.")
                return
            }

            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(ExchangeRateResponse.self, from: data)
                completion(response.rates)
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        task.resume()
    }
}

struct ExchangeRateResponse: Codable {
    let rates: [String: Double]
}
