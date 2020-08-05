//
//  StreetSearchLayoutManager.swift
//  EuroTorgTestTask
//
//  Created by Ivan Apet on 8/5/20.
//  Copyright © 2020 Ivan Apet. All rights reserved.
//

import UIKit

class StreetSearchLayoutManager: NSObject {
    
    let viewController: StreetSearchViewController!
    let tableView: UITableView!
    var data: [BaseModel]!
    
    init(vc: StreetSearchViewController, table: UITableView, data: [BaseModel]) {
        self.viewController = vc
        self.tableView = table
        self.data = data
        super.init()
        configure()
    }
}

extension StreetSearchLayoutManager {
    func configure() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func newData(newData: [BaseModel]) {
        data = newData
        tableView.reloadData()
    }
}

extension StreetSearchLayoutManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewController.delegate?.searchedStreetModel(model: data[indexPath.row])
        viewController.navigationController?.popViewController(animated: true)
    }
}

extension StreetSearchLayoutManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = data[indexPath.row].makeName()
        return cell
    }
}
