//
//  DeviceInfoCell.swift
//  JDCraftyCompanion
//
//  Created by Justin DiStaulo on 2020-06-17.
//  Copyright © 2020 Justin DiStaulo. All rights reserved.
//

import UIKit

class DeviceInfoCell: UITableViewCell {
    
    public static let reuseIdentifier = "DeviceInfoCell"
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.jdText
        titleLabel.textAlignment = .left
        
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.textColor = UIColor.jdText
        valueLabel.textAlignment = .right
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        valueLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8).isActive = true
        valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 24).isActive = true
        valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func configure(withTitle title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
}
