//
//  MyAlbum.swift
//  OndDayHackathon
//
//  Created by nju on 2021/12/21.
//

import UIKit
import CoreMedia
import CoreML
import Vision

class MyImage:NSObject{
    public var image:UIImage
    public var tag:String
    init(image :UIImage,tag:String) {
        self.image=image
        self.tag=tag
        
    }
}
//该类用于处理数据
class MyAlbum: NSObject {
    private var images:[MyImage]?=nil
    private var tempImage:UIImage?=nil
    private var table:UITableViewController
    let classes:[String]=[
    
        "apple",
        "banana",
        "cake",
        "candy",
        "carrot",
        "cookie",
        "doughnut",
        "grape",
        "hot dog",
        "ice cream",
        "juice",
        "muffin",
        "orange",
        "pineapple",
        "popcorn",
        "pretzel",
        "salad",
        "strawberry",
        "waffle",
        "watermelon",
    
    ]
    var imagesByClass:[String:[MyImage]]?=nil
    let semphore=DispatchSemaphore(value: MyAlbum.maxInflightBuffer)
    var inflightBuffer=0
    static let maxInflightBuffer=2
    init(table:UITableViewController) {
        images=[MyImage]()
        self.table=table
        self.imagesByClass=[String:[MyImage]]()
        for cls in self.classes{
            imagesByClass!.updateValue([], forKey: cls)
        }
    }
    lazy var classificationRequest: VNCoreMLRequest = {
          do{
              
              let classifier = try snacks(configuration: MLModelConfiguration())
              let model = try VNCoreMLModel(for: classifier.model)
              let request = VNCoreMLRequest(model: model, completionHandler: {
                  [weak self] request,error in
                  self?.processObservations(for: request, error: error)
              })
              request.imageCropAndScaleOption = .centerCrop
              return request
              
              
          } catch {
          fatalError("Failed to create request")
        }
    }()
    
    public func addImage(image:UIImage){
        self.tempImage=image
        classify(sampleBuffer: image)
    }
    public func getImages()->[MyImage]{
        return self.images!
    }
    public func getImagesByTag(tag:String)->[MyImage]{
        return self.imagesByClass![tag]!
    }
    
    
}
extension MyAlbum{
    func processObservations(for request: VNRequest, error: Error?) {
        if let results = request.results as? [VNClassificationObservation] {
            if results.isEmpty {
            } else {
                let result = results[0].identifier
                let confidence = results[0].confidence
                self.images!.append(MyImage(image:self.tempImage!,tag:result))
                self.imagesByClass![result]!.append(MyImage(image: self.tempImage!, tag: result))
                self.table.tableView.reloadData()
                }
            }
    }
}
extension MyAlbum{
    func classify(sampleBuffer: UIImage) {
        if !(sampleBuffer == nil) {
            semphore.wait()
            inflightBuffer += 1
            if inflightBuffer >= MyAlbum.maxInflightBuffer {
                inflightBuffer = 0
            }
            DispatchQueue.main.async {
                let handler = VNImageRequestHandler(cgImage: sampleBuffer.cgImage!, orientation:CGImagePropertyOrientation(sampleBuffer.imageOrientation))
                do {
                    try handler.perform([self.classificationRequest])
                } catch {
                    print("Failed to perform classification: \(error)")
                }
                self.semphore.signal()
            }
            
        } else {
            print("Create pixel buffer failed")
        }
    }
}
