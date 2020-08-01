//
//  SelectLayoutManager.swift
//  EuroTorgTestTask
//
//  Created by Ivan Apet on 7/31/20.
//  Copyright © 2020 Ivan Apet. All rights reserved.
//

import UIKit

class SelectLayoutManager: NSObject {
    private let viewController: SelectViewController!
    private let tableView: UITableView!
    private let pickerView: UIPickerView!
    
    private var cellData = [UITableViewCell]()
    
    init(vc: SelectViewController, tableView: UITableView, pickerView: UIPickerView) {
        self.viewController = vc
        self.tableView = tableView
        self.pickerView = pickerView
        super.init()
        configure()
    }
}

extension SelectLayoutManager {
    func configure() {
        tableView.dataSource = self
    }
}


extension SelectLayoutManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellData[indexPath.row]
    }
}

extension SelectLayoutManager {
    func makeCells() {
        cellData.append(makeMainCell(type: .country, model: nil))
        cellData.append(makeMainCell(type: .region, model: nil))
    }
    
    func makeMainCell(type: DataType, model: BaseModel?) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableCell") as! MainTableCell
        cell.set(type: type, model: model)
        cell.delegate = self
        return cell
    }
}

extension SelectLayoutManager: DidTapMainViewDelegate {
    func openDatePicker(state: DataType) {
        
    }
}
