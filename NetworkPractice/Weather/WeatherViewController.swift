//
//  WeatherViewController.swift
//  NetworkPractice
//
//  Created by 김정윤 on 6/6/24.
//

import UIKit
import Alamofire
import CoreLocation
import SnapKit

class WeatherViewController: UIViewController, setup {
    
    var list: [WeatherAndTemperature] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var locationManager = CLLocationManager()
    
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
    
    let addressLabel: UILabel = {
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
 
        locationManager.delegate = self
    }
    
    func setupHierarchy() {
        view.addSubview(backgroundImageView)
        view.addSubview(dateLabel)
        view.addSubview(locationImageView)
        view.addSubview(stackView)
        [locationImageView, addressLabel, shareBtn, refreshBtn].forEach {
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
    
    func checkDeviceLocationAuthorization() {
        DispatchQueue.global().async { // global은 다른 스레드로 분산처리할 때 사용 / main은 UI 처리 담당
            if CLLocationManager.locationServicesEnabled() {
                self.checkCurrentLocationAuthorization()
            } else {
                DispatchQueue.main.async { // alert는 global로 그려주려고하면 main에서 처리하라는 에러가 뜸..!
                    self.showSettingAlert()
                }
            }
        }
    }
    
    private func showSettingAlert() {
        let alert = UIAlertController(title: "위치 권한 설정", message: "위치 권한이 설정되어 있지않아요\n설정에서 위치 권한을 켜주세요!", preferredStyle: .alert)
        let goSettingAction = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(goSettingAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    private func fetchAddress(x: Double, y: Double) {
        let params: Parameters = ["x": x, "y": y]
        NetworkService.shared.fetch(NetworkCase: .kakaoAddress, params: params, headers: KakaoUrl.kakaoHeaders) { (result: AddressContainer) in
            if let address = result.documents.first?.address {
                self.addressLabel.text = address.customAddress
            } else {
                self.addressLabel.text = "현재 위치의 주소를 불러오는데 실패했습니다🥲"
            }
        }
    }
    
    func fetchWeather(x: Double, y: Double) {
        let params: Parameters = ["lon": x, "lat": y, "appid": APIKeys.weatherKey, "lang": "kr"]
        NetworkService.shared.fetch(NetworkCase: .openWeather, params: params, headers: nil) { (result: WeatherContainer) in
            self.list.removeAll()
            
            self.dateLabel.text = WeatherUrl.nowDateAndTime

            self.list.append(WeatherAndTemperature(data: result.weather.first!.desc))
            self.list.append(WeatherAndTemperature(data: result.main.descCelsiusTemp))
            self.list.append(WeatherAndTemperature(data: result.main.descHumidity))
            self.list.append(WeatherAndTemperature(data: "오늘도 좋은 하루되세요✨"))
            
            WeatherUrl.weatherIconName = result.weather.first!.icon
            self.list.append(WeatherAndTemperature(data: WeatherUrl.weatherIconUrl, type: .icon))
        }
    }
    
    func addTargets() {
        refreshBtn.addTarget(self, action: #selector(refreshBtnTapped), for: .touchUpInside)
    }
    
    // 새로고침하면 위치 정보 -> 날씨 정보 다시 받아오기
    @objc func refreshBtnTapped(_ sender: UIButton) {
        print("A")
        checkDeviceLocationAuthorization()
    }
    
    private func checkCurrentLocationAuthorization() {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined: // 권한 창 띄우기
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .denied: // 설정으로 보내기
            showSettingAlert()
        case .authorizedWhenInUse: // 위치 정보 받아오는 로직
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last?.coordinate else { return }
        fetchAddress(x: location.longitude, y: location.latitude)
        fetchWeather(x: location.longitude, y: location.latitude)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkDeviceLocationAuthorization()
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
