//
//  ViewController.swift
//  OndDayHackathon
//
//  Created by nju on 2021/12/21.
//

import UIKit

class MainViewController: UITableViewController {

    var album:MyAlbum?=nil
    //表状态机，0为浏览全部，1为浏览类别，2为浏览具体类别
    var viewMode:Int=0

    //当前选中的类别
    var selectedClass:String?=nil
    
    var numberOfRows:[()->Int]=[]
    var dataForCell:[(UITableView,IndexPath)->UITableViewCell]=[]
    
    @IBOutlet weak var viewModeButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.album=MyAlbum(table: self)
        initFsm()
    }
    private func initFsm(){
        self.numberOfRows=[
        {
            return self.album!.getImages().count
        },
        {
            return self.album!.classes.count
        },
        {
            if self.selectedClass==nil{
                return 0
            }
            return self.album!.getImagesByTag(tag: self.selectedClass!).count
        }]
        self.dataForCell=[
            {
                (tableView:UITableView,indexPath:IndexPath)->UITableViewCell in
                let icell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath)
                // Configure the cell...
                let ics=icell as! ImageCell
                let img=self.album!.getImages()[indexPath.row]
                ics.myimageview.image=img.image
                ics.mytag.text=img.tag
                return icell
            },
            {
                (tableView:UITableView,indexPath:IndexPath)->UITableViewCell in
                let ccell = tableView.dequeueReusableCell(withIdentifier: "classCell", for: indexPath)
                // Configure the cell...
                let ccs=ccell as! ClassCell
                let cls=self.album!.classes[indexPath.row]
                ccs.viewController=self
                ccs.mytag.text=cls
                return ccell
            },
            {
                (tableView:UITableView,indexPath:IndexPath)->UITableViewCell in
                let picell = tableView.dequeueReusableCell(withIdentifier: "pureImageCell", for: indexPath)
                // Configure the cell...
                let pics=picell as! PureImageCell
                pics.imageV.image=self.album!.getImagesByTag(tag: self.selectedClass!)[indexPath.row].image
                return picell
            }
        ]
        
    }
    
    @IBAction func takePicture() {
      presentPhotoPicker(sourceType: .camera)
    }

    @IBAction func choosePhoto() {
      presentPhotoPicker(sourceType: .photoLibrary)
    }

    @IBAction func changeViewMode(_ sender: Any) {
        if self.viewMode==0{
            self.viewMode=1
            self.viewModeButton.title="浏览全部图片"
        }else{
            self.viewMode=0
            self.viewModeButton.title="以类别浏览"
        }
        self.tableView.reloadData()
    }
    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
      let picker = UIImagePickerController()
      picker.delegate = self
      picker.sourceType = sourceType
      print("stop first")
      present(picker, animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.numberOfRows[self.viewMode]()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.dataForCell[self.viewMode](tableView,indexPath)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier=="imageSegue"{
            let target = segue.destination as! SinglePhotoViewController
            let imgCell = sender as! ImageCell
            target.img=imgCell.myimageview.image
        }else if segue.identifier=="classSegue"{
            let target = segue.destination as! ClassTableViewController
            let clsCell=sender as! ClassCell
            target.album=self.album
            target.selectedClass=clsCell.mytag.text!
        }
        else if segue.identifier=="pureImageSegue"{
            let target = segue.destination as! SinglePhotoViewController
            let imgCell = sender as! PureImageCell
            target.img=imgCell.imageV.image
        }
    }
    
}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    print("stop here")
    picker.dismiss(animated: true)
    let image = info[.originalImage] as! UIImage
    self.album!.addImage(image: image)
  }
}
