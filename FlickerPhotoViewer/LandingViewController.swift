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
    @IBOutlet weak var linkedInBtn: UIButton!
    //MARK: - view DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // un comment this if you want to delete all data
        
//        AccessToken.current = nil
//        UserDefaults.standard.removeObject(forKey: "LIAccessToken")
//        do{
//            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
//            let request = NSBatchDeleteRequest(fetchRequest: fetch)
//            _ = try context.execute(request)
//            
//        }catch
//        {
//            print("something went wrong")
//        }
        
        self.facebookLoginBtn.addTarget(self, action: #selector(self.loginButtonClicked), for: UIControlEvents.touchUpInside)
        
        //this is for when we come back form linked in login to call linked in call back!
        NotificationCenter.default.addObserver(self, selector: #selector(LandingViewController.linkedInCallBack), name:NSNotification.Name(rawValue: "NotificationID"), object: nil)
        
        // Auto Login for both facebook and linkedIn
        if let accsesToken = AccessToken.current
        {
            self.performFetch(userID: accsesToken.userId!, userName: nil, userImageUrl: nil , socialMediaType: facebook)
            self.makeSegueToMainVC()
        }
        
        
        if UserDefaults.standard.object(forKey: "LIAccessToken") != nil
        {
            self.performFetch(userID: UserDefaults.standard.object(forKey: "userId") as! String, userName: nil, userImageUrl: nil, socialMediaType: linkedIn)
            self.makeSegueToMainVC()
        }
       
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
                self.hideLoading()
            case .cancelled:
                print("User cancelled login.")
                self.hideLoading()
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
                        self.performFetch(userID: userID, userName: userName, userImageUrl: userImageUrl,socialMediaType: facebook)
                        
                        //Go to the mainView having with it a sideMenu
                        self.makeSegueToMainVC()
                        
                    case .failed(let error):
                        print("Graph Request Failed: \(error)")
                    }
                }
                connection.start()
            }
        }
    }
    
    
        // Gets Data and save it to core data and goes to mainVC
        func linkedInCallBack() {
        if let accessToken = UserDefaults.standard.object(forKey: "LIAccessToken") {
            
            // Specify the URL string that we'll get the profile info from.
            let targetURLString = "https://api.linkedin.com/v1/people/~:(id,public-profile-url,formatted-name,picture-url)?format=json"
            
            // Initialize a mutable URL request object.
            let request = NSMutableURLRequest(url: NSURL(string: targetURLString)! as URL)
            
            // Indicate that this is a GET request.
            request.httpMethod = "GET"
            
            // Add the access token as an HTTP header field.
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            
            
            
            // Initialize a NSURLSession object.
            let session = URLSession(configuration: URLSessionConfiguration.default)
            
            // Make the request.
            let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                // Get the HTTP status code of the request.
                let statusCode = (response as! HTTPURLResponse).statusCode
                
                if statusCode == 200 {
                    // Convert the received JSON data into a dictionary.
                    do {
                        let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,AnyObject>
                        
                       // let profileURLString = dataDictionary["publicProfileUrl"] as! String
                        self.showLoading()
                        let userName = dataDictionary["formattedName"]! as! String
                        let userId = dataDictionary["id"]! as! String
                        let userImageUrl:String?
                        if dataDictionary["pictureUrl"] != nil
                        {
                            userImageUrl = dataDictionary["pictureUrl"]! as? String
                        }
                        else
                        {
                            userImageUrl = nil
                        }
                        
                
                        self.performFetch(userID:userId , userName: userName, userImageUrl: userImageUrl, socialMediaType: linkedIn)
                        self.makeSegueToMainVC()
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.makeSegueToMainVC()
                        })
                    }
                    catch {
                        print("Could not convert JSON data into a dictionary.")
                    }
                }
            }
            
            task.resume()
        }
    }
    /// Saves the user if its the first time for the user or loads him from core data if its not first time . Handles extreme casses
    ///
    /// - Parameters:
    ///   - userID: ID from facebook
    ///   - userName: user name
    ///   - userImageUrl: url for user's photo
    func performFetch(userID: String ,userName: String? ,userImageUrl: String? , socialMediaType: String )
    {
        let request: NSFetchRequest<User> = User.fetchRequest()
        
        // Filtring condition
        request.predicate = NSPredicate(format: "id = %@ AND socialMediaType = %@", argumentArray:[userID , socialMediaType])
        
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
                tempUser.socialMediaType = socialMediaType
                if socialMediaType == linkedIn
                {
                    UserDefaults.standard.set(userID, forKey: "userId")
                }
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
                CurrentUser = User()
                CurrentUser = result[0]
            }
        }
        catch
        {
            print("problem with store fetching")
        }
        
    }
    
    func makeSegueToMainVC()
    {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let homeNav = self.storyboard?.instantiateViewController(withIdentifier: "MainVC")
        let sideVc = self.storyboard?.instantiateViewController(withIdentifier: "SideViewController")
        
        let containerVC = MFSideMenuContainerViewController.container(withCenter: homeNav, leftMenuViewController: sideVc, rightMenuViewController: nil)
        delegate?.window?.rootViewController = containerVC
    }
    

}
