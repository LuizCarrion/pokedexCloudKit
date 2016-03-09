//
//  ViewController.swift
//  pokedex
//
//  Created by Luiz Carrion on 3/7/16.
//  Copyright © 2016 LuizCarrion. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var pokemonTableView: UITableView!
    
    var arrayPokemon = Array<Pokemon>()
    var selectedPokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "PokeCell", bundle: nil)
        pokemonTableView.registerNib(nib, forCellReuseIdentifier: "PokeCell")
        
        let cloud = CloudManager()
        
        
        arrayPokemon = cloud.loadFromJSON()
        cloud.checkDatabase()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:PokeTableViewCell = tableView.dequeueReusableCellWithIdentifier("PokeCell") as! PokeTableViewCell
        let pokemon = arrayPokemon[indexPath.row]
        
        cell.pokeLevelLabel.text = "Lvl: \(pokemon.level)"
        cell.pokeNameLabel.text = pokemon.name
        cell.pokeTypeLabel.text = "\(pokemon.type.type1)      \(pokemon.type.type2!)"
        cell.activityIndicator.startAnimating()
        cell.activityIndicator.hidden = false
        cell.activityIndicator.hidesWhenStopped = true
        
        
        return cell
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedPokemon = arrayPokemon[indexPath.row]
        self.performSegueWithIdentifier("pokemonSegue", sender: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayPokemon.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pokemonSegue"{
            let vc: PokemonDetailViewController = segue.destinationViewController as! PokemonDetailViewController
            
            vc.pokemon = self.selectedPokemon
        }
    }
    



}

