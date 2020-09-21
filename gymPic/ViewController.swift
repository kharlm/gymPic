//
//  ViewController.swift
//  WhatFlower
//
//  Created by Kharl McCatty on 8/8/20.
//  Copyright © 2020 Kharl McCatty. All rights reserved.
//

import UIKit
import SwiftUI
import CoreML
import Vision
import Alamofire
import SwiftyJSON
import SDWebImage
import AVKit
import youtube_ios_player_helper
var video = ""
var muscleImageUrl = ""
var gymImageUrl = ""
var majorMuscle = ""
class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, YTPlayerViewDelegate {
   
    var equipmentName = ""
    var equipmentDefinition = ""
    var muscleImage = ""

    let wikipediaURL = "https://en.wikipedia.org/w/api.php"
    let imagePicker = UIImagePickerController()
    var equipmentBrain = EquipmentBrain()
    
    @IBSegueAction func showResults(_ coder: NSCoder) -> UIViewController? {
        
        let cardView = CardView(equipmentImage: gymImageUrl,muscleImage: muscleImageUrl,muscleWorked: majorMuscle,category: "The equipment is", heading: equipmentName, author: equipmentDefinition)
        
        return UIHostingController(coder: coder, rootView: cardView)
        
    }
    @IBOutlet var playerView: YTPlayerView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        
    }
    
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            guard let convertCIImage = CIImage(image: userPickedImage) else {
                fatalError("cannot convert to ciImage")
            }
            detect(image: convertCIImage)
            imageView.image = userPickedImage
            
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: GymImageClassifier().model) else {
            fatalError("Cannot import model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
           
            guard let classification = request.results?.first as? VNClassificationObservation else {
                fatalError("Could not classify image.")
            }
            
            self.navigationItem.title = classification.identifier.capitalized
            self.requestInfo(flowerName: classification.identifier,type: "equipment")
            print("RESULTS!!!\(classification)")
            
           
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do{
            try handler.perform([request])
        }
            
        catch {
            print("catch error!! \(error)" )
        }
    }
    
    func requestInfo(flowerName: String, type: String) {
        
        let parameters : [String:String] = [
            "format" : "json",
            "action" : "query",
            "prop" : "extracts|pageimages",
            "exintro" : "",
            "explaintext" : "",
            "titles" : flowerName.lowercased(),
            "indexpageids" : "",
            "redirects" : "1",
            "pithumbsize" : "500"
        ]
        
        AF.request(wikipediaURL, method: .get, parameters: parameters).responseJSON { (response) in
            
            do {
                
                let dataResponse = try response.result.get()
                //print("RESULTS \(response.result)")
                let flowerJSON: JSON = JSON(dataResponse)
                
                
                let pageID = flowerJSON["query"]["pageids"][0].stringValue
                if type == "equipment" {
                video = self.equipmentBrain.getEquipmentVideo(equipmentName: flowerName)
                majorMuscle = self.equipmentBrain.getMuscleName(equipmentName: flowerName)
                self.equipmentName = flowerName.capitalized
                self.equipmentDefinition = flowerJSON["query"]["pages"][pageID]["extract"].stringValue
                gymImageUrl = flowerJSON["query"]["pages"][pageID]["thumbnail"]["source"].stringValue
                self.requestInfo(flowerName: majorMuscle, type: "muscle")
                   
                }
                else {
                    let pageID = flowerJSON["query"]["pageids"][0].stringValue
                    muscleImageUrl = flowerJSON["query"]["pages"][pageID]["thumbnail"]["source"].stringValue
                    self.performSegue(withIdentifier: "showResult", sender: self)
                    
                }
            } catch {
                
                print("SECOND Error!!, \(error)")
                
            }
        }
    }
}
struct WebView: UIViewRepresentable {
   
    func makeUIView(context: Context) -> WKWebView {
         let webConfiguration = WKWebViewConfiguration()
               webConfiguration.allowsInlineMediaPlayback = true
       return WKWebView(frame: .zero, configuration: webConfiguration)
    }

    func updateUIView(_ view: WKWebView, context: UIViewRepresentableContext<WebView>) {
        let youtubeURL = URL(string: "https://www.youtube.com/embed/\(video)?autoplay=1&playsinline=1")
              let request = URLRequest(url: youtubeURL!)
              view.load(request)
    }
}
struct CardView: View {
   
    @State var maxHeight:CGFloat = 200
    var equipmentImage: String
    var muscleImage: String
    var muscleWorked: String
    var category: String
    var heading: String
    var author: String
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                VStack {
                    
                    ImageView(withURL: equipmentImage)
                    HStack {
                        VStack(alignment: .leading) {
                            Text(category)
                                //.font(.headline)
                                .foregroundColor(.secondary)
                                .font(.system(size: 11))
                            Text(heading)
                                .font(.title)
                                .font(.system(size: 20))
                                .fontWeight(.black)
                                .foregroundColor(.primary)
                                .lineLimit(3)
                            Text(author)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(4)
                        }
                        .layoutPriority(100)
                        //Spacer()
                    }
                    .padding()
                }
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.3), lineWidth: 1)
                )
                    .padding([.top, .horizontal])
                    .frame(height:UIScreen.main.bounds.height*0.5)
                VStack {
                     WebView()
                    HStack {
                        VStack() {
                            Text("How to use \(heading)")
                            .font(.title)
                            .font(.system(size: 10))
                            .fontWeight(.black)
                            .foregroundColor(.primary)
                            .lineLimit(3)
                            .padding(.bottom, 10)
                            .padding(.top, 10)
                            .padding(.leading, 23)
                                                    }
                        .layoutPriority(100)
                        
                        Spacer()
                    }
                    .padding()
                }
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.3), lineWidth: 1)
                )
                    .padding([.top, .horizontal])
                .frame(height:UIScreen.main.bounds.height*0.5)
            }
            VStack {
                ImageView(withURL: muscleImage)
                HStack {
                    VStack(alignment: .leading) {
                        Text("Major muscle muscle worked")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(majorMuscle)
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundColor(.primary)
                            .lineLimit(2)
                            .padding(.leading, 15)
                        
                    }
                    .layoutPriority(100)
                    
                    Spacer()
                }
                .padding()
            }
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.3), lineWidth: 1)
            )
                .padding([.top, .horizontal])
            .frame(height:UIScreen.main.bounds.height*0.5)
        }
    }
}
struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(.vertical){
            CardView(equipmentImage: "swiftui-button", muscleImage: "muscle IS",muscleWorked: majorMuscle,category: "SwiftUI", heading: "Drawing a Border with Rounded Corners", author: "Simon Ng")
            
        }
        
    }
}
