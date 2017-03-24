//
//  ViewController.swift
//  MoviesLib
//
//  Created by Eric on 06/03/17.
//  Copyright © 2017 EricBrito. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class MovieViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var ivPoster: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbGenre: UILabel!
    @IBOutlet weak var lbDuration: UILabel!
    @IBOutlet weak var lbScore: UILabel!
    @IBOutlet weak var tvSinopsis: UITextView!
    @IBOutlet weak var lcButtonX: NSLayoutConstraint!
    @IBOutlet weak var viTrailer: UIView!
    
    /*
     Quando declaramos uma variávem optional - ? - temos que desembrulha-la sempre que usarmos
     */
    
    // MARK: Properties
    var movie: Movie! // Por isso aqui nós já desembrulhamos, para não ter que ficar fazendo isso toda hora, e tbm garantimos que vai existir
    var moviePlayer: AVPlayer! // Usamos quando queremos tocar audio/video e servev para tocar tanto local quanto remoto, i.e.: by URL/MP3, etc...
    var moviePlayerController: AVPlayerViewController! // Vai fornecer container com série de controles para conseguirmos manipular esse vídeo; poderíamos criar o nosso próprio mas esse nos ajudará
    
    // MARK: Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareVideo()
        
        // Toca automaticamente caso o usuário tenha escolhido nos settings do app
        if UserDefaults.standard.bool(forKey: SettingsType.autoplay.rawValue) {
            changeMovieStatus(play: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //ivPoster.image = UIImage(named: movie.imageWide)
        lbTitle.text = movie.title
        lbDuration.text = movie.duration
        lbScore.text = "⭐️ \(movie.rating)/10"
        if let categories = movie.categories {
            lbGenre.text = categories.map({($0 as! Category).name!}).joined(separator: " | ")
        }
        if let image = movie.poster as? UIImage {
            ivPoster.image = image
        }
        tvSinopsis.text = movie.summary
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        changeMovieStatus(play: false)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MovieRegisterViewController {
            vc.movie = movie
        }
    }
    
    func prepareVideo() {
        // Recuperar URL do vídeo
        // let url = Bundle.main.url(forResource: "logan-trailer", withExtension: "mp4")! // Sabemos que existe, então podemos desembrulha-la
        
        let url = URL(string: "http://goo.gl/8XmNn8")!
        
        moviePlayer = AVPlayer(url: url)
        moviePlayerController = AVPlayerViewController()
        moviePlayerController.player = moviePlayer
        moviePlayerController.showsPlaybackControls = true
        moviePlayerController.view.frame = viTrailer.bounds
        // moviePlayerController.view // View que contém o file, temos que pega-la e jogar na outra
        viTrailer.addSubview(moviePlayerController.view)
        
    }
    
    @IBAction func playVideo(_ sender: UIButton) {
        sender.isHidden = true
        changeMovieStatus(play: true)
    }
    
    func changeMovieStatus(play: Bool) {
        viTrailer.isHidden = false
        if play {
            moviePlayer.play()
        } else {
            moviePlayer.pause()
        }
    }
    
}


















