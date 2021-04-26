//
//  MainViewController.swift
//  testClaro
//
//  Created by IDS Comercial on 24/04/21.
//

import UIKit

class MainViewController: UIViewController {
    
    var dict = [Results]()
    var subDict = [[String]]()
    let moviesManager = MoviesManager()
    var titleToSend: String?
    var descrToSend: String?
    var dateToSend: String?
    var ratingToSend: String?
    var imageUrlToSend: String?
    let userDefaults = UserDefaults.standard
    var dateFromUserDefaults = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        if let dataFromUserDefaults = userDefaults.string(forKey: "DateService") {
            dateFromUserDefaults = dataFromUserDefaults
            var comparisionDates = getDate(dateUserDfs: dataFromUserDefaults)
            
            if (comparisionDates == true) {
                moviesManager.parseJson { (data) in
                    for i in data.results {
                        self.subDict.append([i.title!,i.overview!,i.poster_path!,i.release_date!,"\(i.vote_average!)"])
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } else {
                subDict = userDefaults.array(forKey: "Movies") as! [[String]]
            }
            
        } else {
            var defaultDate = Date()
            let format = DateFormatter()
            format.timeZone = .current
            format.dateFormat = "dd-MM-yyyy HH:mm:ss"
            var currentDate = format.string(from: defaultDate.addingTimeInterval(86400))
            
            moviesManager.parseJson { (data) in
                self.dict = data.results
                //create new dictionary to save data in userDefaults
                
                for i in data.results {
                    self.subDict.append([i.title!,i.overview!,i.poster_path!,i.release_date!,"\(i.vote_average!)"])
                }
                self.userDefaults.setValue(self.subDict, forKey: "Movies")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            userDefaults.setValue(currentDate, forKey: "DateService")
        }
        
    }
    
    func getDate(dateUserDfs: String) -> Bool {
        //get CurrentDate
        let date = Date()
        var result = false
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let dateFromServer = dateFormatter.string(from: date)
        let currentDate = dateFormatter.date(from: dateFromServer)?.addingTimeInterval(-18000)
        //get DateFromUserDefaults
        let dateFromUserDfsToDate = dateFormatter.date(from: dateUserDfs)?.addingTimeInterval(-18000)
        print("currentDate\(currentDate)")
        print(dateFromUserDfsToDate)
        //Compare Dates
        if (currentDate != nil && dateFromUserDfsToDate != nil) {
            var secondsInterval = (dateFromUserDfsToDate?.timeIntervalSince(currentDate!))!
            if secondsInterval <= 0.0 {
                result = true
            } else {
                result = false
            }
        }
        return result
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
        return subDict.count - 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MoviesTableViewCell
        cell.titleLabel.text = subDict[indexPath.row][0]
        cell.dateLabel.text = subDict[indexPath.row][3]
        if let url = URL(string: "\(Constants.imageURL)\(subDict[indexPath.row][2])" ?? "") {
            
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
        titleToSend = subDict[indexPath.row][0]
        descrToSend = subDict[indexPath.row][1]
        dateToSend = subDict[indexPath.row][3]
        ratingToSend = subDict[indexPath.row][4]
        imageUrlToSend = subDict[indexPath.row][2]
        self.performSegue(withIdentifier: "movieCardSegue", sender: self)
    }
}

