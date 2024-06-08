//
//  WeatherViewController.swift
//  NetworkPractice
//
//  Created by 김정윤 on 6/6/24.
//

import UIKit
import Alamofire
import SnapKit

class WeatherViewController: UIViewController, setup {
    
    var list: [WeatherAndTemperature] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 12
        return stackView
    }()
    
    let locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "location.fill")
        imageView.tintColor = .accent
        return imageView
    }()
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.configureFont("서울", size: 18)
        return label
    }()
    
    let shareBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .accent
        return button
    }()
    
    let refreshBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.tintColor = .accent
        return button
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.configureFont(WeatherUrl.nowDateAndTime, size: 14)
        return label
    }()
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupConstraints()
        setupTableView()
        addTargets()
        network()
    }
    
    func setupHierarchy() {
        view.addSubview(backgroundImageView)
        view.addSubview(dateLabel)
        view.addSubview(locationImageView)
        view.addSubview(stackView)
        [locationImageView, cityLabel, shareBtn, refreshBtn].forEach {
            stackView.addArrangedSubview($0)
        }
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
        }
        
        stackView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.top.equalTo(dateLabel.snp.bottom).offset(8)
        }
        
        [locationImageView, shareBtn, refreshBtn].forEach {
            $0.snp.makeConstraints {
                $0.size.equalTo(35)
            }
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalTo(view)
        }
    }
    
    func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(WeatherLabelTableViewCell.self, forCellReuseIdentifier: WeatherLabelTableViewCell.identifier)
        tableView.register(WeatherIconTableViewCell.self, forCellReuseIdentifier: WeatherIconTableViewCell.identifier)
    }

    func network() {
        AF.request(WeatherUrl.weatherUrl).responseDecodable(of: WeatherContainer.self) { response in
            switch response.result {
                
            case .success(let value):
                self.list.append(WeatherAndTemperature(data: value.weather.first!.desc))
                self.list.append(WeatherAndTemperature(data: value.main.descCelsiusTemp))
                self.list.append(WeatherAndTemperature(data: value.main.descHumidity))
                self.list.append(WeatherAndTemperature(data: "오늘도 좋은 하루되세요✨"))
                
                WeatherUrl.weatherIconName = value.weather.first!.icon
                self.list.append(WeatherAndTemperature(data: WeatherUrl.weatherIconUrl, type: .icon))
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func addTargets() {
        refreshBtn.addTarget(self, action: #selector(refreshBtnTapped), for: .touchUpInside)
    }
    
    @objc func refreshBtnTapped(_ sender: UIButton) {
        list.removeAll()
        network()
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = list[indexPath.row]
        switch data.type {
        case .icon:
            let cell = tableView.dequeueReusableCell(withIdentifier: WeatherIconTableViewCell.identifier, for: indexPath) as! WeatherIconTableViewCell
            cell.configureCell(data)
            return cell
        case .text:
            let cell = tableView.dequeueReusableCell(withIdentifier: WeatherLabelTableViewCell.identifier, for: indexPath) as! WeatherLabelTableViewCell
            cell.configureCell(data)
            return cell
        }
        
    }
}
