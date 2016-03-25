//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by Blas Fernandez Segura on 25/3/16.
//  Copyright © 2016 Baenne. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {

    @IBOutlet var backgroundImageView:UIImageView!
    var restaurantImage = ""
    @IBOutlet var ratingStackView:UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Con esto conseguimos un efecto difuminado en la imagen del fondo
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.image = UIImage(named: restaurantImage)  // Ponemos la imagen del local como imagen de fondo
        backgroundImageView.addSubview(blurEffectView)
        
        // Iniciamos la animación de los iconos de valoración
        ratingStackView.transform = CGAffineTransformMakeScale(0, 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateKeyframesWithDuration(0.4, delay: 0.0, options: [], animations: {
            
            self.ratingStackView.transform = CGAffineTransformIdentity
            
            }, completion: nil)
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
