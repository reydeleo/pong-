//
//  GameScene.swift
//  Pong
//
//  Created by reynaldo deleo on 7/29/17.
//  Copyright © 2017 reynaldo deleo. All rights reserved.
//aa

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var numberOfBounces = 0//this variable is used to insert the second ball and speed up
    
    var ball = SKSpriteNode()
    var ball2 = SKSpriteNode()//this is the second ball
    var enemy = SKSpriteNode()
    var enemy2 = SKSpriteNode()//this the second paddle to help
    var main = SKSpriteNode()
    var score = [Int]()
    
    var counter = 0 //this is for checking if vertical function for ball 1
    var previousXPosition:CGFloat = 123 //same ^
    var prevPrevXPosition: CGFloat = 123//same ^
    
    var counter2 = 0//this is for checking if ball 2 is going vertical 
    var previousXPosition2: CGFloat = 123// same ^
    var prevPrevXPosition2: CGFloat = 123// same ^
    var swtch = false//this is so that the program can know that ball 2 is now in play

    //these are for the checking horizontal function for ball
    var yCounter = 0
    var previousYPosition:CGFloat = 123
    var prevPrevYPosition: CGFloat = 123
    
    //these are for the checking horizontal function for ball 2
    var yCounter2 = 0
    var previousYPosition2: CGFloat = 123
    var prevPrevYPosition2: CGFloat = 123
    var swtch2 = false//this is so that the program can now that ball 2 is now is play
    
    
    var topLabel = SKLabelNode()
    var btmLabel = SKLabelNode()
    
    override func didMove(to view: SKView) {
        
        
    
        topLabel = self.childNode(withName: "topLabel") as! SKLabelNode
        btmLabel = self.childNode(withName: "btmLabel") as! SKLabelNode
        
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        ball2 = self.childNode(withName: "ball2") as! SKSpriteNode//this the second ball
        
        enemy = self.childNode(withName: "enemy") as! SKSpriteNode
        enemy.position.y = (self.frame.height/2) - 50
        
        enemy2 = self.childNode(withName: "enemy2") as! SKSpriteNode//enemy2
        enemy2.position.y = (self.frame.height/2) - 50//position enemy2
        
        main = self.childNode(withName: "main") as! SKSpriteNode
        main.position.y = (-self.frame.height/2) + 50
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        border.friction = 0
        border.restitution = 1
        
        self.physicsBody = border
        
        startGame()
        
        
    }
    
    func startGame()
    {
        //This is to make the impulse a little bit random
        let randomNumber:CGFloat = CGFloat((arc4random() % 5) + 10)
        let randomNumber2:CGFloat = CGFloat((arc4random() % 5) + 10)

        
        
        
        score = [0,0]
        topLabel.text = "\(score[1])"
        btmLabel.text = "\(score[0])"
        ball.physicsBody?.applyImpulse(CGVector(dx: randomNumber, dy: randomNumber2))
        
    }
    
    func addingBall()
    {
        ball2.colorBlendFactor = 0
        ball2.physicsBody?.applyImpulse(CGVector(dx: -10, dy: -10))//normally there goes a 10 on the dy:
        swtch = true
        swtch2 = true
        
    }
    //this is to make the second paddle dissappear
    func dissapearingPaddle()
    {
        //these three are just to make the second paddle as if its not there
        enemy2.physicsBody?.categoryBitMask = 0
        enemy2.physicsBody?.contactTestBitMask = 0
        enemy2.physicsBody?.collisionBitMask = 0
        //this is to blend the color so that its invisible
        enemy2.color = .clear
        
    }
    
    func addingPaddle()
    {
        //these three are to make the paddle work again
        enemy2.physicsBody?.categoryBitMask = 1
        enemy2.physicsBody?.contactTestBitMask = 2
        enemy2.physicsBody?.collisionBitMask = 2
        //this is just to make the paddle white
        enemy2.color = .white
        
    }
    
    func addScore(playerWhoWon : SKSpriteNode) {
        //what this is doing is restarting the ball position to the center every time someone loses
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        //this is what ball2 is going to do every time after someone loses
//        ball2.colorBlendFactor = 1
        ball2.position = CGPoint(x: 0, y: 0)
        ball2.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        ball2.colorBlendFactor = 1

        

        
        //making it more random at the time of serving
        var randomNumber:CGFloat = CGFloat((arc4random() % 5) + 10)
        let randomNumber2:CGFloat = CGFloat((arc4random() % 5) + 10)
        let signDecider = arc4random() % 2
        
        
        if(playerWhoWon == main){
            
            score[0] += 1
            //making it random at the time of serving
            if(signDecider == 0)
            {
                randomNumber = +randomNumber
            }
            else if(signDecider == 1)
            {
                randomNumber = -randomNumber
            }
            
            ball.physicsBody?.applyImpulse(CGVector(dx:randomNumber, dy: randomNumber2))
            
        }
        else if(playerWhoWon == enemy){
            score[1] += 1
            
            //making it random at the time of serving 
            if(signDecider == 0)
            {
                randomNumber = +randomNumber
            }
            else if(signDecider == 1)
            {
                randomNumber = -randomNumber
            }
            
            ball.physicsBody?.applyImpulse(CGVector(dx:randomNumber, dy: -randomNumber2))
            
        }
        
        topLabel.text = "\(score[1])"
        btmLabel.text = "\(score[0])"
        numberOfBounces = 0//this variable is to add the second ball
        
        counter = 0//this is for the checking if vertical function for ball
        counter2 = 0//this is for checking vertical but for ball 2
        swtch = false// on top it says what this is for
        
        yCounter = 0 //this is for the horizontal checking function
        yCounter2 = 0 //this is for the horizontal checking function but for ball 2
        swtch2 = false //this is for the horizontal checking function but for ball 2
        
        
    }
    //this function is for two player game
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches{
            let location = touch.location(in: self)
            
            if currentGameType == .Player2 {
                if location.y > 0 {
                    enemy.run(SKAction.moveTo(x: location.x, duration: 0))
                }
                if location.y < 0 {
                    main.run(SKAction.moveTo(x: location.x, duration: 0))
                }
            }
            else {
                main.run(SKAction.moveTo(x: location.x, duration: 0))
            }
            
            
        }
    }
    //this is function is for two player game
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        for touch in touches{
            let location = touch.location(in: self)
            
            if currentGameType == .Player2 {
                if location.y > 0 {
                    enemy.run(SKAction.moveTo(x: location.x, duration: 0))
                }
                if location.y < 0 {
                    main.run(SKAction.moveTo(x: location.x, duration: 0))
                }
            }
            else {
                main.run(SKAction.moveTo(x: location.x, duration: 0))
            }
        }
    }

    //this is so that it applies an impulse when the ball is going vertical
    func checkingIfBallGoingVertical(xPosition: CGFloat)
    {
        if(counter >= 120)
        {
            ball.physicsBody?.applyImpulse(CGVector(dx: -10, dy: 0))
            counter = 0
        }
        if(previousXPosition == xPosition && xPosition == prevPrevXPosition)
        {
            counter = counter + 1
        }
        else
        {
            prevPrevXPosition = previousXPosition
            previousXPosition = xPosition
            
        }
    }
    
    //this is so that is applies an impulse when ball 2 is going vertical
    func checkingIfBall2GoingVertical(xPosition2: CGFloat)
    {
        if(counter2 >= 120)
        {
            ball2.physicsBody?.applyImpulse(CGVector(dx: -10, dy: 0))
            counter2 = 0
        }
        if(previousXPosition2 == xPosition2 && xPosition2 == prevPrevXPosition2 && swtch == true)
        {
            counter2 = counter2 + 1
        }
        else
        {
            prevPrevXPosition2 = previousXPosition2
            previousXPosition2 = xPosition2
            
        }
    }
    
    //this is to apply an impulse when ball is going horizontally and is just there stuck
    func checkingHorizontalBall(yPosition: CGFloat)
    {
        if(yCounter >= 120)
        {
            if(ball.position.y >= 0)
            {
                ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -10))
            }
            else if(ball.position.y < 0)
            {
                ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 10))
            }
            
            yCounter = 0
        }
        if(previousYPosition == yPosition && yPosition == prevPrevYPosition)
        {
            yCounter = yCounter + 1
        }
        else
        {
            prevPrevYPosition = previousYPosition
            previousYPosition = yPosition
        }
        
    }
    
    func checkingHorizontalBall2(yPosition2: CGFloat)
    {
        if(yCounter2 >= 120)
        {
            if(ball2.position.y >= 0)
            {
                ball2.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -10))
            }
            else if(ball2.position.y < 0)
            {
                ball2.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 10))
            }
            
            yCounter2 = 0
        }
        if(previousYPosition2 == yPosition2 && yPosition2 == prevPrevYPosition2 && swtch2 == true)
        {
            yCounter2 = yCounter2 + 1
        }
        else
        {
            prevPrevYPosition2 = previousYPosition2
            previousYPosition2 = yPosition2
        }
        
    }
    
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        switch currentGameType {
        case .Easy:
            
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.25))

            dissapearingPaddle()
            checkingIfBallGoingVertical(xPosition: ball.position.x)
            checkingHorizontalBall(yPosition: ball.position.y)
