//
//  MainViewController.swift
//  EuroTorgTestTask
//
//  Created by Ivan Apet on 7/30/20.
//  Copyright © 2020 Ivan Apet. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    private var layoutManager: MainLayoutManager!
    
    private let networkManager = NetworkManager()
    
    var dataService = MainDataService()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerBotContraint: NSLayoutConstraint!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        getAllCountries()
    }
    
    @IBAction func closePickerAction(_ sender: Any) {
        pickerBotContraint.constant = -UIScreen.main.bounds.height
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func donePickerAction(_ sender: Any) {
        layoutManager.pickerDoneAction()
        pickerBotContraint.constant = -UIScreen.main.bounds.height
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        getNewData(type: dataService.getPickerType())
    }
}

extension MainViewController {
    func configure() {
        pickerBotContraint.constant = -UIScreen.main.bounds.height
        layoutManager = MainLayoutManager(vc: self, tableView: tableView, pickerView: pickerView, dataService: dataService)
    }
    
    func selectCoutry(countries: [BaseModel]) {
        let model = countries.count == 1 ? countries.first : nil
        layoutManager.setModelToCell(type: .country, model: model)
        getAllRegions(countryId: model?.id ?? 0)
    }
    
    func selectDistrict(districts: [BaseModel]) {
        let model = districts.count == 1 ? districts.first : nil
        layoutManager.setModelToCell(type: .districts, model: model)
        if model != nil {
            getNewData(type: .districts)
        }
    }
    
    func selectCities(cities: [BaseModel]) {
        let model = cities.count == 1 ? cities.first : nil
        layoutManager.setModelToCell(type: .cities, model: model)
    }
    
    func selectStreets(models: [BaseModel]) {
        let model = models.count == 1 ? models.first : nil
        layoutManager.setModelToCell(type: .street, model: model)
    }
    
    func getNewData(type: DataType) {
        switch type {
        case .country:
//            getAllCountries()
            let selected = dataService.getSelectedData(type: .country)
            getAllRegions(countryId: selected?.id ?? 0)
        case .region:
            let selectedRegion = dataService.getSelectedData(type: .region)
            getDistrictsFor(regionId: selectedRegion?.id ?? 0)
        case .districts:
            let selectedDistrict = dataService.getSelectedData(type: .districts)
            getCities(districtId: selectedDistrict?.id ?? 0)
        case .cities:
            let selectedCity = dataService.getSelectedData(type: .cities)
            getStreets(cityId: selectedCity?.id ?? 0)
        case .street: break
        }
    }
}

extension MainViewController: DidTapMainViewDelegate {
    func openDatePicker(state: DataType) {
        layoutManager.setPickerData(type: state)
        dataService.setPickerType(type: state)
        pickerBotContraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

private extension MainViewController {
    func getAllCountries() {
        networkManager.getAllCountries { [weak self] (countries, err) in
            guard let self = self else {return}
            if let models = countries {
                self.dataService.setData(type: .country, models: models)
                self.selectCoutry(countries: models)
            }
        }
    }
    
    func getAllRegions(countryId: Int) {
        networkManager.getRegions(countryId: countryId) { [weak self] (regions, error) in
            guard let self = self else {return}
            if let models = regions {
                self.dataService.setData(type: .region, models: models)
            }
        }
    }
    
    func getDistrictsFor(regionId: Int) {
        networkManager.getDistricts(regionId: regionId) { [weak self] (districts, error) in
            guard let self = self else {return}
            if let models = districts {
                self.dataService.setData(type: .districts, models: models)
                self.selectDistrict(districts: models)
            }
        }
    }
    
    func getCities(districtId: Int) {
        networkManager.getCities(districtId: districtId) { [weak self] (cities, error) in
            guard let self = self else {return}
            if let models = cities {
                self.dataService.setData(type: .cities, models: models)
                self.selectCities(cities: models)
            }
        }
    }
    
    func getStreets(cityId: Int) {
        networkManager.getStreets(cityId: cityId) { [weak self] (streets, error) in
            guard let self = self else {return}
            if let models = streets {
                self.dataService.setData(type: .street, models: models)
                self.selectStreets(models: models)
            }
        }
    }

}
