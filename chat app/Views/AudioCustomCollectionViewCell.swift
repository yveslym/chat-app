//
//  AudioCustomCollectionViewCell.swift
//  chat app
//
//  Created by Yves Songolo on 1/18/19.
//  Copyright © 2019 Yves Songolo. All rights reserved.
//

import UIKit
import MessageKit
import SwiftIcons
import SwiftySound



open class AudioCustomCell: UICollectionViewCell {

    var button: CustomButton!

  
    
    open func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {

         let size = CGRect.init(x: frame.origin.x, y: frame.origin.y, width: 100, height: 20)
        button = CustomButton.init(frame: size)
        button.newLayerColor = .primary

        button.setIcon(prefixText: "Play Audio", prefixTextColor: .white, icon: .googleMaterialDesign(.playArrow), iconColor: .white, postfixText: " ", postfixTextColor: .blue, forState: .normal, textSize: 15, iconSize: 20)


       


        let stackView = CustomStack.init(subview: [button], alignment: .center, axis: .horizontal, distribution: .fill)




        self.contentView.addSubview(button)

//        button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
//        button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true

        let message = message as! MessageUI
        if message.message.receiver != User.current?.phoneNumber{
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        }
        else {
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        }


        // contentView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 100).isActive = true

//        button.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3).isActive = true
//        button.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1).isActive = true
//        button.centerXAnchor.constraint(equalToSystemSpacingAfter: contentView.centerXAnchor, multiplier: 1).isActive = true
//         button.centerYAnchor.constraint(equalToSystemSpacingBelow: contentView.centerYAnchor, multiplier: 0.2).isActive = true

//        button.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1).isActive = true
//        button.bottomAnchor.constraint(equalToSystemSpacingBelow: contentView.bottomAnchor, multiplier: 1).isActive = true
//        button.trailingAnchor.constraint(equalToSystemSpacingAfter: contentView.trailingAnchor, multiplier: 0.5).isActive = true
//        //button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50).isActive = true
//         button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 50).isActive = true
    }
}
class CustomStack: UIStackView{
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    convenience init (subview: [UIView], alignment: UIStackView.Alignment, axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution){
        self.init(arrangedSubviews: subview)
        self.alignment = alignment
        self.axis = axis
        self.distribution = distribution
        translatesAutoresizingMaskIntoConstraints = false
    }
}

class CustomButton: UIButton{
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    convenience init(title: String, fontSize: CGFloat, titleColor: UIColor,target: Any?, action: Selector, event: UIControl.Event){
        self.init()

        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize)
        self.setTitleColor(titleColor, for: .normal)
        self.addTarget(target, action: action, for: event)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isEnabled = true
        self.backgroundColor = UIColor.white


    }
    var shadowLayer: CAShapeLayer!

    var newLayerColor: UIColor = UIColor.white{
        didSet{
            if shadowLayer != nil{
                shadowLayer.fillColor = newLayerColor.cgColor
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 5).cgPath
            shadowLayer.fillColor = newLayerColor.cgColor

            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.5
            shadowLayer.shadowRadius = 2

            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}


