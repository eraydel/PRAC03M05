//
//  ViewController.swift
//  erickayalapractica3
//
//  Created by Erick Ayala Delgadillo on 26/03/22.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var drinkName: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var ingredientes: UITextView!
    @IBOutlet weak var directions: UITextView!
    
    var drink = Drink()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        drinkName.font = UIFont(name: "DelagothicOne-Regular", size: 15)
        drinkName.text  = drink.name
        
        let imageDrink = drink.image ?? ""
        let image =  UIImage(named: imageDrink.lowercased()) ?? UIImage()
        
        imageview.contentMode = UIView.ContentMode.scaleAspectFill
        imageview.frame.size.width = 200
        imageview.frame.size.height = 200
        imageview.layer.cornerRadius = 100
        imageview.clipsToBounds = true
        imageview.image = image
        
        ingredientes.text = drink.ingredients
        directions.text = drink.directions
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

