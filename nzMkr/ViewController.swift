import UIKit
import CoreMotion
import AudioKit

class ViewController: UIViewController {
    var motionManager: CMMotionManager!
    
    let motionOperationQueue = OperationQueue()
    let oscillator = AKOscillatorBank(waveform: AKTable(.sine), attackDuration: 0.5, decayDuration: 0.5, sustainLevel: 0.5, releaseDuration: 0.25)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        AudioKit.output = oscillator
        AudioKit.start()

        motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 0.25
        motionManager.startAccelerometerUpdates(to: motionOperationQueue) { (data, error) in
            let maxValue = max(data!.acceleration.x, data!.acceleration.y, data!.acceleration.z)
            if maxValue >= 0.75 {
                print(maxValue)
                self.playSound()
                self.changeBackgroundColor()
            }
        }
        
        view.backgroundColor = .black
    }

    let notes = Set([60, 62, 64, 67, 69, 72])
    var currentlyPlayingNotes = Set([Int]())

    private func changeBackgroundColor() {
        DispatchQueue.main.async {
            self.view.backgroundColor = UIColor(red: CGFloat(random(0, 1)), green: CGFloat(random(0, 1)), blue: CGFloat(random(0, 1)), alpha: CGFloat(random(0, 1)))
        }
    }

    private func playSound() {
        let shouldPlayNote = currentlyPlayingNotes.isEmpty || (random(0, 1) > 0.5 && currentlyPlayingNotes.count < notes.count)
        let noteToChange: Int

        if shouldPlayNote {
            let notPlayedNotes = notes.symmetricDifference(currentlyPlayingNotes)
            noteToChange = Array(notPlayedNotes)[Int(random(0, Double(notPlayedNotes.count)))]
            currentlyPlayingNotes.insert(noteToChange)
            oscillator.play(noteNumber: MIDINoteNumber(noteToChange), velocity: 127)
        } else {
            noteToChange = Array(currentlyPlayingNotes)[Int(random(0, Double(currentlyPlayingNotes.count)))]
            currentlyPlayingNotes.remove(noteToChange)
            oscillator.stop(noteNumber: MIDINoteNumber(noteToChange))
        }
    }
}

