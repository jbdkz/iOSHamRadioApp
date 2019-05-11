// Project:     Capstone IOS Project
// Author:      John Diczhazy
// Date:        4/3/19
// File:        CustomCell.swift
// Description: Custom Cell

import UIKit

class CustomCell: UITableViewCell {
    
    // Create variables to hold UILabel objects
    var callLabel: UILabel!
    var cityLabel: UILabel!
    
    // Setup custom cell specifications
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let callLabelRect = CGRect(x: 0, y: 5, width: 70, height: 25)
        let callMarker = UILabel(frame: callLabelRect)
        callMarker.textAlignment = NSTextAlignment.right
        callMarker.text = "Call Sign:"
        callMarker.font = UIFont.boldSystemFont(ofSize: 15)
        contentView.addSubview(callMarker)
        
        let cityLabelRect = CGRect(x: 0, y: 26, width: 70, height: 20)
        let cityMarker = UILabel(frame: cityLabelRect)
        cityMarker.textAlignment = NSTextAlignment.right
        cityMarker.text = "City:"
        cityMarker.font = UIFont.boldSystemFont(ofSize: 12)
        contentView.addSubview(cityMarker)
        
        let callValueRect = CGRect(x: 80, y: 5, width: 200, height: 25)
        callLabel = UILabel(frame: callValueRect)
        callLabel.textColor = UIColor.red
        contentView.addSubview(callLabel)
        let stateValueRect = CGRect(x: 80, y: 25, width: 200, height: 20)
        cityLabel = UILabel(frame: stateValueRect)
        cityLabel.textColor = UIColor.black
        contentView.addSubview(cityLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Create required didSet property observers
    var call: String = "" {
        didSet {
            if (call != oldValue) {
                callLabel.text = call
            }
        }
    }
    
    var callFontColor: UIColor = UIColor.red {
        didSet {
            if (callFontColor != oldValue) {
                callLabel.textColor = callFontColor
            }
        }
    }
    
    var city: String = "" {
        didSet {
            if (city != oldValue) {
                cityLabel.text = city
            }
        }
    }
    
    var paramFontColor: UIColor = UIColor.black {
        didSet {
            if (paramFontColor != oldValue) {
                cityLabel.textColor = paramFontColor
            }
        }
    }
}