//            print(ball.position)
            
            break
        case .Medium:
            
            dissapearingPaddle()
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.15))//.18
            enemy2.run(SKAction.moveTo(x:ball2.position.x, duration: 0.15))//.18
            //this is to add the second ball
           
            if(true)
            {
                numberOfBounces = numberOfBounces + 1
            }
            
            if(numberOfBounces == 480)//this approximately 8 seconds
            {
                addingBall()
            }
            if(numberOfBounces >= 480)
            {
                addingPaddle()
            }
            checkingIfBallGoingVertical(xPosition: ball.position.x)
            checkingIfBall2GoingVertical(xPosition2: ball2.position.x)
            
            checkingHorizontalBall(yPosition: ball.position.y)
            checkingHorizontalBall2(yPosition2: ball2.position.y)
            
            
            
            
            break
        case .Hard:
            
            dissapearingPaddle()
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.12))//.12
            enemy2.run(SKAction.moveTo(x:ball2.position.x, duration: 0.12))//.12
            //this is to add the second ball
            if(true)
            {
                numberOfBounces = numberOfBounces + 1
                
            }
            
            if(numberOfBounces == 420)//this approximately 5 seconds
            {
                addingBall()
            }
            
            if(numberOfBounces >= 420)
            {
                addingPaddle()
            }
            
            if(numberOfBounces == 840)//after another 5 seconds speed the 2nd ball up
            {
//                var x = 5
//                var y = 5
//                
//                if(ball2.position.x < 0)
//                {
//                    x = -x
//                }
//                if(ball2.position.y < 0)
//                {
//                    y = -y
//                }
                ball2.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 5))
