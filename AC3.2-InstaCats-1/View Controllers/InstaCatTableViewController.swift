//
//  InstaCatTableViewController.swift
//  AC3.2-InstaCats-1
//
//  Created by Louis Tur on 10/10/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

struct InstaCat {
    let name: String
    let id: Int
    let instagramURL: URL
    var description: String {
        return "Nice to meet you, I'm \(name)"
    }
}

class InstaCatTableViewController: UITableViewController {

    internal let InstaCatTableViewCellIdentifier: String = "InstaCatCellIdentifier"
    internal let instaCatJSONFileName: String = "InstaCats.json"
    internal var instaCats: [InstaCat] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let instaCatsURL: URL = self.getResourceURL(from: instaCatJSONFileName),
            let instaCatData: Data = self.getData(from: instaCatsURL),
            let instaCatsAll: [InstaCat] = self.getInstaCats(from: instaCatData as Data) else {
                return
        }
        
        self.instaCats = instaCatsAll
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instaCats.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InstaCatCellIdentifier", for: indexPath)
        cell.textLabel?.text = instaCats[indexPath.row].name
        cell.detailTextLabel?.text = instaCats[indexPath.row].description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.open(instaCats[indexPath.row].instagramURL)
    }
    
    // MARK: Data
    internal func getResourceURL(from fileName: String) -> URL? {
        
        // 1. There are many ways of doing this parsing, we're going to practice String traversal
        guard let dotRange = fileName.rangeOfCharacter(from: CharacterSet.init(charactersIn: ".")) else {
            return nil
        }
        
        // 2. The upperbound of a range represents the position following the last position in the range, thus we can use it
        // to effectively "skip" the "." for the extension range
        let fileNameComponent: String = fileName.substring(to: dotRange.lowerBound)
        let fileExtenstionComponent: String = fileName.substring(from: dotRange.upperBound)
        
        // 3. Here is where Bundle.main comes into play
        //The bundle is a class that represents our app and all the files/assests associated with it
        let fileURL: URL? = Bundle.main.url(forResource: fileNameComponent, withExtension: fileExtenstionComponent)
        
        return fileURL
    }
    
    internal func getData(from url: URL) -> Data? {
        
        // 1. this is a simple handling of a function that can throw. In this case, the code makes for a very short function
        // but it can be much larger if we change how we want to handle errors.
        let fileData: Data? = try? Data(contentsOf: url)
        return fileData
    }
    
    internal func getInstaCats(from jsonData: Data) -> [InstaCat]? {
        
        // 1. This time around we'll add a do-catch
        do {
            let instaCatJSONData: Any = try JSONSerialization.jsonObject(with: jsonData, options: [])
            
            // 2. Cast from Any into a more suitable data structure and check for the "cats" key
            if let catData = instaCatJSONData as? [String:[[String:Any]]] {
                
                if let cats = catData["cats"] {
                    for i in 0..<cats.count {
                        // 3. Check for keys "name", "cat_id", "instagram", making sure to cast values as needed along the way
                        if let name = cats[i]["name"] as? String, let id = cats[i]["cat_id"] as? String, let instagramURL = cats[i]["instagram"] as? String
                        //Still inside of if let binding
                        //Up until this point, all we have done was dive into the data to pull out the values needed.
                        //In the next few lines, the values are converted to the types expected by the struct
                        {
                            let instaCat = InstaCat(name: name, id: Int(id)!, instagramURL: URL(string: instagramURL)!)
                            instaCats.append(instaCat)
                        }
                    }
                }
            }
            // 4. Return something
            return instaCats
        }
        catch let error as NSError {
            // JSONSerialization doc specficially says an NSError is returned if JSONSerialization.jsonObject(with:options:) fails
            print("Error occurred while parsing data: \(error.localizedDescription)")
        }
        
        return  nil
    }

}
