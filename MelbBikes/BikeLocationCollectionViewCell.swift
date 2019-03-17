//
//  BikeLocationCollectionViewCell.swift
//  MelbBikes
//
//  Created by Sam Wright on 21/2/19.
//  Copyright © 2019 Sam Wright. All rights reserved.
//

import UIKit

class BikeLocationCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        
    }
    
    var location: String?
    var available: Int?
    var capacity: Int?
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let capacityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(location: String, available: Int, capacity: Int) {
        self.location = location
        self.available = available
        self.capacity = capacity
        locationLabel.text = location;
        capacityLabel.text = "\(available) / \(capacity)"
        gradientBackgroundColor()
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupCell() {
        roundCorner()
        gradientBackgroundColor()
        let containerView = UIView()
        containerView.addSubview(locationLabel)
        containerView.addSubview(capacityLabel)
        self.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        locationLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        locationLabel.numberOfLines = 3
        locationLabel.lineBreakMode = .byWordWrapping
        
        capacityLabel.translatesAutoresizingMaskIntoConstraints = false
        capacityLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        capacityLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        capacityLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        capacityLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 20).isActive = true
    }
    
    func cellRandomBackgroundColors(colorStage: Int) -> [UIColor] {
        //Colors
        let red = [#colorLiteral(red: 0.9654200673, green: 0.1590853035, blue: 0.2688751221, alpha: 1),#colorLiteral(red: 0.7559037805, green: 0.1139892414, blue: 0.1577021778, alpha: 1)]
        let orangeRed = [#colorLiteral(red: 0.9338900447, green: 0.4315618277, blue: 0.2564975619, alpha: 1),#colorLiteral(red: 0.8518816233, green: 0.1738803983, blue: 0.01849062555, alpha: 1)]
        let orange = [#colorLiteral(red: 0.9953531623, green: 0.54947716, blue: 0.1281470656, alpha: 1),#colorLiteral(red: 0.9409626126, green: 0.7209432721, blue: 0.1315650344, alpha: 1)]
        let yellow = [#colorLiteral(red: 0.9409626126, green: 0.7209432721, blue: 0.1315650344, alpha: 1),#colorLiteral(red: 0.8931249976, green: 0.5340107679, blue: 0.08877573162, alpha: 1)]
        let green = [#colorLiteral(red: 0.3796315193, green: 0.7958304286, blue: 0.2592983842, alpha: 1),#colorLiteral(red: 0.2060100436, green: 0.6006633639, blue: 0.09944178909, alpha: 1)]
        
        let colorsTable: [Int: [UIColor]] = [0: red, 1: orangeRed, 2: orange, 3: yellow, 4: green, 5: green]
        
        return colorsTable[colorStage]!
    }
    
    func gradientBackgroundColor() {
        if(self.capacity == nil && self.available == nil) {
            let colors = cellRandomBackgroundColors(colorStage: 3)
            self.contentView.setGradientBackgroundColor(colorOne: colors[0], colorTow: colors[1])
            return
        }
        let percentageComplete = Float(self.available!) / Float(self.capacity!)
        let convertPercentageToStage = Int(floor(percentageComplete * 5))
        let colors = cellRandomBackgroundColors(colorStage: convertPercentageToStage)
        self.contentView.setGradientBackgroundColor(colorOne: colors[0], colorTow: colors[1])
    }
    
    func roundCorner() {
        self.contentView.layer.cornerRadius = 12.0
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
    }
}
