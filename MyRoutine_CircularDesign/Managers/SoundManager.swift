//
//  SoundManager.swift
//  MyRoutine_CircularDesign
//
//  Created by 김윤석 on 2021/04/21.
//

import AVFoundation

final class SoundManager {
    static let shared = SoundManager()
    
    var player: AVAudioPlayer!
    
    func playSound(_ fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private init(){}
    
}
