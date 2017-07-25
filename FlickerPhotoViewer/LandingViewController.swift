//
//  LandingViewController.swift
//  FlickerPhotoViewer
//
//  Created by Bassyouni on 7/20/17.
//  Copyright © 2017 Bassyouni. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import CoreData


class LandingViewController: ParentViewController {
    
    //MARK: - iboutlets
    @IBOutlet weak var facebookLoginBtn: UIButton!
    
    //MARK: - view DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.facebookLoginBtn.addTarget(self, action: #selector(self.loginButtonClicked), for: UIControlEvents.touchUpInside)
        
        // un comment this if you want to delete all data
        /*
        do{
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            let request = NSBatchDeleteRequest(fetchRequest: fetch)
            _ = try context.execute(request)
        }catch
        {
            print("something went wrong")
        }
        */
       
    }
    
    //MARK: - LoginFucntions
    /// Calls login facebook api to handle all the login and returns users data as specfied and then parse it and send it the performFetch() to handle the saving!
    @objc func loginButtonClicked() {
        showLoading()
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success( _, _, _):
               // self.showLoading()
                print("Logged in!")
                
                let connection = GraphRequestConnection()
                connection.add(GraphRequest(graphPath: "/me" , parameters: ["fields": "name,email,first_name,last_name,picture.type(small),gender"])) { httpResponse, result in
                    switch result {
                    case .success(let response):
                        var userImageUrl: String!
                        let dic = response.dictionaryValue!
                        if let pictureDic = dic["picture"] as? Dictionary<String ,AnyObject>
                        {
                            if let dataDic = pictureDic["data"] as? Dictionary<String ,AnyObject>
                            {
                                userImageUrl = dataDic["url"]! as! String
                            }
                        }

                        let userID = dic["id"]! as! String
                        _ = dic["last_name"]! as! String
                        let userName = dic["name"]! as! String
                        
                        //Handling saving and load data
                        self.performFetch(userID: userID, userName: userName, userImageUrl: userImageUrl)
                        
                        //Go to the mainView having with it a sideMenu
                        let delegate = UIApplication.shared.delegate as? AppDelegate
                        let homeNav = self.storyboard?.instantiateViewController(withIdentifier: "MainVC")
                        let sideVc = self.storyboard?.instantiateViewController(withIdentifier: "SideViewController")
                        
                        let containerVC = MFSideMenuContainerViewController.container(withCenter: homeNav, leftMenuViewController: sideVc, rightMenuViewController: nil)
                            delegate?.window?.rootViewController = containerVC
                        
                    case .failed(let error):
                        print("Graph Request Failed: \(error)")
                    }
                }
                connection.start()
            }
        }
    }
    
    /// Saves the user if its the first time for the user or loads him from core data if its not first time . Handles extreme casses
    ///
    /// - Parameters:
    ///   - userID: ID from facebook
    ///   - userName: user name
    ///   - userImageUrl: url for user's photo
    func performFetch(userID: String ,userName: String ,userImageUrl: String )
    {
        let request: NSFetchRequest<User> = User.fetchRequest()
        
        // Filtring condition
        request.predicate = NSPredicate(format:"id == %@",userID)
        do{
            /// populate your variable
            var result = try context.fetch(request)
            
            // case of the first time to login in
            if result.count == 0
            {
                let tempUser = User(context: context)
                tempUser.id = userID
                tempUser.name = userName
                tempUser.imageURL = userImageUrl
                CurrentUser = tempUser
                ad.saveContext()
            }
            // case of having a duplicate , probably wont happen
            else if result.count > 1
            {
                print(result)
                print("more than one user")
            }
            // case of the user already been on our app and saved to core data
            else
            {
                CurrentUser = result[0]
            }
        }
        catch
        {
            print("problem with store fetching")
        }
        
    }
    

}
