//
//  TrackCountCell.swift
//  FHZL
//
//  Created by hk on 2018/5/28.
//  Copyright © 2018年 hk. All rights reserved.
//

import UIKit

public class TrackCountCell: UITableViewCell {
    
    @IBOutlet weak var roatLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!

      @objc  var trackPointModel : TrackPointModel?{
        didSet{
            startTime.text = NSLocalizedString("Start Time:", comment: "")
            endTime.text = NSLocalizedString("End Time:", comment: "")
            roatLabel.text = NSLocalizedString("Long", comment: "")
            startLabel.text = trackPointModel!.startTime
            endLabel.text = trackPointModel!.endTime
            let dis : NSString = trackPointModel!.distance! as NSString
            if  dis.floatValue >= 1000{
                distanceLabel.text =  String(format: "%.2fKM", dis.floatValue/1000.0)
            }else{
                distanceLabel.text =  String(format: "%.0fM", dis.floatValue)
            }
            
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
