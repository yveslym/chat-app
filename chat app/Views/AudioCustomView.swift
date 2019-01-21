//
//  AudioView.swift
//  chat app
//
//  Created by Yves Songolo on 1/18/19.
//  Copyright © 2019 Yves Songolo. All rights reserved.
//

import Foundation
import UIKit

import SwiftIcons


class AudioCustomView: UIView{


    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var contentView: UIView!

    var button: UIButton!



    override init(frame: CGRect) {
        super.init(frame: frame)

        button = UIButton.init(type: .system)
        button.setIcon(icon: .googleMaterialDesign(.playArrow), forState: .normal)


        let stackView = UIStackView.init(arrangedSubviews: [ button])
        stackView.alignment = .fill
        stackView.axis = .horizontal



        self.addSubview(stackView)

        stackView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1).isActive = true
        stackView.bottomAnchor.constraint(equalToSystemSpacingBelow: bottomAnchor, multiplier: 1).isActive = true
        stackView.leftAnchor.constraint(equalToSystemSpacingAfter: leftAnchor, multiplier: 1).isActive = true
        //stackView.leftAnchor.constraint(equalToSystemSpacingBelow: leftAnchor, multiplier: 1).isActive = true
        stackView.rightAnchor.constraint(equalToSystemSpacingAfter: rightAnchor, multiplier: 1).isActive = true
       // stackView.rightAnchor.constraint(equalToSystemSpacingBelow: rightAnchor, multiplier: 1).isActive = true

        //commonInit()
    }

    init (frame: CGRect, message: Message){
        super.init(frame: frame)

        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)


    }

    func commonInit(){
        Bundle.main.loadNibNamed("AudioCustomView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    
}
