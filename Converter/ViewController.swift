//
//  ViewController.swift
//  Converter
//
//  Created by Илья Дышлюк on 13.09.2024.
//
import Foundation
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var currencySegmentedControl: UISegmentedControl!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var convertButton: UIButton!
    
    let networkManager = NetworkManager()
    var currencyRates: [String: Double] = [:]
    
    
    //    let currencyRates = [
    //        "USD": 1.0, // Базовая валюта
    //        "EUR": 0.9, // Примерный курс EUR к USD
    //        "RUB": 75.0 // Примерный курс RUB к USD
    //    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.clipsToBounds = true
        resultLabel.layer.cornerRadius = 5
        //convertButton.setImage(UIImage(named: "Loop"), for: .normal)
        //convertButton.translatesAutoresizingMaskIntoConstraints = false
        // Настройка начальных значений (например, валюты по умолчанию)
    }
    
    @IBAction func convertCurrency(_ sender: Any) {
        guard let amountString = amountTextField.text,
              let amount = Double(amountString) else {
            return
        }
        
        let selectedCurrency = currencySegmentedControl.titleForSegment(at: currencySegmentedControl.selectedSegmentIndex) ?? "USD"
        
        // Получаем курс валюты из API
        networkManager.fetchLatestRates { rates in
            self.currencyRates = rates
            guard let rate = self.currencyRates[selectedCurrency] else {
                // Обработка ошибки, если валюта не найдена
                return
            }
            let result = amount * rate
            
            DispatchQueue.main.async { // Обновляем метку на главном потоке
                self.resultLabel.text = String(format: "%.2f %@", result, selectedCurrency)
            }
        }
    }
}
