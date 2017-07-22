//
//  SideViewController.swift
//  Marriage
//
//  Created by ZooZoo on 6/17/16.
//  Copyright © 2016 ZooZoo. All rights reserved.
//

import UIKit

class SideViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{

    //MARK: - iboutlets
    @IBOutlet var tableMenu : UITableView!
    @IBOutlet var lblWelcome : UILabel!
    @IBOutlet var lblName : UILabel!
    @IBOutlet var imgProfile : UIImageView!
    
    //MARK: - variables
    var arrMenuTxt : [String] = ["Favourites" , "Downloaded"]
    var indexSelected : Int? = 0
    
    //MARK: - view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set name
        self.lblWelcome.text = NSLocalizedString("welcome", comment: "")
        self.lblName.text = userFName + " " + userLName
        
        if userImage == ""
        {
            self.imgProfile.image = UIImage(named: "IconDefault")
        }
        
        
    }

    
    //MARK: - table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrMenuTxt.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! SideMenuTableViewCell
        cell.lblMenu.text = self.arrMenuTxt[indexPath.row]
        if (self.indexSelected == indexPath.row)
        {
            UIView.animate(withDuration: 0.5, animations: {
                cell.viewMenu.backgroundColor = pinkColor
            })
        }
        else
        {
            UIView.animate(withDuration: 0.5, animations: {
                cell.viewMenu.backgroundColor = UIColor.white
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexSelected = nil
        UIView.animate(withDuration: 0, animations: {
            self.tableMenu.reloadData()
        }, completion: {_ in
            self.indexSelected = indexPath.row
            self.tableMenu.reloadData()
        })    }
    
    

    

}
