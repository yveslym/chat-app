//
//  viewControllers.swift
//  Linner
//
//  Created by Yves Songolo on 8/23/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    func presentAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        alert.addAction(cancel)
        self.present(alert,animated: true)
    }
    
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

//public extension UIView {
//    public class func fromNib(nibNameOrNil: String? = nil, type: Any) -> Self {
//        return fromNib(nibNameOrNil: nibNameOrNil, type: self)
//    }
//
//    public class func fromNib< T : UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T {
//        let v: T? = fromNib(nibNameOrNil: nibNameOrNil, type: T.self)
//        return v!
//    }
//
//    public class func fromNib<T : UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T? {
//        var view: T?
//        let name: String
//        if let nibName = nibNameOrNil {
//            name = nibName
//        } else {
//            // Most nibs are demangled by practice, if not, just declare string explicitly
//            name = nibName
//        }
//        let nibViews = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
//        for v in nibViews! {
//            if let tog = v as? T {
//                view = tog
//            }
//        }
//        return view
//    }
//
//    public class var nibName: String {
//        let name = "\(self)".components(separatedBy: ".").first ?? ""
//        return name
//    }
//    public class var nib: UINib? {
//        if let _ = Bundle.main.path(forResource: nibName, ofType: "nib") {
//            return UINib(nibName: nibName, bundle: nil)
//        } else {
//            return nil
//        }
//    }
//}
