//
//  EmotionPickerState.swift
//  Aura
//
//  Created by Anton Solovev on 23.04.2025.
//

import UIKit

enum EmotionPickerState {
    case inactive
    case active(emotionTitle: String, emotionDescription: String, emotionColor: UIColor)
}
