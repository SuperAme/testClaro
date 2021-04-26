//
//  MainViewController.swift
//  testClaro
//
//  Created by IDS Comercial on 24/04/21.
//

import UIKit

protocol MyDelegate{
     func didFetchData(data:[Results])
}
class MainViewController: UIViewController {
    
    var dict = [Results]()
    var subDict = [[Any]]()
    let moviesManager = MoviesManager()
    var titleToSend: String?
    var descrToSend: String?
    var dateToSend: String?
    var ratingToSend: Float?
    var imageUrlToSend: String?
    let userDefaults = UserDefaults.standard
    var dateFromUserDefaults = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
//        getDates()
        
        if let dataFromUserDefaults = userDefaults.string(forKey: "DateService") {
            dateFromUserDefaults = dataFromUserDefaults
            
//            print("no soy vacio :)")
//            print("dtf\(dateFromUserDefaults)")
        } else {
            var getDate = getDates()
            userDefaults.setValue(getDate, forKey: "DateService")
            moviesManager.parseJson { (data) in
                self.dict = data.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                //create aneew dictionary to save data in userDefaults
                
                for i in data.results {
                    self.subDict.append([i.title!,i.overview!,i.poster_path!,i.release_date!,i.vote_average!])
                }
                self.userDefaults.setValue(self.subDict, forKey: "Movies")
            }
        }
    
        
    }
    
    func getDates() -> String {
        var currentDate = Date()
         
        // 1) Create a DateFormatter() object.
        let format = DateFormatter()
         
        // 2) Set the current timezone to .current, or America/Chicago.
        format.timeZone = .current
         
        // 3) Set the format of the altered date.
        format.dateFormat = "dd/MM/yyyy HH:mm:ss"
         
        // 4) Set the current date, altered by timezone.
//        var firstDateString = format.string(from: currentDate)
        var dateString = format.string(from: Date().addingTimeInterval(86400))
        
        return dateString
        
        // 5) Convert to date
//        guard let firstDate = format.date(from: firstDateString) else {
//            print("errot formating firstDate \(firstDateString)")
//            return
//        }
//        guard let secondDate = format.date(from: secondDateString) else {
//            print("errot formating firstDate \(secondDateString)")
//            return
//        }
        
//        print(firstDate)
//        print(secondDate)
        // 6) Compare dates
//
//        let isDescending = firstDate.compare(secondDate) == ComparisonResult.orderedDescending
//        print("orderedDescending: \(isDescending)")
//
//        let isAscending = firstDate.compare(secondDate) == ComparisonResult.orderedAscending
//        print("orderedAscending: \(isAscending)")
//
//        let isSame = firstDate.compare(secondDate) == ComparisonResult.orderedSame
//        print("orderedSame: \(isSame)")

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

