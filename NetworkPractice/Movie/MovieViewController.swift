//
//  MovieViewController.swift
//  Network_0605
//
//  Created by 김정윤 on 6/5/24.
//

import UIKit
import SnapKit

class MovieViewController: UIViewController, setup {
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        let attributedPlaceholder = NSAttributedString(string: "검색할 날짜를 입력해주세요 ex)20201224", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        textField.attributedPlaceholder = attributedPlaceholder
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.borderStyle = .none
        textField.tintColor = .white
        return textField
    }()

    let border: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let searchBtn: UIButton = {
        let button = UIButton()
        button.setTitle("검색", for: .normal)
        button.titleLabel?.configureFont(size: 14)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        return button
    }()
    
    var list: [Movie] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    // MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
        setupHierarchy()
        setupConstraints()
        addTargets()
        fetchMovieData()
    }
    
    func setupHierarchy() {
        view.addSubview(searchTextField)
        view.addSubview(border)
        view.addSubview(tableView)
        view.addSubview(searchBtn)
    }
    
    func setupConstraints() {
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(35)
        }
        
        border.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom)
            $0.horizontalEdges.equalTo(searchTextField)
            $0.height.equalTo(2)
        }
        
        searchBtn.snp.makeConstraints {
            $0.leading.equalTo(searchTextField.snp.trailing).offset(8)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.bottom.equalTo(border.snp.bottom)
            $0.width.equalTo(view.snp.width).multipliedBy(0.1)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(border.snp.bottom)
            $0.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 50
        
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
    }
    
    func setupUI() {
        view.backgroundColor = .lightGray
        tableView.backgroundColor = .lightGray
    }
    
    func addTargets() {
        searchTextField.addTarget(self, action: #selector(textFieldDidEditingBegin), for: .editingDidBegin)
        searchTextField.addTarget(self, action: #selector(textFieldDidEditingEnd), for: .editingDidEnd)
        searchBtn.addTarget(self, action: #selector(searchBtnTapped), for: .touchUpInside)
    }
    
    // MARK: Action
    // 입력 시작하면 placeHolder 지우기
    @objc func textFieldDidEditingBegin(_ sender: UITextField) {
        searchTextField.placeholder = ""
    }
    
    // 입력이 끝났는데, 아무것도 입력하지 않았다면 placeHolder 다시 세팅하기
    @objc func textFieldDidEditingEnd(_ sender: UITextField) {
        if searchTextField.text!.isEmpty {
            searchTextField.placeholder = "검색할 날짜를 입력해주세요 ex)20201224"
        }
    }
    
    // MARK: Search(Network/DataCheck)
    @objc func searchBtnTapped(_ sender: UIButton) {
        view.endEditing(true)
        guard let date = searchTextField.text else { return }
        //  - 년도 / 월 / 일 제대로 입력했는지 확인하기
        do {
            let isValidate = try validateSearchDate(date: date)
            if isValidate {
                MovieUrl.movieUrl = date
                fetchMovieData()
            }
        } catch ValidateDateErrorCase.emptyString {
            showToast(ValidateDateErrorCase.emptyString.rawValue)
        } catch ValidateDateErrorCase.notNumber {
            showToast(ValidateDateErrorCase.notNumber.rawValue)
        } catch ValidateDateErrorCase.wrongLength {
            showToast(ValidateDateErrorCase.wrongLength.rawValue)
        } catch ValidateDateErrorCase.futureDate {
            showToast(ValidateDateErrorCase.futureDate.rawValue)
        } catch {
            showToast(ValidateDateErrorCase.emptyData.rawValue)
        }
    }
    
    // 검색 날짜 유효성 확인
    private func validateSearchDate(date: String) throws -> Bool {
        guard !date.isEmpty else {
            throw ValidateDateErrorCase.emptyString
        }
        guard Int(date) != nil else {
            throw ValidateDateErrorCase.notNumber
        }
        guard date.components(separatedBy: " ").joined().count == 8 else {
            throw ValidateDateErrorCase.wrongLength
        }
        guard checkDate(date) else {
            throw ValidateDateErrorCase.futureDate
        }
        return true
    }
    
    // 검색한 날짜가 미래인지 과거인지 판단 -> 과거면 true
    private func checkDate(_ date: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMdd"
        guard let inputDate = dateFormatter.date(from: date) else { return false }
        let yesterdayDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        let result: ComparisonResult = inputDate.compare(yesterdayDate!)
        // -1 과거 / 1 미래
        // - 미래 데이터는 존재하지 않으므로 false 처리로 사용자에게 데이터 입력값을 확인해달라는 토스트 띄우기
        // - 과거 데이터는 일단 검색 후, 받아오는 데이터가 비어있다면 검색결과 없다는 토스트 띄우기
        return result.rawValue == -1
    }
    
    // 입력한 날짜의 영화 데이터 가져와 보여주기
    private func fetchMovieData() {
        NetworkService.shared.fetchMovieData { result in
            let data = result.boxOfficeResult.dailyBoxOfficeList
            if data.isEmpty {
                self.showToast("검색결과가 없어요!")
            } else {
                self.list = data
            }
        }
    }
}

// MARK: TableViewExtension
extension MovieViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        let movieData = list[indexPath.row]
        cell.configureCell(movieData)
        return cell
    }
}
