//
//  LottoViewController.swift
//  NetworkPractice
//
//  Created by 김정윤 on 6/5/24.
//

import UIKit
import Alamofire
import SnapKit

class LottoViewController: UIViewController, setup {
    
    var list: [String] = Lotto.LottoDates
    
    let pickerView = UIPickerView()
    
    let drwNotextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.4
        textField.layer.cornerRadius = Layer.cornerRadius
        textField.tintColor = .clear
        textField.textAlignment = .center
        return textField
    }()
    
    let guideLabel: UILabel = {
        let label = UILabel()
        label.configureFont("당첨번호 안내", size: 14)
        return label
    }()
    
    let drwNoLabel: UILabel = {
        let label = UILabel()
        label.configureFont(size: 14)
        label.textColor = .lightGray
        return label
    }()
    
    let border: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    let resultNoLabel: UILabel = {
        let label = UILabel()
        label.configureFont(size: 18, weight: .bold)
        label.textColor = .systemYellow
        return label
    }()
    
    let resultLabel: UILabel = {
        let label = UILabel()
        label.configureFont("당첨결과", size: 18)
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    let lottoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        return stackView
    }()
    
    var lottoNoLabels = (0...7).map { _ in UILabel() }
    
    let bnusLabel: UILabel = {
        let label = UILabel()
        label.configureFont("보너스", size: 14)
        label.textColor = .lightGray
        return label
    }()


    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupConstraints()
        setupPickerView()
        setupUI()
        network()
    }
    
    func setupHierarchy() {
        view.addSubview(drwNotextField)
        view.addSubview(guideLabel)
        view.addSubview(drwNoLabel)
        view.addSubview(border)
        view.addSubview(stackView)
        [resultNoLabel, resultLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        view.addSubview(lottoStackView)
        lottoNoLabels.forEach {
            lottoStackView.addArrangedSubview($0)
        }
        view.addSubview(bnusLabel)
    }
    
    func setupConstraints() {
        drwNotextField.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        
        guideLabel.snp.makeConstraints {
            $0.leading.equalTo(drwNotextField.snp.leading)
            $0.top.equalTo(drwNotextField.snp.bottom).offset(20)
        }
        
        drwNoLabel.snp.makeConstraints {
            $0.trailing.equalTo(drwNotextField.snp.trailing)
            $0.top.equalTo(drwNotextField.snp.bottom).offset(20)
        }
        
        border.snp.makeConstraints {
            $0.horizontalEdges.equalTo(drwNotextField)
            $0.height.equalTo(1)
            $0.top.equalTo(guideLabel.snp.bottom).offset(12)
        }
        
        stackView.snp.makeConstraints {
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(border).offset(24)
        }
        
        lottoStackView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(24)
            $0.height.equalTo(40)
            $0.centerX.equalTo(view)
        }
    
        for label in lottoNoLabels {
            label.snp.makeConstraints {
                $0.width.equalTo(lottoStackView.snp.height)
            }
        }
        
        bnusLabel.snp.makeConstraints {
            $0.trailing.equalTo(lottoStackView.snp.trailing)
            $0.top.equalTo(lottoStackView.snp.bottom).offset(4)
        }
    }
    
    func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        drwNotextField.inputView = pickerView
        drwNotextField.text = list.first // 화면 진입 시, 최신 로또 회차 띄우기
        
        configureLottoLabels()
    }
    
    func network() {
        NetworkService.shared.fetch(NetworkCase: .lotto, params: nil, headers: nil) { (result: Lotto) in
            self.configureResult(result)
        }
    }
    
    private func configureResult(_ data: Lotto) {
        // 7번째 글자는 + 로 입력되어있어야하고 lottoNoLabels의 인덱스와 꼬이지 않게 7번째는 nil처리
        let lottoData: [Int?] = [data.drwtNo1, data.drwtNo2, data.drwtNo3, data.drwtNo4, data.drwtNo5, data.drwtNo6, nil, data.bnusNo]
        for (i, drwtNo) in lottoData.enumerated() {
            if let drwtNo = drwtNo {
                lottoNoLabels[i].backgroundColor = getLottoBallColors(drwtNo)
                lottoNoLabels[i].text = "\(drwtNo)"
            }
        }
        resultNoLabel.text = "\(data.resultDesc)"
        drwNoLabel.text = "\(data.drwNoDesc)"
        resultLabel.text = "당첨번호 안내"
    }
    
    private func configureEmptyResult() {
        configureLottoLabels()
        drwNoLabel.text = ""
        resultNoLabel.text = ""
        resultLabel.text = "아직 집계된 결과가 없습니다"
    }
    
    // 0번째~5번째, 7번째 데이터는 로또 번호
    // 6번째는 +
    private func configureLottoLabels() {
        for i in 0..<lottoNoLabels.count {
            switch i {
            case 6: lottoNoLabels[i].configureLottoLabel(BallType.plus)
            default: lottoNoLabels[i].configureLottoLabel()
            }
        }
    }
    
    // 각 로또 번호에 맞춰서 색깔 다르게
    private func getLottoBallColors(_ drwtNo: Int) -> UIColor {
        switch drwtNo {
        case 1...10: return .systemYellow
        case 11...20: return .systemBlue
        case 21...30: return .systemRed
        case 31...40: return .lightGray
        case 41...45: return .systemGreen
        default: return .systemGray
        }
    }
    
    // 뷰 터치해서 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


// MARK: PickerViewExtension
extension LottoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // 컴포넌트 개수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // 컴포넌트 내 행 개수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    // 컴포넌트 내 행의 제목
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }
    
    // 행 선택했을 때
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        drwNotextField.text = list[row]
        LottoUrl.drwNo = list[row]
        network()
    }
}
