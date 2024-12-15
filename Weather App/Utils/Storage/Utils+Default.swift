//
//  Utils+Default.swift
//  Weather App
//
//  Created by Ishita Ginoya on 14/12/24.
//

import Foundation

class Defaults: NSObject {
    func saveCity(_ city: String?) {
        UserDefaults.standard.setValue(city ?? "Surat", forKey: "selected_city")
    }
    
    func loadCity() -> String? {
        UserDefaults.standard.string(forKey: "selected_city")
    }
}
