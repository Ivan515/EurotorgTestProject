//
//  Extensions.swift
//  EuroTorgTestTask
//
//  Created by Ivan Apet on 8/3/20.
//  Copyright © 2020 Ivan Apet. All rights reserved.
//

import UIKit

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 1
        animation.values = [-20.0, 20.0, -15.0, 15.0, -10.0, 10.0, -5.0, 5.0, 0.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}

extension UITableView {
    public func dequeueReusableCell<T: UITableViewCell>(ofType type: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: type.className) as? T else {
            fatalError("Couldn't find UITableViewCell of class \(type.className)")
        }
        return cell
    }
}

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}

extension UIStoryboard {
    public func instantiate<T: UIViewController>(_ type: T.Type) -> T {
        guard let vc = self.instantiateViewController(withIdentifier: String(describing: type.self)) as? T else {
            fatalError("Could not instantiate view controller \(T.self)") }
        return vc
    }
    
    public static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
}
