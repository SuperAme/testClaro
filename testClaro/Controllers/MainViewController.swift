//
//  MainViewController.swift
//  testClaro
//
//  Created by IDS Comercial on 24/04/21.
//

import UIKit

class MainViewController: UIViewController {
    
    var dict = [Results]()
    let moviesManager = MoviesManager()
    var titleToSend: String?
    var descrToSend: String?
    var dateToSend: String?
    var ratingToSend: Float?
    var imageUrlToSend: String?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        moviesManager.parseJson { (data) in
            self.dict = data.results
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movieCardSegue" {
            let secondVC = segue.destination as! MovieCardViewController
            secondVC.titleValue = titleToSend
            secondVC.descrValue = descrToSend
            secondVC.date = dateToSend
            secondVC.rating = ratingToSend
            secondVC.imageValue = imageUrlToSend
        }
    }
}
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dict.count - 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MoviesTableViewCell
        cell.titleLabel.text = dict[indexPath.row].title
        cell.dateLabel.text = dict[indexPath.row].release_date
        if let url = URL(string: "\(Constants.imageURL)\(dict[indexPath.row].poster_path!)" ?? "") {
            
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    cell.moviesImage.image = UIImage(data: data)
                }
            }
        }

        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        titleToSend = dict[indexPath.row].title
        descrToSend = dict[indexPath.row].overview
        dateToSend = dict[indexPath.row].release_date
        ratingToSend = dict[indexPath.row].vote_average
        imageUrlToSend = dict[indexPath.row].poster_path
        self.performSegue(withIdentifier: "movieCardSegue", sender: self)
    }
}
