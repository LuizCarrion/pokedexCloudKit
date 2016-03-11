//
//  ViewController.swift
//  pokedex
//
//  Created by Luiz Carrion on 3/7/16.
//  Copyright © 2016 LuizCarrion. All rights reserved.
//

import UIKit
import CloudKit

class PokedexViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AsyncUpdateProtocol {

    @IBOutlet weak var pokemonTableView: UITableView!
    
    var selectedPokemon: CKRecord!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "PokeCell", bundle: nil)
        pokemonTableView.registerNib(nib, forCellReuseIdentifier: "PokeCell")
        
        CloudManager.sharedInstance().asyncUpdate = self
        

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if CloudManager.sharedInstance().pokemonListCount() == 0 {
            view.lock()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:PokeTableViewCell = tableView.dequeueReusableCellWithIdentifier("PokeCell") as! PokeTableViewCell
        let pokemon = CloudManager.sharedInstance().pokemonAtIndex(indexPath.row)
        let type = pokemon["Type"] as! [String]
        cell.pokeLevelLabel.text = "Lvl: \(pokemon["Level"] as! Int)"
        cell.pokeNameLabel.text = pokemon["Name"] as? String
        cell.pokeTypeLabel.text = "\(type[0])    \(type[1])"
        cell.activityIndicator.startAnimating()
        cell.activityIndicator.hidden = false
        cell.activityIndicator.hidesWhenStopped = true
        
        
        var bool = true
        for obj in CloudManager.sharedInstance().favorites {
            if ((obj["Pokemon"] as! String) == (pokemon["Name"] as! String)){
                bool = false
            }
        }
        
        cell.favoriteIcon.hidden = bool
        
        if let data = NSData(contentsOfURL: (pokemon["Icon"] as! CKAsset).fileURL){
            cell.pokeIcon.image = UIImage(data: data)
            cell.activityIndicator.stopAnimating()
        }
        
       
        return cell
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedPokemon = CloudManager.sharedInstance().pokemonAtIndex(indexPath.row)
        self.performSegueWithIdentifier("pokemonSegue", sender: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CloudManager.sharedInstance().pokemonListCount()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pokemonSegue"{
            let vc: PokemonDetailViewController = segue.destinationViewController as! PokemonDetailViewController
            
            vc.pokemon = self.selectedPokemon
        }
    }
    
    func asyncUpdate() {
        view.unlock()
        //print(CloudManager.sharedInstance().pokemonAtIndex(0)["Skills"])
        pokemonTableView.reloadData()
    }
    



}

