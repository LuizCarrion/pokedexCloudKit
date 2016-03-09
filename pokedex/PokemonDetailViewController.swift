//
//  PokemonViewController.swift
//  TrabalhoPokemon
//
//  Created by Luiz Carrion on 2/29/16.
//  Copyright © 2016 LuizCarrion. All rights reserved.
//

import UIKit

class PokemonDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "AbilityCell", bundle: nil)
        abilitiesTableView.registerNib(nib, forCellReuseIdentifier: "abilityCell")
        
        self.activityMonitor.startAnimating()
        self.activityMonitor.hidden = false
        self.activityMonitor.hidesWhenStopped = true
        
        nameLabel.text = pokemon.name
        levelLabel.text = "Lvl: \(pokemon.level)"
        typesLabel.text = "\(pokemon.type.type1)     \(pokemon.type.type2!)"
        healthLabel.text = "\(pokemon.status.health)"
        attackLabel.text = "\(pokemon.status.attack)"
        defenseLabel.text = "\(pokemon.status.defense)"
        spAtkLabel.text = "\(pokemon.status.spAttack)"
        spDefLabel.text = "\(pokemon.status.spDefense)"
        speedLabel.text = "\(pokemon.status.speed)"
        numberLabel.text = "# \(pokemon.number)"
        
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:AbilityTableViewCell = abilitiesTableView.dequeueReusableCellWithIdentifier("abilityCell") as! AbilityTableViewCell
        
        let skill = pokemon.skills[indexPath.row]
        cell.nameLabel.text  = skill.name
        cell.typeLabel.text = skill.type
        cell.ppLabel.text = "PP: \(skill.powerPoint)/\(skill.powerPoint)"
        cell.powerLabel.text = "Power: \(skill.power)"
        cell.damageCategoryLabel.text = skill.damageCategory
        cell.accuracyLabel.text = "\(skill.accuracy)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return pokemon.skills.count
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
