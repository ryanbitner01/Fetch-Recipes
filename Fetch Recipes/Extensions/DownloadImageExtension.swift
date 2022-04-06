//
//  DownloadImageExtension.swift
//  Fetch Recipes
//
//  Created by Ryan Bitner on 3/30/22.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImage(url: String) {
        let dataTask = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, err in
            if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.image = image
                }
            } else if let err = err {
                print(err.localizedDescription)
            }
        }
        dataTask.resume()
    }
}
