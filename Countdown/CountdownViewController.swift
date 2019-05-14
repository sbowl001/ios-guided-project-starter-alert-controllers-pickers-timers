//
//  CountdownViewController.swift
//  Countdown
//
//  Created by Paul Solt on 5/8/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import UIKit

class CountdownViewController: UIViewController {

    @IBOutlet weak var countdownPickerView: CountdownPicker!
    @IBOutlet weak var countdownLabel: UILabel!
    
    private let countdown: Countdown = Countdown()
    
    
  
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SS"
        formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.countdown.duration = countdownPickerView.duration
        self.countdown.delegate = self
        
        //use a fixed width font, so that numbers don't "pop" and update UI to show duration
        self.countdownLabel.font = UIFont.monospacedDigitSystemFont(ofSize: self.countdownLabel.font.pointSize, weight: .medium)
        self.updateViews()
        
        self.countdownPickerView.countDownDelegate = self
    }

    @IBAction func startButtonTapped(_ sender: Any) {
//        self.showAlert()
//        let timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: timerFinished(time:))
        self.countdown.start()
    }
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        self.countdown.reset()
        self.updateViews()
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Timer Finished!", message: "Your countdown is over.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func timerFinished(time: Timer){
        self.updateViews()
        self.showAlert()
        
    }
    func string(from duration: TimeInterval) -> String {
        let date = Date(timeIntervalSinceReferenceDate: duration)
        return dateFormatter.string(from: date)
    }
}

extension CountdownViewController: CountdownDelegate {
    func countdownDidUpdate(timeRemaining: TimeInterval) {
        updateViews()
        
    }
    
    func countdownDidFinish() {
        updateViews()
        self.showAlert()
    }
    
    private func updateViews() {
//        self.countdownLabel.text = String(countdown.timeRemaining)
//        self.countdownLabel.text = string(from: countdown.timeRemaining)
        switch self.countdown.state {
        case .started:
            self.countdownLabel.text = string(from: countdown.timeRemaining)
        case .finished:
            self.countdownLabel.text = string(from: 0)
        case .reset:
            self.countdownLabel.text = string(from: self.countdown.duration)
        }
    }
}

extension CountdownViewController: CountdownPickerDelegate {
    func countdownPickerDidSelect(duration: TimeInterval) {
        // update countdown to use new picker duration value
        self.countdown.duration = duration
        self.updateViews()
    }
    
    
    
}
