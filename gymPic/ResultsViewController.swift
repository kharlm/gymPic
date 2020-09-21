//
//  ResultsViewController.swift
//  WhatFlower
//
//  Created by Kharl McCatty on 8/15/20.
//  Copyright © 2020 Kharl McCatty. All rights reserved.
//

import Foundation
import UIKit

class ResultsViewController:UIViewController,UICollectionViewDataSource {
    
    override func viewDidLoad() {
           super.viewDidLoad()
           
//           collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ReusableCell")
          
       }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReusableCell", for: indexPath)
        //cell.label.text = message.body
       
        return cell
    }
    


   
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
   
    
}
