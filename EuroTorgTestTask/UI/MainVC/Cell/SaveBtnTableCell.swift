//
//  SaveBtnTableCell.swift
//  EuroTorgTestTask
//
//  Created by Ivan Apet on 8/4/20.
//  Copyright © 2020 Ivan Apet. All rights reserved.
//

import UIKit

protocol SaveDelegate: class {
    func saveAction()
}

class SaveBtnTableCell: UITableViewCell {

    @IBOutlet weak var saveBtn: UIButton!
    
    weak var delegate: SaveDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    @IBAction func saveAction(_ sender: Any) {
        delegate?.saveAction()
    }

}

extension SaveBtnTableCell {
    func configure() {
        saveBtn.layer.cornerRadius = 8
    }
}
