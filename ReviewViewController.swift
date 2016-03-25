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
    
    var rating:String?
    
    @IBOutlet var dislikeButton:UIButton!
    @IBOutlet var goodButton:UIButton!
    @IBOutlet var greatButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Con esto conseguimos un efecto difuminado en la imagen del fondo
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.image = UIImage(named: restaurantImage)  // Ponemos la imagen del local como imagen de fondo
        backgroundImageView.addSubview(blurEffectView)
        
        // Iniciamos la animación de los iconos de valoración
//        ratingStackView.transform = CGAffineTransformMakeScale(0, 0)
        
        // Esta linea genera una animación de traslación más que de escala.
//        ratingStackView.transform = CGAffineTransformMakeTranslation(0, 500)
        
        // Con estas lineas combinamos ambos efectos
//        let scale = CGAffineTransformMakeScale(0, 0)
//        let translate = CGAffineTransformMakeTranslation(0, 500)
//        ratingStackView.transform = CGAffineTransformConcat(scale, translate)

        let translate = CGAffineTransformMakeTranslation(0, 500)
        dislikeButton.transform = translate
        goodButton.transform = translate
        greatButton.transform = translate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Animación de transformación normal
//        UIView.animateKeyframesWithDuration(0.4, delay: 0.0, options: [], animations: {
//            
//            self.ratingStackView.transform = CGAffineTransformIdentity
//            
//            }, completion: nil)
//        
        // Animación denominada Spring Animation
//        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [], animations: {
//            
//            self.ratingStackView.transform = CGAffineTransformIdentity
//            
//            }, completion: nil)
        
        // Spring animation
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            
            self.dislikeButton.transform = CGAffineTransformIdentity
            
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            
            self.goodButton.transform = CGAffineTransformIdentity
            
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.4, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            
            self.greatButton.transform = CGAffineTransformIdentity
            
            }, completion: nil)
    }
    
    // Método con el que controlamos que botón ha usado el usuario para valorar el local.
    @IBAction func ratingSelected(sender:UIButton)
    {
        switch (sender.tag) {
        case 100: rating = "dislike"
        case 200: rating = "good"
        case 300: rating = "great"
        default: break
        }
        
        performSegueWithIdentifier("unwindToDetailView", sender: sender)
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
