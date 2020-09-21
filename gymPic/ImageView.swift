//
//  ImageView.swift
//  WhatFlower
//
//  Created by Kharl McCatty on 8/17/20.
//  Copyright © 2020 Kharl McCatty. All rights reserved.
//

import Combine
import SwiftUI
struct ImageView: View {
    @ObservedObject var imageLoader:ImageLoader
    @State var image:UIImage = UIImage()
init(withURL url:String) {
        imageLoader = ImageLoader(urlString:url)
    }
var body: some View {
    VStack {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }.onReceive(imageLoader.dataPublisher) { data in
        self.image = UIImage(data: data) ?? UIImage()
    }
  }
}
struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(withURL: "")
    }
}
