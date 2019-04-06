//
//  LoadingCell.swift
//  ATestsAssignment
//
//  Created by Vitalii Shkliar on 4/6/19.
//  Copyright © 2019 Vitalii Shkliar. All rights reserved.
//

import UIKit

class LoadingCell : UITableViewCell {
    var activityIndicator: UIActivityIndicatorView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
   func setup() {
        guard activityIndicator == nil else {
            activityIndicator.startAnimating()
            return
        }
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .gray
        
        contentView.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            indicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            indicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            ])
        
        indicator.startAnimating()
    }
}
