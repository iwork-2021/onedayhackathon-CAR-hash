//
//  SinglePhotoViewController.swift
//  OndDayHackathon
//
//  Created by nju on 2021/12/21.
//

import UIKit

class SinglePhotoViewController: UIViewController {

    @IBOutlet weak var imageV: UIImageView!
    var img:UIImage?=nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageV.image=self.img
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
