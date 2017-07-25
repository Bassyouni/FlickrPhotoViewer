//
//  SideViewController.swift
//  Marriage
//
//  Created by ZooZoo on 6/17/16.
//  Copyright © 2016 ZooZoo. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData

class SideViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{

    //MARK: - iboutlets
    @IBOutlet var tableMenu : UITableView!
    @IBOutlet var lblWelcome : UILabel!
    @IBOutlet var lblName : UILabel!
    @IBOutlet var imgProfile : UIImageView!
    
    //MARK: - variables
    var arrMenuTxt : [String] = ["Latest","Favourites" , "Downloaded"]
    var indexSelected : Int? = 0
    
    //MARK: - view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set name
        self.lblWelcome.text = NSLocalizedString("Welcome", comment: "")
        self.lblName.text = CurrentUser.name!
       
        if CurrentUser.imageURL! == ""
        {
            self.imgProfile.image = UIImage(named: "IconDefault")
        }else
        {
            self.imgProfile.sd_setImage(with: URL(string: CurrentUser.imageURL!), placeholderImage: UIImage(named: "IconDefault"))
            
            //for a round image
            imgProfile.layer.borderWidth = 1.0
            imgProfile.layer.masksToBounds = false
            imgProfile.layer.borderColor = UIColor.white.cgColor
            imgProfile.layer.cornerRadius = imgProfile.frame.size.height/2
            imgProfile.clipsToBounds = true
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
        })
        if indexPath.row == 0
        {
            let homeNav = self.storyboard?.instantiateViewController(withIdentifier: "MainVC")
            menuContainerViewController.centerViewController = homeNav
            self.menuContainerViewController.toggleLeftSideMenuCompletion({})
        }
        if indexPath.row == 1
        {
            let homeNav = self.storyboard?.instantiateViewController(withIdentifier: "LikesVC")
            menuContainerViewController.centerViewController = homeNav
            self.menuContainerViewController.toggleLeftSideMenuCompletion({})
        }
        else if indexPath.row == 2
        {
            let homeNav = self.storyboard?.instantiateViewController(withIdentifier: "DownloadVC")
            menuContainerViewController.centerViewController = homeNav
            self.menuContainerViewController.toggleLeftSideMenuCompletion({})
        }
    }
    
    //MARK: - ibactions
    @IBAction func signOutBtnPressed(_ sender: Any) {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let LandingVC = self.storyboard?.instantiateViewController(withIdentifier: "LandingVC")
        delegate?.window?.rootViewController = LandingVC
    }

    

}
