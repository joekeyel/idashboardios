//
//  subbbalancecontroller.swift
//  idashboard
//
//  Created by Hasanul Isyraf on 29/04/2018.
//  Copyright © 2018 Hasanul Isyraf. All rights reserved.
//

import UIKit

class subbbalancecontroller: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
   
    @IBOutlet weak var subbbalancetable: UITableView!
    
    @IBOutlet weak var searchbalance: UISearchBar!
    
    
    
    var listsubbobject:[subbbalanceobject] = []
    
    var filteredsubbplan:[subbbalanceobject]? = []
    var isSearching = false

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if searchBar.text == nil || searchBar.text == ""
        {
            
            isSearching = false
            view.endEditing(true)
           subbbalancetable.reloadData()
            
        }
        else{
            isSearching = true
            filteredsubbplan = listsubbobject.filter({$0.newcabinet!.caseInsensitiveCompare(searchBar.text!) == ComparisonResult.orderedSame || $0.region!.caseInsensitiveCompare(searchBar.text!) == ComparisonResult.orderedSame || $0.phase!.caseInsensitiveCompare(searchBar.text!) == ComparisonResult.orderedSame })
            
            subbbalancetable.reloadData()
            
            if (filteredsubbplan?.count)!>0{
                view.endEditing(true)}
            
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchsummary()
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching{
            
            return filteredsubbplan!.count
        }
        else{
            return self.listsubbobject.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subbbalancecell", for: indexPath) as! subbbalancecell
        
        if isSearching{
            
            cell.cabname.text = self.filteredsubbplan![indexPath.item].newcabinet
            cell.region.text = self.filteredsubbplan![indexPath.item].region
            cell.phase.text = self.filteredsubbplan![indexPath.item].phase
            cell.port.text = self.filteredsubbplan![indexPath.item].portvdsl
            
            return cell
            
            
        }else{
            
            cell.cabname.text = self.listsubbobject[indexPath.item].newcabinet
            cell.region.text = self.listsubbobject[indexPath.item].region
            cell.phase.text = self.listsubbobject[indexPath.item].phase
            cell.port.text = self.listsubbobject[indexPath.item].portvdsl
            
            return cell
        }
    }
    func fetchsummary(){
        
        //let uuid = UIDevice.current.identifierForVendor!.uuidString
        let urlrequest = URLRequest(url: URL(string:"http://58.27.84.166/mcconline/MCC%20Online%20V3/query_listbalancesubb.php")!)
        
        let task = URLSession.shared.dataTask(with: urlrequest){(data,response,error)  in
            
            if let data = data {
                
                self.listsubbobject = [subbbalanceobject]()
                
                do{
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String : AnyObject]
                    
                    if  let summaryfromjson  = json["Subb"] as? [[String:AnyObject]]{
                        
                        for summaryfromjson in summaryfromjson {
                            let projectobj = subbbalanceobject()
                            if let newcabinet = summaryfromjson["newsubb"] as? String,
                                let region = summaryfromjson["region"] as? String,
                                let phase = summaryfromjson["phase"] as? String,
                                let portvdsl = summaryfromjson["planvdsl"] as? String{
                                
                                print(newcabinet)
                                print(region)
                                
                                projectobj.newcabinet = newcabinet
                                projectobj.region = region
                                projectobj.phase = phase
                                projectobj.portvdsl = portvdsl
                                
                                
                                // print(listttobjects.cabinetid!)
                            }
                            self.listsubbobject.append(projectobj)
                            
                            
                        }
                        
                    }
                    DispatchQueue.main.async {
                        
                        
                        self.subbbalancetable.reloadData()
                        //                        self.activitiyindicator.stopAnimating()
                    }
                    
                }
                    
                    
                catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            }
                
                
            else if let error = error {
                print(error.localizedDescription)
            }
            
            
        }
        
        task.resume()
        
    }
    
}
