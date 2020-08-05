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
    case house
    case housings
    case entry
    case floor
    case flats
    
    func makeTitle() -> String {
        switch self {
        case .country: return "Страна"
        case .region: return "Область (обл. центр)"
        case .districts: return "Район (район. центр)"
        case .cities: return "Населенный пункт"
        case .street: return "Улица"
        case .house: return "Дом"
        case .housings: return "Корпус"
        case .entry: return "Подъезд"
        case .floor: return "Этаж"
        case .flats: return "Квартира"
        }
    }
    
    func makeIndex() -> Int {
        switch self {
        case .country: return 0
        case .region: return 1
        case .districts: return 2
        case .cities: return 3
        case .street: return 4
        case .house: return 5
        case .housings: return 6
        case .entry: return 7
        case .floor: return 8
        case .flats: return 9
        }
    }
}

class MainDataService: NSObject {
    var selectedCountry: BaseModel?
    var selectedRegion: BaseModel?
    var selectedDistrict: BaseModel?
    var selectedCity: BaseModel?
    var selectedStreet: BaseModel?
    var selectedHouse: BaseModel?
    var selectedHousing: BaseModel?
    var selectedEntry: BaseModel?
    var selectedFloor: BaseModel?
    var selectedFlat: BaseModel?
    
    var allCountries = [BaseModel]()
    var allRegions = [BaseModel]()
    var allDistricts = [BaseModel]()
    var allCities = [BaseModel]()
    var allStreets = [BaseModel]()
    var allHouses = [BaseModel]()
    
    private var selectedPickerType: DataType!
}

// MARK: -
// MARK: - set functions

extension MainDataService {
    func setData(type: DataType, models: [BaseModel]) {
        switch type {
        case .country:
            allCountries = models
            selectedCountry = allCountries.count == 1 ? allCountries.first : nil
        case .region:
            allRegions = models
            selectedRegion = allRegions.count == 1 ? allRegions.first : nil
        case .districts:
            allDistricts = models
            selectedDistrict = allDistricts.count == 1 ? allDistricts.first : nil
        case .cities:
            allCities = models
            selectedCity = allCities.count == 1 ? allCities.first : nil
        case .street:
            allStreets = models
            selectedStreet = allStreets.count == 1 ? allStreets.first : nil
        case .house:
            allHouses = models
            selectedHouse = allHouses.count == 1 ? allHouses.first : nil
        default: break
        }
    }
    
    func setSelectedData(type: DataType, model: BaseModel?) {
        switch type {
        case .country: selectedCountry = model
        case .region: selectedRegion = model
        case .districts: selectedDistrict = model
        case .cities: selectedCity = model
        case .street: selectedStreet = model
        case .house: selectedHouse = model
        case .housings: selectedHousing = model
        case .entry: selectedEntry = model
        case .floor: selectedFloor = model
        case .flats: selectedFlat = model
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
        case .house: return allHouses
        default: return [BaseModel]() // fix it
        }
    }
    
    func getSelectedData(type: DataType) -> BaseModel?  {
        switch type {
        case .country: return selectedCountry
        case .region: return selectedRegion
        case .districts: return selectedDistrict
        case .cities: return selectedCity
        case .street: return selectedStreet
        case .house: return selectedHouse
        case .housings: return selectedHousing
        case .entry: return selectedEntry
        case .floor: return selectedFloor
        case .flats: return selectedFlat
        }
    }
    
    func getPickerType() -> DataType {
        return selectedPickerType
    }
}

extension MainDataService {
    func selectNewDataFor(type: DataType) {
        switch type{
        case .region:
            setData(type: .cities, models: [BaseModel]())
            setData(type: .street, models: [BaseModel]())
            setData(type: .house, models: [BaseModel]())
            setData(type: .housings, models: [BaseModel]())
            setData(type: .entry, models: [BaseModel]())
            setData(type: .floor, models: [BaseModel]())
            setData(type: .flats, models: [BaseModel]())
            
            setSelectedData(type: .districts, model: nil)
            setSelectedData(type: .cities, model: nil)
            setSelectedData(type: .street, model: nil)
            setSelectedData(type: .house, model: nil)
            setSelectedData(type: .housings, model: nil)
            setSelectedData(type: .entry, model: nil)
            setSelectedData(type: .floor, model: nil)
            setSelectedData(type: .flats, model: nil)
        case .districts:
            setData(type: .cities, models: [BaseModel]())
            setData(type: .street, models: [BaseModel]())
            setData(type: .house, models: [BaseModel]())
            setData(type: .housings, models: [BaseModel]())
            setData(type: .entry, models: [BaseModel]())
            setData(type: .floor, models: [BaseModel]())
            setData(type: .flats, models: [BaseModel]())
            
            setSelectedData(type: .districts, model: nil)
            setSelectedData(type: .cities, model: nil)
            setSelectedData(type: .street, model: nil)
            setSelectedData(type: .house, model: nil)
            setSelectedData(type: .housings, model: nil)
            setSelectedData(type: .entry, model: nil)
            setSelectedData(type: .floor, model: nil)
            setSelectedData(type: .flats, model: nil)
        case .cities:
            setData(type: .street, models: [BaseModel]())
            setData(type: .house, models: [BaseModel]())
            setData(type: .housings, models: [BaseModel]())
            setData(type: .entry, models: [BaseModel]())
            setData(type: .floor, models: [BaseModel]())
            setData(type: .flats, models: [BaseModel]())
            
            setSelectedData(type: .cities, model: nil)
            setSelectedData(type: .street, model: nil)
            setSelectedData(type: .house, model: nil)
            setSelectedData(type: .housings, model: nil)
            setSelectedData(type: .entry, model: nil)
            setSelectedData(type: .floor, model: nil)
            setSelectedData(type: .flats, model: nil)
        default: break
        }
    }
    
    func checkAllRequiedFields() -> Bool {
        if selectedCountry != nil, selectedRegion != nil,
          selectedDistrict != nil, selectedCity != nil,
            selectedStreet != nil, selectedHouse != nil {
            return true
        }
        return false
    }
}
