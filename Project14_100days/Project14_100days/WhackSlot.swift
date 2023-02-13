//
//  WhackSlot.swift
//  Project14_100days
//
//  Created by user228564 on 2/9/23.
//
import SpriteKit
import UIKit

class WhackSlot: SKNode {
    
    var charNode: SKSpriteNode!
    var isVisible = false
    var isHit = false
    
    func configure(at position: CGPoint) {
        self.position = position

        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")

        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)

        addChild(cropNode)
    }
    
    func show(hideTime: Double) {
        if isVisible { return }
        
        mud()
        
        charNode.xScale = 1
        charNode.yScale = 1
        
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        isVisible = true
        isHit = false

        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [weak self] in
            self?.hide()
        }
    }
    
    func hide() {
        if !isVisible { return }
        
        mud()
        
        //charNode.run(SKAction.moveBy(x: 0, y: -80, duration: Double.random(in: 0.01...1)))
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
    }
    
    func hit() {
        isHit = true

        sparks()
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run { [weak self] in
            self?.isVisible = false
        }
        
        let sequence = SKAction.sequence([delay, hide, notVisible])
        charNode.run(sequence)
    }
    

    func sparks() {
        if let sparks = SKEmitterNode(fileNamed: "my_sparks") {
            let deploy = SKAction.run{self.addChild(sparks)}
            let delay = SKAction.wait(forDuration: 1.5)
            let delete = SKAction.run {self.removeChildren(in: [sparks])}
            
            run(SKAction.sequence([deploy, delay, delete]))
            
        }
    }
    
    func mud() {
        if let mud = SKEmitterNode(fileNamed: "penguin_appear") {
            let deploy = SKAction.run{self.addChild(mud)}
            let delay = SKAction.wait(forDuration: 0.3)
            let delete = SKAction.run {self.removeChildren(in: [mud])}
            run(SKAction.sequence([deploy, delay, delete]))
        }
    }
}
