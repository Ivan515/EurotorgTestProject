//
//  ViewController.swift
//  EuroTorgTestTask
//
//  Created by Ivan Apet on 7/29/20.
//  Copyright © 2020 Ivan Apet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    let manager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.getAllCountries { (models, error) in
            guard let firstModel = models?.first, let id = firstModel.id else {return}
            self.manager.getRegions(countryId: id) { (regions, error) in
                print()
            }
        }
    }


}

