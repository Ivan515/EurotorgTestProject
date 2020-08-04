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
        titleLbl.setAttributedTextWithSubscripts(text: "\(type.makeTitle())*") 
        
        valueLbl.text = model?.makeName() ?? "Не выбранно"
        valueLbl.textColor = model?.name == nil ? .red : .black
    }
}

private extension MainTableCell {
    func configure() {
        selectionStyle = .none
        valueView.layer.cornerRadius = 8
        valueView.layer.borderWidth = 1
        valueView.layer.borderColor = UIColor.lightGray.cgColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        valueView.isUserInteractionEnabled = true
        valueView.addGestureRecognizer(tap)
    }
    
    @objc func tapAction() {
        delegate?.openDatePicker(state: type, currentRow: currentRow)
    }
}

extension UILabel {
    /// Sets the attributedText property of UILabel with an attributed string
    /// that displays the characters of the text at the given indices in subscript.
    func setAttributedTextWithSubscripts(text: String) {
        let greenColor = UIColor.red
        let font:UIFont? = self.font
        let fontSuper:UIFont? = self.font
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font:font!])
        attString.setAttributes([NSAttributedString.Key.font:fontSuper!,NSAttributedString.Key.baselineOffset:2, NSAttributedString.Key.foregroundColor : greenColor], range: NSRange(location:text.count - 1,length:1))
        attributedText = attString
    }
}
