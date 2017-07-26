//
//  LikesVC.swift
//  FlickerPhotoViewer
//
//  Created by Bassyouni on 7/25/17.
//  Copyright © 2017 Bassyouni. All rights reserved.
//

import UIKit
import CoreData

class LikesVC: UIViewController, UITableViewDelegate, UITableViewDataSource,NSFetchedResultsControllerDelegate {
    
    //MARK: - iboutles and varibales
    var controller : NSFetchedResultsController<Likes>?
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - view DidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navbarMenuBtnInit()
        tableView.delegate = self
        tableView.dataSource = self
        attemptFetch()
        tableView.reloadData()
    }
    
    //MARK: - navBar
    // creates the navbar and style it
    func navbarMenuBtnInit()
    {
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 75))
        self.view.addSubview(navBar);
        let navItem = UINavigationItem(title: "Likes");
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "sideMenuBtn"), for: UIControlState.normal)
        button.addTarget(self, action:#selector(LikesVC.toggleSideMenu), for: UIControlEvents.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        navItem.leftBarButtonItem = barButton
        navBar.setItems([navItem], animated: false);

    }
    
    // opens and closes side menu
    func toggleSideMenu() {
        self.menuContainerViewController.toggleLeftSideMenuCompletion({})
    }
    
    
    //MARK: - table
    func numberOfSections(in tableView: UITableView) -> Int
    {
        /*if let sections = controller.sections
         {
         return sections.count
         }*/
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let sections = controller!.sections
        {
            let sectionsInfo = sections[section]
            return sectionsInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikesCell", for: indexPath) as! LikesCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 150.0
    }
    
    func configureCell(cell : LikesCell , indexPath :NSIndexPath)
    {
        let like  = controller?.object(at:indexPath as IndexPath)
        cell.configureCell(likedPhoto: like!)
    }
    
    //MARK: - coreData
    func attemptFetch()
    {
        if controller != nil
        {
            return
        }
        // get all Photos based on the logged in user
        let fetchRequest :NSFetchRequest<Likes> = Likes.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "toUser.id == %@", CurrentUser.id!)
        
        let datasort = NSSortDescriptor(key: "title", ascending: true)
        
        fetchRequest.sortDescriptors = [datasort]
        
         controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller?.delegate = self
//        self.controller = controller
        
        do{
            try controller?.performFetch()
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
                let cell = tableView.cellForRow(at: indexPath) as! LikesCell
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




}
