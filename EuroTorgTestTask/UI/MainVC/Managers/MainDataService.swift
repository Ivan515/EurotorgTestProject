//
//  MainDataService.swift
//  EuroTorgTestTask
//
//  Created by Ivan Apet on 7/30/20.
//  Copyright © 2020 Ivan Apet. All rights reserved.
//

import UIKit

enum DataType {
    case country
    case region
    case districts
    case cities
    case street
    
    func makeTitle() -> String {
        switch self {
        case .country: return "Страна"
        case .region: return "Область (обл. центр)"
        case .districts: return "Район (район. центр)"
        case .cities: return "Населенный пункт"
        case .street: return "Улица"
        }
    }
}

class MainDataService: NSObject {
    var selectedCountry: BaseModel?
    var selectedRegion: BaseModel?
    var selectedDistrict: BaseModel?
    var selectedCity: BaseModel?
    var selectedStreet: BaseModel?
    
    var allCountries = [BaseModel]()
    var allRegions = [BaseModel]()
    var allDistricts = [BaseModel]()
    var allCities = [BaseModel]()
    var allStreets = [BaseModel]()
    
    private var selectedPickerType: DataType!
}

// MARK: -
// MARK: - set functions

extension MainDataService {
    func setData(type: DataType, models: [BaseModel]) {
        switch type {
        case .country:
            allCountries = models
            if allCountries.count == 1 {
                selectedCountry = allCountries.first
            }
        case .region:
            allRegions = models
            if allRegions.count == 1 {
                selectedRegion = allRegions.first
            }
        case .districts:
            allDistricts = models
            if allDistricts.count == 1 {
                selectedDistrict = allDistricts.first
            }
        case .cities:
            allCities = models
            if allCities.count == 1 {
                selectedCity = allCities.first
            }
        case .street:
            allStreets = models
            if allStreets.count == 1 {
                selectedStreet = allStreets.first
            }
        }
    }
    
    func setSelectedData(type: DataType, model: BaseModel) {
        switch type {
        case .country: selectedCountry = model
        case .region: selectedRegion = model
        case .districts: selectedDistrict = model
        case .cities: selectedCity = model
        case .street: selectedStreet = model
        }
    }
    
    func setPickerType(type: DataType) {
        selectedPickerType = type
    }
}

// MARK: -
// MARK: - get functions

extension MainDataService {
    func getArray(type: DataType) -> [BaseModel] {
        switch type {
        case .country: return allCountries
        case .region: return allRegions
        case .districts: return allDistricts
        case .cities: return allCities
        case .street: return allStreets
        }
    }
    
    func getSelectedData(type: DataType) -> BaseModel?  {
        switch type {
        case .country: return selectedCountry
        case .region: return selectedRegion
        case .districts: return selectedDistrict
        case .cities: return selectedCity
        case .street: return selectedStreet
        }
    }
    
    func getPickerType() -> DataType {
        return selectedPickerType
    }
}
