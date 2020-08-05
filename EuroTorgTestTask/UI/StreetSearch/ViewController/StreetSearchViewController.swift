//
//  StreetSearchViewController.swift
//  EuroTorgTestTask
//
//  Created by Ivan Apet on 8/5/20.
//  Copyright © 2020 Ivan Apet. All rights reserved.
//

import UIKit

protocol StreetSearchedDelegate: class {
    func searchedStreetModel(model: BaseModel)
}

class StreetSearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var data: [BaseModel]!
    weak var delegate: StreetSearchedDelegate?
    
    private var layoutManager: StreetSearchLayoutManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

}


extension StreetSearchViewController {
    func configure() {
        title = "ПОИСК УЛИЦЫ"
        let backBtn = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem = backBtn
        layoutManager = StreetSearchLayoutManager(vc: self, table: tableView, data: data)
        searchBar.delegate = self
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

extension StreetSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var arr = [BaseModel]()
        for el in data {
            if el.makeName()?.contains(searchText) ?? false {
                arr.append(el)
                layoutManager.newData(newData: arr)
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
