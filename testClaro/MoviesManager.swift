//
//  MoviesManager.swift
//  testClaro
//
//  Created by IDS Comercial on 24/04/21.
//

import Foundation

struct MoviesManager {
    func parseJson(comp: @escaping (MoviesModel) -> ()) {
        if let url = URL(string: Constants.baseURL) {
            URLSession.shared.dataTask(with: url) {
                data, response, error in
                if error != nil {
                    print("Error \(error?.localizedDescription)")
                }
                do {
                    let result = try JSONDecoder().decode(MoviesModel.self, from: data!)
                    comp(result)
                } catch {
                    print("error \(error.localizedDescription)")
                }
            }.resume()
        }
    }
}
