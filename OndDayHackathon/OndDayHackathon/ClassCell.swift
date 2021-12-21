//
//  ClassCell.swift
//  OndDayHackathon
//
//  Created by nju on 2021/12/21.
//

import UIKit

class ClassCell: UITableViewCell {
    var viewController:MainViewController?=nil
    private var enabled:Bool=false
    @IBOutlet weak var mytag: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        enabled=true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
