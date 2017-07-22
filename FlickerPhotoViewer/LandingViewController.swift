//
//  LandingViewController.swift
//  FlickerPhotoViewer
//
//  Created by Bassyouni on 7/20/17.
//  Copyright © 2017 Bassyouni. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {

    @IBOutlet weak var facebookLoginBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func facebookLoginBtnPressed(_ sender: Any) {
       // self.performSegue(withIdentifier: "", sender: "")
        
        // set homeNav and side menu as root to window
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let homeNav = self.storyboard?.instantiateViewController(withIdentifier: "MainVC")
        let sideVc = self.storyboard?.instantiateViewController(withIdentifier: "SideViewController")
        
        let containerVC = MFSideMenuContainerViewController.container(withCenter: homeNav, leftMenuViewController: sideVc, rightMenuViewController: nil)
        delegate?.window?.rootViewController = containerVC
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
