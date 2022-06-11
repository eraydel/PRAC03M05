//
//  TableViewController.swift
//  erickayalapractica3
//
//  Created by Erick Ayala Delgadillo on 26/03/22.
//

import UIKit
import FirebaseAuth

class TableViewController: UITableViewController {
    
    var datos = [Drink]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDel = UIApplication.shared.delegate as! AppDelegate
        datos = appDel.getAllDrinks()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
     
    @IBAction func updateTable(_ sender: Any) {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        datos = appDel.getAllDrinks()
        self.tableView.reloadData()
    }
   

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //get the name attribute
        let drink = datos[indexPath.row]
        let imageDrink = (drink.image) ?? ""
        let image =  UIImage(named: imageDrink.lowercased()) ?? UIImage()
        let cell = tableView.dequeueReusableCell(withIdentifier: "myTableView", for: indexPath) 
        cell.textLabel?.text = drink.name
        cell.detailTextLabel?.text = drink.ingredients
        cell.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
        cell.imageView?.frame.size.width = 60
        cell.imageView?.frame.size.height = 60
        cell.imageView?.layer.cornerRadius = 30
        cell.imageView?.clipsToBounds = true
        cell.imageView?.image = image.resizeImageWithHeight(newW: 60, newH: 60)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        refreshControl?.endRefreshing()
        return datos.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "details", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
            case "details":
                let detailsVC = segue.destination as! ViewController
                if let indexPath = tableView.indexPathForSelectedRow {
                    let theDrink = datos[indexPath.row]
                    detailsVC.drink = theDrink //agregar como miembro de la clase VC a drinkName
                    tableView.deselectRow(at: indexPath, animated: true)
                }

            case "addDrink":
                print("create new drink")

            default:
                print("reloading data...")//self.tableView.reloadData()
        }
        
    }
    

    @IBAction func btnLogout(_ sender: Any) {
    
        print("cerrando sesión...")
        do {
            try Auth.auth().signOut()
            //Obtenemos una referencia al SceneDelegate:
            //Podría haber mas de una escena en IpAd OS o en MacOS
            let escena = UIApplication.shared.connectedScenes.first
            print("sesión cerrada")
            let sd = escena?.delegate as! SceneDelegate
            sd.cambiarVistaA("")
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIImage{
    func resizeImageWithHeight(newW: CGFloat, newH: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: newW, height: newH))
        self.draw(in: CGRect(x: 0, y: 0, width: newW, height: newH))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
