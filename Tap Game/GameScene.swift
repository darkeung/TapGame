//
//  GameScene.swift
//  Tap Game
//
//  Created by NG CHUN KEUNG on 23/4/18.
//  Copyright © 2018 NG CHUN KEUNG. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    var leftCar = SKSpriteNode()
    
    
    var canMove = false
    var leftToMoveLeft = true
    var rightCarToMoveRight = true
    
    var leftCarAtRight = false
    var rightCarAtLeft = false
    var centerPoint : CGFloat!
    var score = 0
    
    
    let leftCarMinimumX :CGFloat = -280
    let leftCarMaximumX : CGFloat = 280
    
    
    
    
    var countDown = 1
    var stopEverything = true
    var scoreText = SKLabelNode()
    
    var gameSettings = Settings.sharedInstance
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setUp()
        physicsWorld.contactDelegate = self
        Timer.scheduledTimer(timeInterval: TimeInterval(0.1), target: self, selector: #selector(GameScene.createRoadStrip), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(GameScene.startCountDown), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: TimeInterval(Helper().randomBetweenTwoNumbers(firstNumber: 0.8, secondNumber: 1.8)), target: self, selector: #selector(GameScene.leftTraffic), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: TimeInterval(0.5), target: self, selector: #selector(GameScene.removeItems), userInfo: nil, repeats: true)
        let deadTime = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: deadTime) {
            Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(GameScene.increaseScore), userInfo: nil, repeats: true)
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if canMove{
            move(leftSide:leftToMoveLeft)
            
        }
        showRoadStrip()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        
        
        if contact.bodyA.node?.name == "leftCar" {
            firstBody = contact.bodyA
            
        }else{
            firstBody = contact.bodyB
            
        }
        firstBody.node?.removeFromParent()
        afterCollision()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let touchLocation = touch.location(in: self)
            if touchLocation.x > centerPoint{
                if rightCarAtLeft{
                    rightCarAtLeft = false
                    rightCarToMoveRight = true
                }else{
                    rightCarAtLeft = true
                    rightCarToMoveRight = false
                }
            }else{
                if leftCarAtRight{
                    leftCarAtRight = false
                    leftToMoveLeft = true
                }else{
                    leftCarAtRight = true
                    leftToMoveLeft = false
                }
                
            }
            canMove = true
        }
    }
    
    func setUp(){
        leftCar = self.childNode(withName: "leftCar") as! SKSpriteNode
        
        centerPoint = self.frame.size.width 
        
        leftCar.physicsBody?.categoryBitMask = ColliderType.CAR_COLLIDER
        leftCar.physicsBody?.contactTestBitMask = ColliderType.ITEM_COLLIDER
        leftCar.physicsBody?.collisionBitMask = 0
        
        
        let scoreBackGround = SKShapeNode(rect:CGRect(x:-self.size.width/2 + 70 ,y:self.size.height/2 - 130 ,width:180,height:80), cornerRadius: 20)
        scoreBackGround.zPosition = 4
        scoreBackGround.fillColor = SKColor.black.withAlphaComponent(0.3)
        scoreBackGround.strokeColor = SKColor.black.withAlphaComponent(0.3)
        addChild(scoreBackGround)
        
        scoreText.name = "score"
        scoreText.fontName = "AvenirNext-Bold"
        scoreText.text = "0"
        scoreText.fontColor = SKColor.white
        scoreText.position = CGPoint(x: -self.size.width/2 + 160, y: self.size.height/2 - 110)
        scoreText.fontSize = 50
        scoreText.zPosition = 3
        addChild(scoreText)
    }
    
    @objc func createRoadStrip(){
        let leftRoadStrip = SKShapeNode(rectOf: CGSize(width: 80, height: 40))
        leftRoadStrip.strokeColor = SKColor.white
        leftRoadStrip.fillColor = SKColor.white
        leftRoadStrip.alpha = 0.4
        leftRoadStrip.name = "leftRoadStrip"
        leftRoadStrip.zPosition = 10
        leftRoadStrip.position.x = 0
        leftRoadStrip.position.y = 700
        addChild(leftRoadStrip)
        
        
    }
    
    func showRoadStrip(){
        
        enumerateChildNodes(withName: "leftRoadStrip", using: { (roadStrip, stop) in
            let strip = roadStrip as! SKShapeNode
            strip.position.y -= 30
        })
        
        
        
        enumerateChildNodes(withName: "orangeCar", using: { (leftCar, stop) in
            let car = leftCar as! SKSpriteNode
            car.position.y -= 20
        })
        
        enumerateChildNodes(withName: "greenCar", using: { (rightCar, stop) in
            let car = rightCar as! SKSpriteNode
            car.position.y -= 20
        })
        
    }
    
    @objc func removeItems(){
        for child in children{
            if child.position.y < -self.size.height - 100{
                child.removeFromParent()
            }
        }
        
    }
    
    
    func move(leftSide:Bool){
        if leftSide{
            leftCar.position.x -= 20
            if leftCar.position.x < leftCarMinimumX{
                leftCar.position.x = leftCarMinimumX
            }
        }else{
            leftCar.position.x += 20
            if leftCar.position.x > leftCarMaximumX{
                leftCar.position.x = leftCarMaximumX
            }
            
            
        }
    }
    
    
    
    
    
    
    
    @objc func leftTraffic(){
        if !stopEverything{
            let leftTrafficItem : SKSpriteNode!
            let randonNumber = Helper().randomBetweenTwoNumbers(firstNumber: 1, secondNumber: 8)
            switch Int(randonNumber) {
            case 1...4:
                leftTrafficItem = SKSpriteNode(imageNamed: "pinkcarupdate")
                leftTrafficItem.name = "orangeCar"
                break
            case 5...8:
                leftTrafficItem = SKSpriteNode(imageNamed: "bluecarupdate")
                leftTrafficItem.name = "greenCar"
                break
            default:
                leftTrafficItem = SKSpriteNode(imageNamed: "pinkcarupdate")
                leftTrafficItem.name = "orangeCar"
            }
            leftTrafficItem.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            leftTrafficItem.zPosition = 10
            let randomNum = Helper().randomBetweenTwoNumbers(firstNumber: 1, secondNumber: 10)
            switch Int(randomNum) {
            case 1...4:
                leftTrafficItem.position.x = -280
                break
            case 5...10:
                leftTrafficItem.position.x = 280
                break
            default:
                leftTrafficItem.position.x = -280
            }
            leftTrafficItem.position.y = 700
            leftTrafficItem.physicsBody = SKPhysicsBody(circleOfRadius: leftTrafficItem.size.height/2)
            leftTrafficItem.physicsBody?.categoryBitMask = ColliderType.ITEM_COLLIDER
            leftTrafficItem.physicsBody?.collisionBitMask = 0
            leftTrafficItem.physicsBody?.affectedByGravity = false
            addChild(leftTrafficItem)
        }
    }
    
    
    
    
    func afterCollision(){
        if gameSettings.highScore < score{
            gameSettings.highScore = score
        }
        let menuScene = SKScene(fileNamed: "GameMenu")!
        menuScene.scaleMode = .aspectFill
        view?.presentScene(menuScene, transition: SKTransition.doorsCloseHorizontal(withDuration: TimeInterval(2)))
    }
    
    
    @objc func startCountDown(){
        if countDown>0{
            if countDown < 4{
                let countDownLabel = SKLabelNode()
                countDownLabel.fontName = "AvenirNext-Bold"
                countDownLabel.fontColor = SKColor.white
                countDownLabel.fontSize = 300
                countDownLabel.text = String(countDown)
                countDownLabel.position = CGPoint(x: 0, y: 0)
                countDownLabel.zPosition = 300
                countDownLabel.name = "cLabel"
                countDownLabel.horizontalAlignmentMode = .center
                addChild(countDownLabel)
                
                let deadTime = DispatchTime.now() + 0.5
                DispatchQueue.main.asyncAfter(deadline: deadTime, execute: {
                    countDownLabel.removeFromParent()
                })
            }
            countDown += 1
            if countDown == 4 {
                self.stopEverything = false
            }
        }
    }
    
    @objc func increaseScore(){
        if !stopEverything{
            score += 1
            scoreText.text = String(score)
        }
    }
    
}









