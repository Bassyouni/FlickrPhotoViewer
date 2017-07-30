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
import FacebookCore

class SideViewController: UIViewController , UITableViewDelegate , UITableViewDataSource,UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    //MARK: - iboutlets
    @IBOutlet var tableMenu : UITableView!
    @IBOutlet var lblWelcome : UILabel!
    @IBOutlet var lblName : UILabel!
    @IBOutlet var imgProfile : UIImageView!
    @IBOutlet weak var changePhotoMenu: UIView!
    
    
    //MARK: - variables
    var arrMenuTxt : [String] = ["Latest","Favourites" , "Downloaded"]
    var indexSelected : Int? = 0
    var imagePicker: UIImagePickerController!
    
    //MARK: - view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //image picker init
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        // set name
        self.lblWelcome.text = NSLocalizedString("Welcome", comment: "")
        self.lblName.text = CurrentUser.name!
       
        if CurrentUser.imageURL == "" || CurrentUser.imageURL == nil
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
        AccessToken.current = nil
        UserDefaults.standard.removeObject(forKey: "LIAccessToken")
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let LandingVC = self.storyboard?.instantiateViewController(withIdentifier: "LandingVC")
        delegate?.window?.rootViewController = LandingVC
    }

    @IBAction func profileImagePressed(_ sender: Any) {
        UIView.animate(withDuration: 0.5 , animations:{
        self.changePhotoMenu.isHidden = !self.changePhotoMenu.isHidden
        })
    }

    @IBAction func photoFromGallaryPressed(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        self.changePhotoMenu.isHidden = true
        
    }
    
    @IBAction func photoFromDownloadsPressed(_ sender: Any) {
        performSegue(withIdentifier: "DownloadsVC", sender: nil)
        self.changePhotoMenu.isHidden = true
    }

    @IBAction func photoFromCameraPressed(_ sender: Any) {
        self.changePhotoMenu.isHidden = true
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - image picking func's
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            imgProfile.image = image
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    /*
     //MARK: - Saving Image here
     @IBAction func save(_ sender: AnyObject) {
     UIImageWriteToSavedPhotosAlbum(imageTake.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
     }
     
     //MARK: - Add image to Library
     func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
     if let error = error {
     // we got back an error!
     let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
     ac.addAction(UIAlertAction(title: "OK", style: .default))
     present(ac, animated: true)
     } else {
     let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
     ac.addAction(UIAlertAction(title: "OK", style: .default))
     present(ac, animated: true)
     }
     }
     
     //MARK: - Done image capture here
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
     imagePicker.dismiss(animated: true, completion: nil)
     imageTake.image = info[UIImagePickerControllerOriginalImage] as? UIImage
     }
     */
    
    //MARK: - segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DownloadVC
        {
            destination.parentVC = self
        }
    }
}