//
//                ball2.physicsBody.
//                ball2.physicsBody?.restitution = 1.005
                
            
            }
            
            checkingIfBallGoingVertical(xPosition: ball.position.x)
            checkingIfBall2GoingVertical(xPosition2: ball2.position.x)
            
            checkingHorizontalBall(yPosition: ball.position.y)
            checkingHorizontalBall2(yPosition2: ball2.position.y)
            
            


            
            break
        case .Player2:
            
            dissapearingPaddle()
            
            
            //this is to add the second ball
            if(true)
            {
                numberOfBounces = numberOfBounces + 1
                
            }
            
            if(numberOfBounces == 420)//this approximately 5 seconds
            {
                addingBall()
            }
            
            if(numberOfBounces == 840)//after another 5 seconds speed the 2nd ball up
            {
                ball2.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 5))
            }
            
            checkingIfBallGoingVertical(xPosition: ball.position.x)
            checkingIfBall2GoingVertical(xPosition2: ball2.position.x)

            
            break
        }
        
        
        if ball.position.y <= main.position.y{
            addScore(playerWhoWon: enemy)
        }
        else if ball.position.y >= enemy.position.y{
            addScore(playerWhoWon: main)
            
        }
        //this is for ball2
        if (ball2.position.y <= main.position.y)
        {
            addScore(playerWhoWon: enemy)
        }
        else if(ball2.position.y >= enemy.position.y)
        {
            addScore(playerWhoWon: main)
        }


        
        
    }
}
