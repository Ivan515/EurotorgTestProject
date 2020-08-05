//
//  MainVCNetworkManager.swift
//  EuroTorgTestTask
//
//  Created by Ivan Apet on 8/5/20.
//  Copyright © 2020 Ivan Apet. All rights reserved.
//

import UIKit
import IHProgressHUD

class MainVCNetworkManager: NSObject {
    
    private let viewController: MainViewController!
    private let networkManager = NetworkManager()
    
    init(vc: MainViewController) {
        self.viewController = vc
        super.init()
    }
}

extension MainVCNetworkManager {
    func getAllCountries() {
        IHProgressHUD.show(withStatus: "Запрашиваю список стран")
        networkManager.getAllCountries { [weak self] (countries, error) in
            guard let self = self else {return}
            IHProgressHUD.dismiss()
            if let models = countries {
                self.viewController.dataService.setData(type: .country, models: models)
                self.viewController.selectCoutry(countries: models)
            }
            if let error = error {
                print(error)
            }
        }
    }
    
    func getAllRegions(countryId: Int) {
        IHProgressHUD.show(withStatus: "Запрашиваю список регионов")
        networkManager.getRegions(countryId: countryId) { [weak self] (regions, error) in
            guard let self = self else {return}
            IHProgressHUD.dismiss()
            if let models = regions {
                self.viewController.dataService.setData(type: .region, models: models)
            }
            if let error = error {
                print(error)
            }
        }
    }
    
    func getDistrictsFor(regionId: Int) {
        IHProgressHUD.show(withStatus: "Запрашиваю список областей")
        networkManager.getDistricts(regionId: regionId) { [weak self] (districts, error) in
            guard let self = self else {return}
            if let models = districts {
                self.viewController.dataService.setData(type: .districts, models: models)
                self.viewController.selectDistrict(districts: models)
            }
            if let error = error {
                print(error)
                IHProgressHUD.dismiss()
            }
        }
    }
    
    func getCities(districtId: Int) {
        IHProgressHUD.show(withStatus: "Запрашиваю список городов")
        networkManager.getCities(districtId: districtId) { [weak self] (cities, error) in
            guard let self = self else {return}
            if let models = cities {
                self.viewController.dataService.setData(type: .cities, models: models)
                self.viewController.selectCities(cities: models)
            }
            if let error = error {
                print(error)
                IHProgressHUD.dismiss()
            }
        }
    }
    
    func getStreets(cityId: Int) {
        IHProgressHUD.show(withStatus: "Запрашиваю список улиц")
        networkManager.getStreets(cityId: cityId) { [weak self] (streets, error) in
            guard let self = self else {return}
            if let models = streets {
                self.viewController.dataService.setData(type: .street, models: models)
                self.viewController.selectStreets(models: models)
            }
            if let error = error {
                print(error)
                IHProgressHUD.dismiss()
            }
        }
    }
    
    func getHouses(streetId: Int) {
        IHProgressHUD.show(withStatus: "Запрашиваю список домов")
        networkManager.getHouses(houseId: streetId) { [weak self] (houses, error) in
            guard let self = self else {return}
            if let models = houses {
                self.viewController.dataService.setData(type: .house, models: models)
                IHProgressHUD.dismiss()
            }
            if let error = error {
                print(error)
                IHProgressHUD.dismiss()
            }
        }
    }
}
