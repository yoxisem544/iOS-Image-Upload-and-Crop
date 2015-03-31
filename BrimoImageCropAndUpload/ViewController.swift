//
//  ViewController.swift
//  BrimoImageCropAndUpload
//
//  Created by David on 2015/3/29.
//  Copyright (c) 2015年 David. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PECropViewControllerDelegate, CLUploaderDelegate {

    @IBOutlet var cropImageView: UIImageView!
    var imageFile: NSData!
    
    @IBOutlet var uploadedImagePreview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        println("hi")
        var image = UIImage(named: "tim.jpg")
        self.imageFile = NSData(data: UIImageJPEGRepresentation(image, 0.01))
        
        var data = NSData(data: UIImageJPEGRepresentation(image, 1.0))
        
        println("\(data.length)")
        
        data = NSData(data: UIImageJPEGRepresentation(image, 0.5))
        
        println("\(data.length)")
        self.cropImageView.image = UIImage(data: data)
    }
    
    @IBAction func UploadImageToCloudinary(sender: AnyObject) {
        var cloudinary = CLCloudinary()
        cloudinary.config().setValue("db5jdx753", forKey: "cloud_name")
        cloudinary.config().setValue("355556826448265", forKey: "api_key")
        cloudinary.config().setValue("lb2ubvG8qfC0-Y7VXG8wFe9SRH0", forKey: "api_secret")
        
        var uploadedImageUrl = cloudinary.url("tim.jpg")
        
        println("this is our outpur url: \(uploadedImageUrl)")
        
        var uploader = CLUploader(cloudinary, delegate: self)
        var imageFilePath = NSBundle.mainBundle().pathForResource("tim", ofType: "jpg")

        uploader.upload(self.imageFile, options: nil)
    }
    
    func uploaderSuccess(result: [NSObject : AnyObject]!, context: AnyObject!) {
        println("success, result:\(result) and context:\(context)")
        println(result["url"]!)
        var imageUrl: NSURL = NSURL(string: result["url"]! as NSString)!
        var downloadImageFromUrl: NSData = NSData(contentsOfURL: imageUrl)!
        var imageFromUrl = UIImage(data: downloadImageFromUrl)
        
        self.uploadedImagePreview.image = imageFromUrl
    }
    
    func uploaderError(result: String!, code: Int, context: AnyObject!) {
        println("error:\(result) and code: \(code) with context:\(context)")
    }
    
    func uploaderProgress(bytesWritten: Int, totalBytesWritten: Int, totalBytesExpectedToWrite: Int, context: AnyObject!) {
        println("progressing")
    }

    func cropViewController(controller: PECropViewController!, didFinishCroppingImage croppedImage: UIImage!) {
        println("finish")
        self.cropImageView.image = croppedImage
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func cropViewControllerDidCancel(controller: PECropViewController!) {
        println("cancel")
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBOutlet var pressed: UIButton!
    @IBAction func pressed(sender: AnyObject) {
        var controller = PECropViewController()
        controller.delegate = self
        controller.image = UIImage(named: "tim.jpg")
        
        //        self.navigationController?.presentViewController(controller, animated: true, completion: nil)
        self.navigationController?.pushViewController(controller, animated: true)
    }

}

