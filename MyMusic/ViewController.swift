//
//  ViewController.swift
//  MyMusic
//
//  Created by MD Tanvir Alam on 31/3/21.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var songs = [Song]()
    @IBOutlet var table:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        configureSongs()
    }
    
    func configureSongs(){
        songs.append(Song(name: "Song1", albumName: "HotPlay", imageName: "Covor1", trackName: "Audio1"))
        songs.append(Song(name: "Song2", albumName: "ColdPlay", imageName: "Covor2", trackName: "Audio2"))
        songs.append(Song(name: "Song3", albumName: "FirstToElleven", imageName: "Covor3", trackName: "Audio3"))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let song = songs[indexPath.row]
        cell.textLabel?.text = song.name
        cell.detailTextLabel?.text = song.albumName
        cell.imageView?.image = UIImage(named: song.imageName)
        cell.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 16)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        let position = indexPath.row
        
        guard let vc = (storyboard?.instantiateViewController(identifier: "player")) as? PlayerViewController else{
            return
        }
        
        vc.index = position
        vc.songs = songs
        
        present(vc, animated: true)
    }

}

