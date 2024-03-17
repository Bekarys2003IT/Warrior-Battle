//
//  ViewController.swift
//  Warrior
//
//  Created by Bekarys Sandigali on 17.03.2024.
//

import UIKit
import SnapKit
class ViewController: UIViewController {

    var warriors = [Warrior]()
    
    lazy var textField:UITextField = {
        let field = UITextField()
        field.text = ""
        field.layer.cornerRadius = 16
        field.layer.borderWidth = 2
        field.layer.borderColor = UIColor.black.cgColor
        return field
    }()
    
    lazy var pressButton :UIButton = {
        let button = UIButton()
        button.setTitle("Press", for: .normal)
        button.backgroundColor = .black
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 16
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        return button
    }()
    lazy var warriorLabel: UILabel = {
       let label = UILabel()
        label.text = "\(warriors)"
        label.numberOfLines = 0
        return label
    }()
    let winLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        winLabel.text = "Here is the name of winner"
        setUI()
    }
    func setUI(){
        view.addSubview(textField)
        view.addSubview(pressButton)
        view.addSubview(winLabel)
        view.addSubview(warriorLabel)
        //constraints
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(250)
        }
        pressButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(60)
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalTo(150)
        }
        warriorLabel.snp.makeConstraints { make in
            make.top.equalTo(pressButton.snp.bottom).offset(70)
            make.centerX.equalToSuperview()
        }
        winLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
            make.centerX.equalToSuperview()
        }
        
    }
    @objc func buttonTap(){
        if let warriorName = textField.text, !warriorName.isEmpty {
            let health = Int.random(in: 5...15)
            let atack = Int.random(in: 1...10)
            let newWarrior = Warrior(name: warriorName, health: health, atack: atack)
            warriors.append(newWarrior)
            updateWarriorLabel()
            if warriors.count >= 3 {
                textField.isEnabled = false
                atackHero()
                let alert = UIAlertController(title: "Maximum is 3", message: "You reached maximum amount", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
            }
            textField.text = " "
            

        } else {
            let alert = UIAlertController(title: "Empty Name", message: "Please enter a warrior's name.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK",style:.default))
            present(alert, animated: true)
            return
        }
        
    }
    func updateWarriorLabel() {
        warriorLabel.text = warriors.map { "\($0.name) H:\($0.health) A:\($0.atack)" }.joined(separator: ", ")
    }
    func atackHero() {
        if warriors.count >= 3 {
            var hero1 = warriors[0]
            var hero2 = warriors[1]
            var hero3 = warriors[2]
            
            while warriors.filter({ $0.health > 0 }).count > 1 {
                        hero2.health -= hero1.atack
                        hero3.health -= hero2.atack
                        hero1.health -= hero3.atack
                
                if hero1.health <= 0{
                    print("Hero1 is died")
                    hero1.health = 0
                    break
                }
                if hero2.health <= 0 {
                    print("Hero2 is died")
                    hero2.health = 0
                    break
                }
                if hero3.health <= 0{
                    print("Hero3 is died")
                    hero3.health = 0
                    break
                }
                if warriors.filter({ $0.health > 0 }).count <= 1 {
                                break
                            }
                

            }
            let lastWarrior = warriors.first {$0.health > 0}
            if let last = lastWarrior {
                print(last.name , "is win")
                DispatchQueue.main.async {
                    self.winLabel.text = last.name + " is win"
                }
            }
        }
                
    }
        
    
    

}

