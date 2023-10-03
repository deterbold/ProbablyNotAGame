//
//  AboutScreen.swift
//  ProbablyNotAGame
//
//  Created by Miguel Sicart on 20/12/2022.
//

import UIKit

class AboutScreen: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var aboutLabel: UILabel!
    
    @IBOutlet weak var backgroundView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        aboutLabel.numberOfLines = 0
        aboutLabel.textAlignment = .center
        aboutLabel.text = "Probably Not is a game about playing with Artificial Intelligence\n \n The game will ask you to find something \n \n Take a picture of something that is not, but could be, what the computer asks for"
        // Do any additional setup after loading the view.
        
        let gradient = CAGradientLayer()

        gradient.frame = backgroundView.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.black.cgColor]

        backgroundView.layer.insertSublayer(gradient, at: 0)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
