//
//  MainVC.swift
//  FlickerPhotoViewer
//
//  Created by Bassyouni on 7/17/17.
//  Copyright © 2017 Bassyouni. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class MainVC: ParentViewController , UITableViewDelegate , UITableViewDataSource , UISearchBarDelegate {
    
    //MARK: - iboutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var inSearchMode: Bool!
    var flickrUserArray = [FlickrUser]()
    var flickrUserFilterdArray = [FlickrUser]()

    //MARK: - view DidLoad & DidAppear
    override func viewDidLoad() {
        
        navbarMenuBtnInit()
        inSearchMode = false
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        print(CurrentUser.name!)
        print(CurrentUser.id!)
        showLoading()
        //This function starts when the closure ends
        self.grabDataFromApi {
            
            self.hideLoading()
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    //MARK: - Navbar init and side menu toggle
    func navbarMenuBtnInit()
    {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "sideMenuBtn"), for: UIControlState.normal)
        button.addTarget(self, action:#selector(MainVC.toggleSideMenu), for: UIControlEvents.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    /// Opens and Closes Side menu
    func toggleSideMenu() {
        self.menuContainerViewController.toggleLeftSideMenuCompletion({})
    }
    
    //MARK: - Api Call
    /// This fucntion uses Alamofire to make json calls and return latest flickr intersting photos & it's info
    ///
    /// - Parameter complete:
    func grabDataFromApi(complete :@escaping downloadCompleted)
    {
        Alamofire.request(urlForGetRecent).responseJSON
        {
            response in
            
            if let dic = response.result.value as? Dictionary<String , AnyObject>
            {
                if let status = dic["stat"] as? String
                {
                    if status == "ok"
                    {
                        if let photosDic = dic["photos"] as? Dictionary<String , AnyObject>
                        {
                            if let photoArray = photosDic["photo"] as? [Dictionary<String , AnyObject>]
                            {
                                for obj in photoArray
                                {
                                    let tempUser = FlickrUser(dic: obj)
                                    self.flickrUserArray.append(tempUser)
                                }
                            }
                        }
                    }
                    else
                    {
                        print("problem with request -> \(status)")
                    }
                }
             complete()
            }
            
        }
    }
        
    //MARK: - table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode
        {
            return flickrUserFilterdArray.count
        }
        return flickrUserArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FlickrCell", for: indexPath) as? FlickrCell
        {
            var flickrUser: FlickrUser!
            if inSearchMode
            {
                flickrUser = flickrUserFilterdArray[indexPath.row]
            }
            else
            {
                flickrUser = flickrUserArray[indexPath.row]
            }
            
            cell.configureCell(flickrUser: flickrUser)
            return cell
        }
        else
        {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var flickrUser: FlickrUser!
        
        if inSearchMode
        {
            flickrUser = flickrUserFilterdArray[indexPath.row]
        }
        else
        {
            flickrUser = flickrUserArray[indexPath.row]
        }
        
        performSegue(withIdentifier: "UserPhotosVC" , sender: flickrUser)
    }
   
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: - search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""
        {
            inSearchMode = false
            tableView.reloadData()
        }
        else
        {
            //Filters array based on Title
            inSearchMode = true
            flickrUserFilterdArray = flickrUserArray.filter({$0.imageTitle.range(of:searchBar.text!) != nil})
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }

    //MARK: - segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? UserPhotosVC
        {
            if let user = sender as? FlickrUser
            {
                destination.currentUser = user
            }
        }
    }


}

