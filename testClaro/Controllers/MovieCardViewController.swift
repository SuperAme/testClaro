//
//  MovieCardViewController.swift
//  testClaro
//
//  Created by IDS Comercial on 24/04/21.
//

import Foundation
import UIKit

class MovieCardViewController: UIViewController {
    
    var imageValue: String?
    var titleValue: String?
    var descrValue: String?
    var date: String?
    var rating: String?
    
    
    @IBOutlet weak var imageCard: UIImageView!
    @IBOutlet weak var titleCard: UILabel!
    @IBOutlet weak var descrCard: UILabel!
    @IBOutlet weak var dateCard: UILabel!
    @IBOutlet weak var ratingCard: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: "\(Constants.imageURL)\(imageValue!)" ?? "") {
            print(url)
            if let data = try? Data(contentsOf: url) {
                imageCard.image = UIImage(data: data)
            }
        }
        titleCard.text = titleValue ?? "No data"
        descrCard.text = descrValue ?? "No data"
        dateCard.text = date ?? "No data"
        ratingCard.text = "Rating: \(rating!)"
    }
}
