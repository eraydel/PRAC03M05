//
//  AddDrinkViewController.swift
//  erickayalapractica3
//
//  Created by Erick Ayala Delgadillo on 06/04/22.
//

import UIKit

class AddDrinkViewController: UIViewController {
   
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var ingredients: UITextView!
    @IBOutlet weak var directions: UITextView!
    @IBOutlet weak var image: UIImageView!

    
    var datos = Drink()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func save(_ sender: Any) {
        
        var mensaje = ""
        
        if name.text != "" && ingredients.text != "" && directions.text != "" {
            
            var tmp = [String:String]()
            
            tmp["name"] = name.text
            tmp["ingredients"] = ingredients.text
            tmp["directions"] = directions.text
            tmp["image"] = "drink.jpg"
            let appDel = UIApplication.shared.delegate as! AppDelegate
            appDel.addDrink(tmp)
            self.dismiss(animated: true, completion: nil)
        }
        else {
            mensaje = "Please, you must capture all fields"
            let alert = UIAlertController(title: "Error",  message: mensaje, preferredStyle: .alert)
            let action = UIAlertAction(title: "Continue", style: .default)
            alert.addAction(action)
            self.present(alert,animated: true, completion: nil )
        }
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
