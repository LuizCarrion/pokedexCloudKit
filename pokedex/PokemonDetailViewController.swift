//
//  PokemonViewController.swift
//  TrabalhoPokemon
//
//  Created by Luiz Carrion on 2/29/16.
//  Copyright © 2016 LuizCarrion. All rights reserved.
//

import UIKit
import CloudKit

class PokemonDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AsyncUpdateProtocol {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var typesLabel: UILabel!
    @IBOutlet weak var healthLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var spAtkLabel: UILabel!
    @IBOutlet weak var spDefLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var abilitiesTableView: UITableView!
    @IBOutlet weak var activityMonitor: UIActivityIndicatorView!
    @IBOutlet weak var favoriteIcon: UIImageView!
    var hideFavorite: Bool!
    
    var pokemon: CKRecord!
    var skills: [CKReference]!
    let publicDb = CKContainer.defaultContainer().publicCloudDatabase
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.abilitiesTableView.addSubview(refreshControl)
        
        
        let aSelector: Selector = "favoriteTapped:"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorite", style: .Plain, target: self, action: aSelector)
        
        
        let nib = UINib(nibName: "AbilityCell", bundle: nil)
        abilitiesTableView.registerNib(nib, forCellReuseIdentifier: "abilityCell")
        
        self.activityMonitor.startAnimating()
        self.activityMonitor.hidden = false
        self.activityMonitor.hidesWhenStopped = true
        favoriteIcon.hidden = hideFavorite

        
        let type = pokemon["Type"] as! [String]
        
        nameLabel.text = pokemon["Name"] as? String
        levelLabel.text = "Lvl: \(pokemon["Level"] as! Int)"
        typesLabel.text = "\(type[0])    \(type[1])"
        numberLabel.text = "# \(pokemon["Number"] as! Int)"
        self.healthLabel.hidden = true
        self.attackLabel.hidden = true
        self.defenseLabel.hidden = true
        self.spAtkLabel.hidden = true
        self.spDefLabel.hidden = true
        self.speedLabel.hidden = true
        
        
        skills = pokemon["Skills"] as! [CKReference]
        
        
        publicDb.fetchRecordWithID( (pokemon["Status"] as! CKReference).recordID) { (results, error) -> Void in
            
            if let stats = results{
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.healthLabel.text = "\(stats["Health"] as! Int)"
                    self.attackLabel.text = "\(stats["Attack"] as! Int)"
                    self.defenseLabel.text = "\(stats["Defense"] as! Int)"
                    self.spAtkLabel.text = "\(stats["SpAttack"] as! Int)"
                    self.spDefLabel.text = "\(stats["SpDefense"] as! Int)"
                    self.speedLabel.text = "\(stats["Speed"] as! Int)"
                    
                    self.healthLabel.hidden = false
                    self.attackLabel.hidden = false
                    self.defenseLabel.hidden = false
                    self.spAtkLabel.hidden = false
                    self.spDefLabel.hidden = false
                    self.speedLabel.hidden = false
                })

            }
        }
        
        if let data = NSData(contentsOfURL: (pokemon["Image"] as! CKAsset).fileURL){
            pokemonImageView.image = UIImage(data: data)
            activityMonitor.stopAnimating()
        }
        
        
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:AbilityTableViewCell = abilitiesTableView.dequeueReusableCellWithIdentifier("abilityCell") as! AbilityTableViewCell
//        
//        cell.nameLabel.hidden = true
//        cell.typeLabel.hidden = true
//        cell.ppLabel.hidden = true
//        cell.powerLabel.hidden = true
//        cell.damageCategoryLabel.hidden = true
//        cell.accuracyLabel.hidden = true
        
        
        publicDb.fetchRecordWithID( (skills[indexPath.row]).recordID) { (results, error) -> Void in
            
            if let skill = results{
                
                dispatch_async(dispatch_get_main_queue(), {
                    cell.accuracyLabel.text = "\(skill["Accuracy"] as! Int)"
                    cell.nameLabel.text  = skill["Name"] as? String
                    cell.typeLabel.text = skill["Type"] as? String
                    cell.ppLabel.text = "PP: \(skill["PowerPoint"] as! Int)/\(skill["PowerPoint"] as! Int)"
                    cell.powerLabel.text = "Power: \(skill["Power"] as! Int)"
                    cell.damageCategoryLabel.text = skill["DamageCategory"] as? String
                })
            }
        }

        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return skills.count
    }
    
    func favoriteTapped(sender: UIButton){
        CloudManager.sharedInstance().saveFavorite(pokemon["Name"] as! String)
        if(favoriteIcon.hidden){
            favoriteIcon.hidden = false
        }else {
            favoriteIcon.hidden = true
        }
    }
    
    
    func asyncUpdate() {
        self.reloadInputViews()
    }
    
    
    func handleRefresh(refreshControl: UIRefreshControl) {
       abilitiesTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
}
