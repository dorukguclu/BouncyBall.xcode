import Foundation

let ball = OvalShape(width: 40, height: 40)
let barrierWidth = 300.0
let barrierHeight = 25.0
var barriers: [Shape] = []

let funnelPoints = [
    Point(x: 0, y: 50),
    Point(x: 80, y: 50),
    Point(x: 60, y: 0),
    Point(x: 20, y: 0)
]

let funnel = PolygonShape(points: funnelPoints)

let targetPoints = [
    Point(x: 10, y: 0),
    Point(x: 0, y: 10),
    Point(x: 10, y: 20),
    Point(x: 20, y: 10)
]

let target = PolygonShape(points: targetPoints)

// Resets the game by moving the ball below the scene,
// which will unlock the barriers.
func resetGame() {
    ball.position = Point(x: 0, y: -80)
}

func printPosition(of shape: Shape) {
    print(shape.position)
}

func setupTarget() {
    // Setup the target
    target.position = Point(x: 35, y: 240)
    target.hasPhysics = true
    target.isImmobile = true
    target.isImpermeable = false
    target.fillColor = .yellow
    scene.add(target)
    target.name = "target"
    target.isDraggable = false

}

fileprivate func setupBall() {
    // Setup the circle
    ball.position = Point(x: 250, y: 400)
    scene.add(ball)
    ball.hasPhysics = true
    ball.fillColor = .blue
    ball.onCollision = ballCollided(with:)
    ball.isDraggable = false
    scene.trackShape(ball)
    ball.onExitedScene = ballExitedScene
    ball.onTapped = resetGame
    ball.bounciness = 0.6
}

fileprivate func addBarrier(at position: Point, width: Double, height: Double, angle: Double) {
    let barrierPoints = [
    Point(x: 0, y: 0),
    Point(x: 0, y: height),
    Point(x: width, y: height),
    Point(x: width, y: 0)
]
    let barrier = PolygonShape(points: barrierPoints)
    barriers.append(barrier)
    // Setup the barrier
    barrier.position = Point(x: 200, y: 150)
    barrier.hasPhysics = true
    scene.add(barrier)
    barrier.isImmobile = true
    barrier.fillColor = .brown
    barrier.angle = 0.1
       
}

fileprivate func setupFunnel() {
    // Setup the funnel
    funnel.position = Point(x: 200, y: scene.height - 25)
    scene.add(funnel)
    funnel.onTapped = dropBall
    funnel.fillColor = .gray
    funnel.isDraggable = false

}


func setup() {
    setupBall()

    addBarrier(at: Point(x: 200, y: 150), width: 80, height: 25, angle: 0.1)
    
    addBarrier(at: Point(x: 500, y: 450), width: 80, height: 25, angle: 0.1)

    setupFunnel()
    
    setupTarget()
    
    resetGame()
    
    scene.onShapeMoved = printPosition(of:)
}


func dropBall() {
    ball.position = funnel.position
    ball.stopAllMotion()
    for barrier in barriers {
        barrier.isDraggable = false
    }
}

func ballCollided(with otherShape: Shape) {
    if otherShape.name != "target" {return}
    
    otherShape.fillColor = .green
}

func ballExitedScene() {
    for barrier in barriers {
        barrier.isDraggable = true
    }
}
