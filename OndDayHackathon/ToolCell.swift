//
//  ToolCell.swift
//  OndDayHackathon
//
//  Created by nju on 2021/12/21.
//

import UIKit

class ToolCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var viewController:MainViewController?=nil
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func addFromCamera(_ sender: Any) {
        print(1)
        viewController!.takePicture()
    }
    @IBAction func addFromAlbum(_ sender: Any) {
        print(2)
        viewController!.choosePhoto()
    }
    
}
