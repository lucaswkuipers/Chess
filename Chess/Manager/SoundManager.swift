import UIKit
import AVFAudio

var player: AVAudioPlayer?

final class SoundManager {
    static let shared = SoundManager()

    private init() {}

    enum Sound: String {
        case begin = "begin"
        case move = "move"

        var fileName: String {
            return self.rawValue
        }
    }

    public func play(sound: Sound) {
        guard let url = Bundle.main.url(forResource: sound.fileName, withExtension: "mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        }

        catch let error {
            print(error.localizedDescription)
        }
    }
}

