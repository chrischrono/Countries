//
//  InfoView.swift
//  Countries
//
//  Created by Christian  Huang on 18/11/18.
//  Copyright © 2018 Christian Huang. All rights reserved.
//

import UIKit

class InfoView: UIView {
    var title: String? {
        didSet{
            titleLabel.text = title
        }
    }
    var info: String? {
        didSet{
            infoLabel.text = info
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    class func instanceFromNib(title: String? = nil) -> InfoView {
        let instance = UINib(nibName: "InfoView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! InfoView
        instance.title = title
        return instance
    }
    
    override func awakeFromNib() {
        self.infoLabel.text = nil
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
