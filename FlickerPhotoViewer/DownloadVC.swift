//
//  DownloadVC.swift
//  FlickerPhotoViewer
//
//  Created by Bassyouni on 7/25/17.
//  Copyright © 2017 Bassyouni. All rights reserved.
//

import UIKit
import CoreData

class DownloadVC: UIViewController , UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate{

    //MARK: - iboutles and varibales
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - variables
    var controller : NSFetchedResultsController<Download>!
    weak var parentVC: SideViewController?
    
    //MARK: - view DidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navbarMenuBtnInit()
        tableView.delegate = self
        tableView.dataSource = self
        attemptFetch()
        
        // create dummy navbar
        if parentVC != nil
        {
            let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 65))
            self.view.addSubview(navBar);
            let navItem = UINavigationItem(title: "Pick From Downloads");
            let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: #selector(DownloadVC.dismissVC));
            navItem.leftBarButtonItem = doneItem;
            navBar.setItems([navItem], animated: false);
        }
        
    }

    //MARK: - navBAr
    func navbarMenuBtnInit()
    {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "sideMenuBtn"), for: UIControlState.normal)
        button.addTarget(self, action:#selector(MainVC.toggleSideMenu), for: UIControlEvents.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        
    }
    
    func toggleSideMenu() {
        self.menuContainerViewController.toggleLeftSideMenuCompletion({})
    }
    
    //MARK: - table
    func numberOfSections(in tableView: UITableView) -> Int {
        /*if let sections = controller.sections
         {
         return sections.count
         }*/
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let sections = controller.sections
        {
            let sectionsInfo = sections[section]
            return sectionsInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadCell", for: indexPath) as! DownloadCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 300.0
    }
    
    func configureCell(cell : DownloadCell , indexPath :NSIndexPath)
    {
        let downloadImage  = controller.object(at:indexPath as IndexPath)
        cell.configureCell(downloadedImage: downloadImage)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let downloadImage  = controller.object(at:indexPath as IndexPath)
        
        if parentVC != nil
        {
            parentVC?.imgProfile.image = downloadImage.image as? UIImage
            self.dismiss(animated: true, completion:nil)
        }
        else
        {
            performSegue(withIdentifier: "FullImageVC2" , sender: downloadImage)
        }
        
        
    }
    
    //MARK: - coreData
    func attemptFetch()
    {
        // get all Photos based on the logged in user
        let fetchRequest :NSFetchRequest<Download> = Download.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "toUser.id == %@", CurrentUser.id!)
        
        let datasort = NSSortDescriptor(key: "id", ascending: true)
        
        fetchRequest.sortDescriptors = [datasort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        self.controller = controller
        
        do{
            try controller.performFetch()
        }
        catch{
            let error = error as NSError
            print(error.debugDescription)
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath
            {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        case .delete:
            if let indexPath = indexPath
            {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
            
        case.update:
            if let indexPath = indexPath
            {
                let cell = tableView.cellForRow(at: indexPath) as! DownloadCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
            
        case .move:
            if let indexPath = indexPath
            {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath
            {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        }
    }
    
    //MARK: - segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FullImageVC
        {
            if let image = sender as? Download
            {
                let imageOfFlickrUser = ImageOfFlickrUser(image: (image.image as? UIImage)!, title: image.title!)
                destination.currentImage = imageOfFlickrUser
            }
        }
    }
    
    func dismissVC()
    {
        self.dismiss(animated: true, completion: nil)
    }
    

}
