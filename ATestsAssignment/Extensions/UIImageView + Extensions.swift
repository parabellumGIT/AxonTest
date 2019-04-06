//
//  UIImageView + Extensions.swift
//  ATestsAssignment
//
//  Created by Vitalii Shkliar on 4/6/19.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView {
    func setImage(from url: URL?, defaultImg: UIImage?) {
        if let url = url {
            self.kf.setImage(with: url, placeholder: defaultImg)
        } else {
            self.image = defaultImg
        }
    }
}
