//
//  ViewController.swift
//  Poke-Alea
//
//  Created by Mostafa on 07/10/2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let url = "https://pokeapi.co/api/v2/pokemon/"
    let tableView = UITableView()
    var data = [Result]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        tableView.delegate = self
        tableView.dataSource = self
        
        getData(from: url)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row + 1) : \(data[indexPath.row].name)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func getData(from url: String) {
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            
            guard let data = data, error == nil else {
                print("something went wron with URLSession")
                return
            }
            
            
            // have data
            var response: Response?
            do {
                response = try JSONDecoder().decode(Response.self, from: data)
            }
            catch {
                print("Failled to convert \(error.localizedDescription)")
            }
            
            guard let json = response else {
                return
            }
            
            print(json.previous ?? "no previous")
            
            self.data = json.results
            
        })
        
        task.resume()
    }
}

struct Response: Codable {
    let count: Int
    let next: String
    let previous: String?
    let results: [Result]
    
}

struct Result: Codable {
    let name: String
    let url: String
}
