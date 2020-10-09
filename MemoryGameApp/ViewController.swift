//
//  ViewController.swift
//  MemoryGameApp
//
//  Created by Matheus Souza on 05/10/2020.
//  Copyright © 2020 Matheus Souza. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var collection: UICollectionView!
    var model = CardModel()
    var cardArray = [Card]()
    
    var firstFlippedCardIndex:IndexPath?
    
    var timer: Timer?
    var milliseconds: Float = 30 * 1000 // 30 segundos

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collection.delegate = self
        collection.dataSource = self
        cardArray = model.getCards()
        
        // criar o cronometro
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        
        RunLoop.main.add(timer!, forMode: .commonModes)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Métodos do cronometro
    
    @objc func timerElapsed(){
        milliseconds -= 1
        // converter para segundos
        let seconds = String(format: "%.2f", milliseconds/1000)
        // setar o texto na tela
        timerLabel.text = "Tempo restante: \(seconds)"
        
        // quando chegar a 0 ... parar o cronometro
        if milliseconds <= 0 {
            // parar o cronometro
            timer?.invalidate()
            
            // mudar a cor do texto para vermelho
            timerLabel.textColor = UIColor.red
            
            // verificar se existe cartas que nao foram encontrados
            checkGameEnded()
        
        }
        

    }
    
    // MARK: Métodos dos protocolos
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a CardCollectionViewCell object
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // pegar a carta que a collection view está tentando mostrar
        let card = cardArray[indexPath.row]
        
        // setar a carta na cell
        cell.setCard(card)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // verificar se ainda tem tempo restante
        if milliseconds <= 0 {
            return
        }
        
        // pegar a cell que o usuário selecionou
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        // pegar a carta que o usuário selecionou
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false && card.isMatched == false{
            // efeito de virar a carta
            cell.flip()
            
            // seta que a carta foi virado
            card.isFlipped = true
            
            // determina se foi a primeira ou a segunda carta que foi virada
            if firstFlippedCardIndex == nil{
                // foi a primeira carta que foi virada
                firstFlippedCardIndex = indexPath
            }else{
                 // foi a segunda carta que foi virada
                 // verifica se combina a primeira carta com a segunda
                checkForMatches(indexPath )
            }
        }
    }
    
    // MARK: Métodos de logica
    func checkForMatches(_ secondFlippedCardIndex:IndexPath){
        // pega as cells para as duas cartas que foram viradas
        let cardOneCell = collection.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collection.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // pega as cartas que foram viradas
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        // compara as cartas para ver se são iguais
        if cardOne.imageName == cardTwo.imageName {
            // sucesso, são iguais
            // seta que elas são iguais
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            // remove elas da tela, para mostrar que já encontramos uma dupla de cartas
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // verifica se há cartas restantes
            checkGameEnded()
        }
        else{
            // fail, não são iguais
            // seta que as cartas são diferentes
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // vira as cartas de costas (para serem escolhidas futuramente)
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
        }
        
        // avisa a collection view para recarregar a cell da primeira carta se ela é nil
        if cardOneCell == nil{
            collection.reloadItems(at: [firstFlippedCardIndex!])
        }
        // reseta a propriedade de que a primeira carta foi virada
        firstFlippedCardIndex = nil
    }
    
    func checkGameEnded(){
        // determina se há cartas que combinaram
        var isWon = true
        for card in cardArray {
            if card.isMatched == false{
                isWon = false
                break
            }
        }
        
        // variaveis para o alert
        var title = ""
        var message = ""
        
        // se não, então o usuário ganhou. nisso para o tempo
        
        if isWon == true{
            if milliseconds > 0 {
                timer?.invalidate()
            }
            
            // seta a mensagem de sucesso
            title = "Parabéns!"
            message = "Você ganhou"
            
        }else{
            // se existe cartas não encontradas, verifica se há tempo restante para jogar
            if milliseconds > 0 {
                return
            }
            
            // seta a mensagem de perdedor
            title = "GAME OVER"
            message = "Você perdeu"
        }
    
        
        // mostra a mensagem de vencedor :) ou derrotado :(
        showAlert(title, message)
    }
    
    func restart(){
        // reinicia o jogo após o clique no alert
        cardArray = [Card]()
        cardArray = model.getCards()
        milliseconds = 30 * 1000
        timerLabel.textColor = UIColor.black
        collection.reloadData()
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .commonModes)
    }
    
    func showAlert(_ title:String, _ message: String){
        // alert padrão
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertActionOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
        let alertActionRestart = UIAlertAction(title: "Restart?", style: .default) { (restart) in
            self.restart()
        }
        alert.addAction(alertActionOk)
        alert.addAction(alertActionRestart)
        
        present(alert,animated: true, completion: nil)
    }
    


}

