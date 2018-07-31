//
//  ViewController.swift
//  PuzzleGame
//
//  Created by Kevin Calderón on 27/06/18.
//  Copyright © 2018 Kevin Calderón. All rights reserved.
//

import UIKit
import RevealingSplashView

class ViewController: UIViewController {

    //IB, interfaceBuilder
    //Outlet, es la conexion entre interfaz y codigo
    //Outlet Collection, son varios seleccionados y devuelve un array
    @IBOutlet weak var board: UIView!
    var tileWidth : CGFloat = 0.0
    
    @IBOutlet weak var ticks: UILabel!
    var contador: Int = 0
    
    let splashScreen = RevealingSplashView(iconImage: UIImage(named: "iconApp")!, iconInitialSize: CGSize(width: 90, height: 90), backgroundColor: UIColor.white)
    
    //Guardar el punto central.
    var tileCenterX : CGFloat = 0.0
    var tileCenterY : CGFloat  = 0.0
    //arrayMutable que sus valores pueden cambiar.
    var tileArray : NSMutableArray = []
    var centerArray : NSMutableArray = []
    
    var tileEmptyCenter : CGPoint = CGPoint(x: 0, y: 0)
    
    
    //contador de movimientos
    func contadorMovimientos(contador: Int){
        self.contador = contador
        ticks.text = "Movimientos: \(self.contador)"
    }
    
    //action, es una funcion que captura eventos, resetea el juego.
    @IBAction func btnRandom(_ sender: Any) {
        randomTiles()
        contadorMovimientos(contador: 0)
    }
    
    //se ejecuta cuando la vista sale en pantalla
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.splashScreen)
        self.splashScreen.animationType = SplashAnimationType.popAndZoomOut
        self.splashScreen.startAnimation()
        
        makeTile()
        randomTiles()
    }
    
//    //alert start
//    override func viewDidAppear(_ animated: Bool){
//        super.viewDidAppear(animated)
//
//        let alert = UIAlertController(title: "Welcome to the Game!",
//                                      message: "Solve the puzzle in the shortest possible time",
//                                      preferredStyle: .alert)
//
//        let alertOKAction = UIAlertAction(title:"OK", style: UIAlertActionStyle.default,handler: { action in
//            print("Button pressed, Ok!")
//        })
//
//        alert.addAction(alertOKAction)
//        self.present(alert, animated: true, completion:nil)
//    }

    func makeTile(){
        //inicien los arrays en cero.
        self.tileArray = []
        self.centerArray = []
        //accedes internamente a la vista del board, casteo bool -> int
        let boardWidth = self.board.frame.width
        self.tileWidth = boardWidth / 4     //100
        self.tileCenterX = self.tileWidth / 2  // 50 = 150
        self.tileCenterY = self.tileWidth / 2
        var tileNumber : Int = 1
    
        for _ in 0..<4{
            for _ in 0..<4{
                                //CGRect, core graphic
                let tileFrame : CGRect = CGRect(x: 0, y: 0, width: self.tileWidth - 2, height: self.tileWidth - 2)
                let tile : customLabel = customLabel(frame: tileFrame)
                let currentCenter : CGPoint = CGPoint(x: self.tileCenterX, y: self.tileCenterY)
                
                tile.center = currentCenter
                tile.originCenter = currentCenter
                
                //txt en los labels
                if tileNumber <= 16{
                    tile.backgroundColor = UIColor(patternImage: UIImage(named: "\(tileNumber).jpg")!)
                } else {
                    tile.backgroundColor = UIColor.darkGray
                }
                
                //tile.text = "\(tileNumber)"
                tile.textAlignment = NSTextAlignment.center
                
                //interactuar con el usuario
                tile.isUserInteractionEnabled = true
                
                self.centerArray.add(currentCenter)
                self.board.addSubview(tile)
                tileNumber += 1
                
                
                
                //agregamos tile a los arreglos
                self.tileArray.add(tile)
                
                self.tileCenterX += self.tileWidth
            }
            
            self.tileCenterX = self.tileWidth / 2
            self.tileCenterY += self.tileWidth
        
        }
        
        //guardar cual es el ultimo elemento de la collecion para "quitarlo"
        let lastTile : customLabel = self.tileArray.lastObject as! customLabel
        lastTile.removeFromSuperview()
        self.tileArray.removeObject(at: 15)
    }

    func randomTiles(){
        //copiar todos los valores que tiene ese array hacia el nuevo array temp.
        let tempTileCenterArray : NSMutableArray = self.centerArray.mutableCopy() as! NSMutableArray
        for anyTile in self.tileArray {
            
            //devuelva un numero aleatorio entre 0 y 15
            let randomIndex : Int = Int(arc4random()) % tempTileCenterArray.count
            let randomCenter : CGPoint = tempTileCenterArray[randomIndex] as! CGPoint
            (anyTile as! customLabel).center = randomCenter
            
            //al encontrar un elemento eliminarlo para no repetirlo, en el array.
            tempTileCenterArray.removeObject(at: randomIndex)
        }
        
        self.tileEmptyCenter = tempTileCenterArray[0] as! CGPoint
    }
    
    //acceder sobre eventos sobre touch
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //calcular el evento donde toco el usuario
        let currentTouch : UITouch = touches.first!
        if (self.tileArray.contains(currentTouch.view as Any)){
            let touchLabel : customLabel = currentTouch.view as! customLabel
            
            let DiferenciaX : CGFloat = touchLabel.center.x - self.tileEmptyCenter.x
            let DiferenciaY : CGFloat = touchLabel.center.y - self.tileEmptyCenter.y
            
            let distance : CGFloat = sqrt(pow(DiferenciaX, 2) + pow(DiferenciaY, 2))
            
            if distance == self.tileWidth {
                let tempCenter : CGPoint = touchLabel.center
                //animacion de piezas.
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(0.2)
                touchLabel.center = self.tileEmptyCenter
                UIView.commitAnimations()
                self.tileEmptyCenter = tempCenter
                
                //agrega movimientos.
                contadorMovimientos(contador: self.contador + 1)
            }
            
        }
    }
    

    
    //cuando falla algo de la memoria
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}



class customLabel: UILabel {
    var originCenter : CGPoint = CGPoint(x: 0, y: 0)
}

