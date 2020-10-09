//
//  CardCollectionViewCell.swift
//  MemoryGameApp
//
//  Created by Matheus Souza on 06/10/2020.
//  Copyright © 2020 Matheus Souza. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    var card: Card?
    
    func setCard(_ card: Card){
        
        
        self.card = card
        
        if card.isMatched == true{
            // se a carta encontrou sua correspondente, some com ela
            backImageView.alpha = 0
            frontImageView.alpha = 0
            return
        }
        else{
            // se não encontrou, não some.
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        
        frontImageView.image = UIImage(named: card.imageName)
        
        // verifica se a carta está virada para baixo ou para cima
        if card.isFlipped == true {
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }else{
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
    }
    
    func flip(){
        // virar a carta pra frente (virando para a esquerda)
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
    
    func flipBack(){
        // virar a carta de costas (virando para o lado contrário do flip())
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
        
    }
    
    func remove(){
        // remover as duas cartas (sem atrapalhar a grid)
        backImageView.alpha = 0
        // animated
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)
        
        
    }
}
