//
//  CardModel.swift
//  MemoryGameApp
//
//  Created by Matheus Souza on 06/10/2020.
//  Copyright © 2020 Matheus Souza. All rights reserved.
//

import Foundation

class CardModel{
    
    func getCards() -> [Card]{
        
        // array para guardar os numeros que iremos gerar
        var generatedNumbersArray = [Int]()
        
        // array para guardar as cartas geradas
        var generatedCardsArray = [Card]()
        
        // randomicamente gera pares de cartas
        // TODO: caso haja necessidade de fazer um menu easy, medium e hard, alterar esse valor dependendo da escolha.
        while generatedNumbersArray.count < 4 {

            // pegar um numero aleatório
            let randomNumber = arc4random_uniform(13) + 1
            
            // garantir que o numero randomico seja único dentro do array
            if generatedNumbersArray.contains(Int(randomNumber)) == false{
                
                // grava o numero dentro do array de numeros
                generatedNumbersArray.append(Int(randomNumber))
                
                // cria a primeiro carta
                let cardOne = Card()
                cardOne.imageName = "card\(randomNumber)"
                generatedCardsArray.append(cardOne)
                
                // cria a segunda carta -> mesma da primeira
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"
                generatedCardsArray.append(cardTwo)

            }
            
        }
        // cada vez que o jogo abrir, ou reiniciar, randomizar o array de cartas
        for i in 0...generatedCardsArray.count-1{
            
            // find a random index to swap with
            let randomNumber = Int(arc4random_uniform(UInt32(generatedCardsArray.count)))
            
            // swap two cards
            let temporaryStorage = generatedCardsArray[i]
            generatedCardsArray[i] = generatedCardsArray[randomNumber]
            generatedCardsArray[randomNumber] = temporaryStorage
        }
        
        
        
        // retorna o array de cartas
        return generatedCardsArray
    }
    
}
