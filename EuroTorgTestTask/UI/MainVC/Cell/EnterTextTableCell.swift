//
//  EnterTextTableCell.swift
//  EuroTorgTestTask
//
//  Created by Ivan Apet on 8/1/20.
//  Copyright © 2020 Ivan Apet. All rights reserved.
//

import UIKit

class EnterTextTableCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var textField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    public func set(type: DataType) {
        titleLbl.text = type.makeTitle()
        switch type {
        case .entry, .floor, .flats:
            textField.keyboardType = .numberPad
        default:
            textField.keyboardType = .asciiCapableNumberPad
        }
    }
}

extension EnterTextTableCell {
    func configure() {
        selectionStyle = .none
        textField.delegate = self
    }
}

extension EnterTextTableCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
