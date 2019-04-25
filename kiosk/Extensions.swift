//
//  Extensions.swift
//  kiosk
//
//  Created by Sage Conger on 4/25/19.
//  Copyright © 2019 sageconger. All rights reserved.
//

import UIKit

extension UIView {
    var usesAutoLayout: Bool {
        get {
            return translatesAutoresizingMaskIntoConstraints
        }
        set {
            translatesAutoresizingMaskIntoConstraints = !newValue
        }
    }
}

@discardableResult
func with<T>(_ object: T, closure: (T) -> Void) -> T {
    closure(object)
    return object
}

@objc final class ClosureSleeve: NSObject {
    let closure: ()->()
    
    init (_ closure: @escaping ()->()) {
        self.closure = closure
        super.init()
    }
    
    @objc func invoke () {
        closure()
    }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event, action: @escaping () -> Void) {
        let sleeve = ClosureSleeve(action)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
