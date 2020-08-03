//
//  MainTableCell.swift
//  EuroTorgTestTask
//
//  Created by Ivan Apet on 7/30/20.
//  Copyright © 2020 Ivan Apet. All rights reserved.
//

import UIKit


protocol DidTapMainViewDelegate: class {
    func openDatePicker(state: DataType, currentRow: Int)
}

class MainTableCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var valueView: UIView!
    @IBOutlet weak var valueLbl: UILabel!
    
    var delegate: DidTapMainViewDelegate?
    var type: DataType!
    var currentRow: Int!

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    public func set(type: DataType, model: BaseModel?) {
        self.type = type
        currentRow = type.makeIndex()
        titleLbl.text = type.makeTitle()
        valueLbl.text = model?.name ?? "Не выбранно"
    }
}

private extension MainTableCell {
    func configure() {
        selectionStyle = .none
        valueView.layer.cornerRadius = 8
        valueView.layer.borderWidth = 1
        valueView.layer.borderColor = UIColor.black.cgColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        valueView.isUserInteractionEnabled = true
        valueView.addGestureRecognizer(tap)
    }
    
    @objc func tapAction() {
        delegate?.openDatePicker(state: type, currentRow: currentRow)
    }
}
