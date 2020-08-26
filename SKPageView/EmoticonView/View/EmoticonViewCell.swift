//
//  EmoticonViewCell.swift
//  SKPageView
//
//  Created by sunke on 2020/8/26.
//  Copyright © 2020 KentSun. All rights reserved.
//

import UIKit

class EmoticonViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    var emoticon : Emoticon? {
        didSet {
            imageView.image = UIImage(named: emoticon!.emoticonName)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()


    }

}
