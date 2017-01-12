import UIKit
import CoreMotion
import AVFoundation

class ViewController: UIViewController {
    var motionManager: CMMotionManager!
    
    let motionOperationQueue = OperationQueue()
    let audioFileURL = Bundle.main.url(forResource: "Clap", withExtension: "wav")!
    var audioPlayer: AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = try! AVAudioPlayer(contentsOf: audioFileURL)

        motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 0.25
        motionManager.startAccelerometerUpdates(to: motionOperationQueue) { (data, error) in
            let maxValue = max(data!.acceleration.x, data!.acceleration.y, data!.acceleration.z)
            if maxValue >= 0.75 {
                self.playSound()
            }
        }
        
        view.backgroundColor = .red
    }
    
    private func playSound() {
        audioPlayer.play()
    }
}

