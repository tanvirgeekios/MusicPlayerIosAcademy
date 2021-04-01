//
//  PlayerViewController.swift
//  MyMusic
//
//  Created by MD Tanvir Alam on 31/3/21.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    public var index:Int = 0
    public var songs:[Song] = []
    @IBOutlet var holder:UIView!
    var player : AVAudioPlayer?
    
    //userInterface
    let playPauseButton = UIButton()
    private let albumImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let songNameLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let artistNameLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let albumNameLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("in viewdidlayoutsubviews")
        print("\(holder.subviews.count)")
        if holder.subviews.count == 0{
            configure()
        }
    }
    
    func configure(){
        print("In configure")
        //set up player
        let song = songs[index]
        let urlString = Bundle.main.path(forResource: song.trackName, ofType: "mp3")
        
        do{
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            guard let urlString = urlString else{
                return
            }
            print(urlString)
            player = try AVAudioPlayer(contentsOf: URL(string: urlString)!)
            
            guard let player = player else {
                return
            }
            player.volume = 0.5
            player.play()
            
        }catch{
            print(error)
        }
        
        //setUP UserInterfaceElements
        albumImageView.frame = CGRect(x: 10, y: 10, width: holder.frame.size.width - 20, height: holder.frame.size.width - 20)
        albumImageView.image = UIImage(named: song.imageName)
        holder.addSubview(albumImageView)
        
        songNameLabel.frame = CGRect(x: 10, y: albumImageView.frame.size.height + 10, width: holder.frame.size.width - 20, height: 50)
        artistNameLabel.frame = CGRect(x: 10, y: albumImageView.frame.size.height + 60, width: holder.frame.size.width - 20, height: 50)
        albumNameLabel.frame = CGRect(x: 10, y: albumImageView.frame.size.height + 110, width: holder.frame.size.width - 20, height: 50)
        
        songNameLabel.text = song.name
        albumNameLabel.text = song.albumName
        artistNameLabel.text = song.albumName
        
        holder.addSubview(songNameLabel)
        holder.addSubview(artistNameLabel)
        holder.addSubview(albumNameLabel)
        
        //volume slide
        let slider =  UISlider(frame: CGRect(x: 20, y: holder.frame.size.height - 60, width: holder.frame.size.width - 20, height: 50))
        slider.value = 0.5
        slider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
        holder.addSubview(slider)
        
        // Control Buttons
        
        let nextButton = UIButton()
        let backButton = UIButton()
        
        //frame
        let yPosition = artistNameLabel.frame.origin.y + 20 + 70
        let size:CGFloat = 70
        playPauseButton.frame = CGRect(x: (holder.frame.size.width - size)/2 , y: yPosition, width: size, height: size)
        nextButton.frame = CGRect(x: holder.frame.size.width - size - 20, y: yPosition, width: size, height: size)
        backButton.frame = CGRect(x: 20, y: yPosition, width: size, height: size)
        
        //images
        playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        nextButton.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)
        backButton.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)
        
        //tintColor
        playPauseButton.tintColor = .black
        nextButton.tintColor = .black
        backButton.tintColor = .black
        
        //action
        playPauseButton.addTarget(self, action: #selector(didtapPauseButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didtapForwardButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didtapBackButton), for: .touchUpInside)
        
        holder.addSubview(playPauseButton)
        holder.addSubview(nextButton)
        holder.addSubview(backButton)
        
    }
    
    @objc func didSlideSlider(_ slider:UISlider){
        let value = slider.value
        player?.volume = value
    }
    
    @objc func didtapBackButton(){
        if index > 0 {
            index = index - 1
            player?.stop()
            for subview in holder.subviews{
                subview.removeFromSuperview()
            }
            configure()
        }
    }
    @objc func didtapForwardButton(){
        if index < (songs.count - 1) {
            index = index + 1
            player?.stop()
            for subview in holder.subviews{
                subview.removeFromSuperview()
            }
            configure()
        }
    }
    @objc func didtapPauseButton(){
        if player?.isPlaying == true{
            player?.pause()
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            //shrink
            UIView.animate(withDuration: 0.5) {
                self.albumImageView.frame = CGRect(x: 30, y: 30, width: self.holder.frame.size.width - 60, height: self.holder.frame.size.width - 60)
            }
        }else{
            player?.play()
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
            // expand to normal
            UIView.animate(withDuration: 0.5) {
                self.albumImageView.frame = CGRect(x: 10, y: 10, width: self.holder.frame.size.width - 20, height: self.holder.frame.size.width - 20)
            }
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let player = player{
            player.stop()
        }
    }
}
