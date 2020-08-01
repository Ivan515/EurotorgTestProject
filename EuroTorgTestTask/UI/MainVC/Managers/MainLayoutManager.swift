//
//  MainLayoutManager.swift
//  EuroTorgTestTask
//
//  Created by Ivan Apet on 7/30/20.
//  Copyright © 2020 Ivan Apet. All rights reserved.
//

import UIKit


class MainLayoutManager: NSObject {
    
    private let viewController: MainViewController!
    private let tableView: UITableView!
    private let pickerView: UIPickerView!
    private let dataService: MainDataService!
    
    private var cellData = [UITableViewCell]()
    
    private var dataForPicker: [BaseModel]?
    
    var currentPickerType: DataType!
    
    init(vc: MainViewController, tableView: UITableView, pickerView: UIPickerView, dataService: MainDataService) {
        self.viewController = vc
        self.tableView = tableView
        self.pickerView = pickerView
        self.dataService = dataService
        super.init()
        configure()
    }
}

extension MainLayoutManager {
    func configure() {
        makeCells()
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    func setPickerData(type: DataType) {
        currentPickerType = type
        dataForPicker = dataService.getArray(type: type)
        
        pickerView.reloadAllComponents()
        pickerView.reloadInputViews()
    }
    
    func setModelToCell(type: DataType, model: BaseModel?) {
        let cell: MainTableCell = cellData.first { (cell) -> Bool in
            let aa = cell as? MainTableCell
            return aa?.type == type
            } as! MainTableCell
        cell.set(type: type, model: model)
    }
    
    func pickerDoneAction() {
        let models = dataService.getArray(type: currentPickerType)
        let selectedModel = models[pickerView.selectedRow(inComponent: 0)]

        dataService.setSelectedData(type: currentPickerType, model: selectedModel)
        setModelToCell(type: currentPickerType, model: selectedModel)
    }
    
}


extension MainLayoutManager : UITableViewDelegate {
    
}

extension MainLayoutManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellData[indexPath.row]
    }
}

extension MainLayoutManager {
    func makeCells() {
        cellData.append(mainCell(type: .country, model: nil))
        cellData.append(mainCell(type: .region, model: nil))
        cellData.append(mainCell(type: .districts, model: nil))
        cellData.append(mainCell(type: .cities, model: nil))
        cellData.append(mainCell(type: .street, model: nil))
        
    }
    
    func mainCell(type: DataType, model: BaseModel?) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableCell") as! MainTableCell
        cell.set(type: type, model: model)
        cell.delegate = viewController
        return cell
    }
}


extension MainLayoutManager: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataForPicker?.count ?? 0
    }
}


extension MainLayoutManager: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataForPicker?[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let models = dataService.getArray(type: currentPickerType)
        dataService.setSelectedData(type: currentPickerType, model: models[row])
        setModelToCell(type: currentPickerType, model: models[row])
    }
}
