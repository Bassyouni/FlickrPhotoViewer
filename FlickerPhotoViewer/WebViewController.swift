//
//  WebViewController.swift
//  LISignIn
//
//  Created by Gabriel Theodoropoulos on 21/12/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    // MARK: IBOutlet Properties
    
    @IBOutlet weak var webView: UIWebView!
    
    
    // MARK: Constants
    
    let linkedInKey = "781y6brflu0iad"
    
    let linkedInSecret = "ZIB2BPs4J68F9qyV"
    
    let authorizationEndPoint = "https://www.linkedin.com/uas/oauth2/authorization"
    
    let accessTokenEndPoint = "https://www.linkedin.com/uas/oauth2/accessToken"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        webView.delegate = self
        
        startAuthorization()
    }


    func startAuthorization() {
        // Specify the response type which should always be "code".
        let responseType = "code"
        
        // Set the redirect URL. Adding the percent escape characthers is necessary.
        let redirectURL = "https://com.appcoda.linkedin.oauth/oauth".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.alphanumerics)!
        
        // Create a random string based on the time interval (it will be in the form linkedin12345679).
        let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"
        
        // Set preferred scope.
        let scope = "r_basicprofile"
        // Create the authorization URL string.
        var authorizationURL = "\(authorizationEndPoint)?"
        authorizationURL += "response_type=\(responseType)&"
        authorizationURL += "client_id=\(linkedInKey)&"
        authorizationURL += "redirect_uri=\(redirectURL)&"
        authorizationURL += "state=\(state)&"
        authorizationURL += "scope=\(scope)"
        
        print(authorizationURL)
        
        // Create a URL request and load it in the web view.
        let request = URLRequest(url: URL(string: authorizationURL)!)
        //NSURLRequest(URL: URL(string: authorizationURL)!)
        webView.loadRequest(request)
        
        
    }
    
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.url!
        print(url)
        
        if url.host == "com.appcoda.linkedin.oauth" {
            if url.absoluteString.range(of: "code") != nil {
                // Extract the authorization code.
                let urlParts = url.absoluteString.components(separatedBy: "?")
                let code = urlParts[1].components(separatedBy: "=")
                print(code[1])
                requestForAccessToken(authorizationCode: code[1])
            }
        }
        
        return true
    }
    
    func requestForAccessToken(authorizationCode: String) {
        let grantType = "authorization_code"
        
        let redirectURL = "https://com.appcoda.linkedin.oauth/oauth".addingPercentEncoding(withAllowedCharacters:CharacterSet.alphanumerics)!
        
        // Set the POST parameters.
        var postParams = "grant_type=\(grantType)&"
        postParams += "code=\(authorizationCode)&"
        postParams += "redirect_uri=\(redirectURL)&"
        postParams += "client_id=\(linkedInKey)&"
        postParams += "client_secret=\(linkedInSecret)"
        // Convert the POST parameters into a NSData object.
        let postData = postParams.data(using: String.Encoding.utf8)
        
        // Initialize a mutable URL request object using the access token endpoint URL string.
        let request = NSMutableURLRequest(url: NSURL(string: accessTokenEndPoint)! as URL)
        
        // Indicate that we're about to make a POST request.
        request.httpMethod = "POST"
        
        // Set the HTTP body using the postData object created above.
        request.httpBody = postData
        
        // Add the required HTTP header field.
        request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
        
        // Initialize a NSURLSession object.
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        // Make the request.
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            
            let statusCode = (response as! HTTPURLResponse).statusCode
            
            if statusCode == 200 {
                // Convert the received JSON data into a dictionary.
                do {
                    let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? Dictionary<String ,AnyObject>
                    
                    let accessToken = dataDictionary?["access_token"] as! String

                    
                    UserDefaults.standard.set(accessToken, forKey: "LIAccessToken")
                    UserDefaults.standard.synchronize()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationID"), object: nil)
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.dismiss(animated: true, completion: nil)
                    })                 }
                catch {
                    print("Could not convert JSON data into a dictionary.")
                }
            }
        }
        
        task.resume()
        
        
    }
    


    
    // MARK: IBAction Function
    
    
    @IBAction func dismiss(_ sender: AnyObject) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationID"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
}
