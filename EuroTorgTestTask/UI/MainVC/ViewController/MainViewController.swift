//
//  MainViewController.swift
//  EuroTorgTestTask
//
//  Created by Ivan Apet on 7/30/20.
//  Copyright © 2020 Ivan Apet. All rights reserved.
//

import UIKit
import IHProgressHUD

class MainViewController: UIViewController {
    
    private var layoutManager: MainLayoutManager!
    
    private var networkManager: MainVCNetworkManager!//NetworkManager()
    
    var dataService = MainDataService()
    
    private var isHudShow = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerBotContraint: NSLayoutConstraint!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        getAllCountries()
        IHProgressHUD.set(defaultStyle: .dark)
    }
    
    @IBAction func closePickerAction(_ sender: Any) {
        guard let type = dataService.getPickerType() else {return}
        layoutManager.setModelToCell(type: type, model: dataService.getSelectedData(type: type))
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
        guard let type = dataService.getPickerType() else {return}
        getNewData(type: type)
    }
}

extension MainViewController {
    func configure() {
        let image = UIImage(named: "euroopt")
        navigationItem.titleView = UIImageView(image: image)
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        pickerBotContraint.constant = -UIScreen.main.bounds.height
        layoutManager = MainLayoutManager(vc: self, tableView: tableView, pickerView: pickerView, dataService: dataService)
        networkManager = MainVCNetworkManager(vc: self)
        tapToCloseKeyboard()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hudShowing), name: NotificationName.IHProgressHUDWillAppear.getNotificationName(), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hudHide), name: NotificationName.IHProgressHUDDidDisappear.getNotificationName(), object: nil)
    }
    
    func tapToCloseKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func closeKeyboard() {
        view.endEditing(true)
        closePicker()
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 64, right: 0)
            closePicker()
        }
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        tableView.contentInset = UIEdgeInsets.zero
    }
    
    @objc func hudShowing() {
        isHudShow = true
        view.isUserInteractionEnabled = false
    }
    
    @objc func hudHide() {
        isHudShow = false
        view.isUserInteractionEnabled = true
    }
}

extension MainViewController {
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
        } else {
            IHProgressHUD.dismiss()
            dataService.selectNewDataFor(type: .districts)
            
            layoutManager.setModelToCell(type: .districts, model: nil)
            layoutManager.setModelToCell(type: .cities, model: nil)
            layoutManager.setModelToCell(type: .street, model: nil)
            layoutManager.setModelToCell(type: .house, model: nil)
            layoutManager.setModelToCell(type: .housings, model: nil)
            layoutManager.setModelToCell(type: .entry, model: nil)
            layoutManager.setModelToCell(type: .floor, model: nil)
            layoutManager.setModelToCell(type: .flats, model: nil)
        }
    }
    
    func selectCities(cities: [BaseModel]) {
        let model = cities.count == 1 ? cities.first : nil
        layoutManager.setModelToCell(type: .cities, model: model)
        if model != nil {
            getNewData(type: .cities)
        } else {
            IHProgressHUD.dismiss()
            dataService.selectNewDataFor(type: .cities)
            
            layoutManager.setModelToCell(type: .cities, model: nil)
            layoutManager.setModelToCell(type: .street, model: nil)
            layoutManager.setModelToCell(type: .house, model: nil)
            layoutManager.setModelToCell(type: .housings, model: nil)
            layoutManager.setModelToCell(type: .entry, model: nil)
            layoutManager.setModelToCell(type: .floor, model: nil)
            layoutManager.setModelToCell(type: .flats, model: nil)
        }
    }
    
    func selectStreets(models: [BaseModel]) {
        let model = models.count == 1 ? models.first : nil
        layoutManager.setModelToCell(type: .street, model: model)
        if model == nil {
            IHProgressHUD.dismiss()
            dataService.selectNewDataFor(type: .street)
            
            layoutManager.setModelToCell(type: .street, model: nil)
            layoutManager.setModelToCell(type: .house, model: nil)
            layoutManager.setModelToCell(type: .housings, model: nil)
            layoutManager.setModelToCell(type: .entry, model: nil)
            layoutManager.setModelToCell(type: .floor, model: nil)
            layoutManager.setModelToCell(type: .flats, model: nil)
        }
    }
    
    
    func getNewData(type: DataType) {
        switch type {
        case .country:
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
        case .street:
            let selectedStreet = dataService.getSelectedData(type: .street)
            getHouses(streetId: selectedStreet?.id ?? 0)
        default: break
        }
    }
}

extension MainViewController: DidTapMainViewDelegate {
    func openDatePicker(state: DataType, currentRow: Int) {
        if state == dataService.getPickerType(), pickerBotContraint.constant == 0  {return}
        if pickerBotContraint.constant == 0 {
            closePicker()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.openClosedPicker(state: state, currentRow: currentRow)
            }
            return
        }
        openClosedPicker(state: state, currentRow: currentRow)
    }
    
    func openClosedPicker(state: DataType, currentRow: Int) {
        let pickerData = dataService.getArray(type: state)
        if pickerData.count == 0 {
            shakeEmpty(row: currentRow - 1)
            return
        }
        view.endEditing(true)
        layoutManager.setPickerData(type: state)
        dataService.setPickerType(type: state)
        if state == .street {
            openStreetSearch(data: pickerData)
            return
        }
        pickerBotContraint.constant = 0
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func openStreetSearch(data: [BaseModel]) {
           let vc = storyboard?.instantiateViewController(withIdentifier: "StreetSearchViewController") as! StreetSearchViewController
           vc.data = data
           vc.delegate = self
           navigationController?.pushViewController(vc, animated: true)
       }
    
    func closePicker() {
        pickerBotContraint.constant = -UIScreen.main.bounds.height
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func shakeEmpty(row: Int) {
        let cell = tableView.cellForRow(at: [0, row])
        cell?.shake()
    }
}

// MARK: -
// MARK: - DELEGATES

extension MainViewController: SaveDelegate {
    func saveAction() {
        view.endEditing(true)
        if dataService.checkAllRequiedFields() {
            IHProgressHUD.showSuccesswithStatus("Сохранено")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                IHProgressHUD.dismiss()
            }
            return
        }
        IHProgressHUD.showError(withStatus: "Заполните все обязательные поля")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            IHProgressHUD.dismiss()
        }
    }
}

extension MainViewController: StreetSearchedDelegate {
    func searchedStreetModel(model: BaseModel) {
        selectStreets(models: [model])
        dataService.setSelectedData(type: .street, model: model)
        getNewData(type: .street)
    }
}

// MARK: -
// MARK: - NETWORK REQUESTS

private extension MainViewController {
    func getAllCountries() {
        networkManager.getAllCountries()
    }
    
    func getAllRegions(countryId: Int) {
        networkManager.getAllRegions(countryId: countryId)
    }
    
    func getDistrictsFor(regionId: Int) {
        networkManager.getDistrictsFor(regionId: regionId)
    }
    
    func getCities(districtId: Int) {
        networkManager.getCities(districtId: districtId)
    }
    
    func getStreets(cityId: Int) {
        networkManager.getStreets(cityId: cityId)
    }
    
    func getHouses(streetId: Int) {
        networkManager.getHouses(streetId: streetId)
    }
}


