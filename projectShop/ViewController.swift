//
//  ViewController.swift
//  projectShop
//
//  Created by Кирилл  on 20.10.2024.
//

import UIKit

class ViewController: UIViewController {
    
    private var promocodeSwitches: [UISwitch] = []
    private var activePromocodes: [Order.Promocode] = []
    private var order: Order?
    private var hidePromoCodesButton: UIButton!
    private var totalLabel: UILabel!
    private var discountLabel: UILabel!
    private var finalPriceLabel: UILabel!
    private var promocodeSummaryLabel: UILabel!
    private var paymentMethodLabel: UILabel!
    private var buttons: [UIButton] = [] // Серые кнопки для скрытия
    private var maxActivePromocodes = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Инициализация интерфейса
        setupUI()
        
        // Пример инициализации заказа
        let sampleOrder = Order(
            screenTitle: "Ваш заказ",
            promocodes: [
                Order.Promocode(title: "ВСЕМ10", percent: 10, endDate: Date(timeIntervalSinceNow: 864000), info: "Скидка 10%", active: false),
                Order.Promocode(title: "СУПЕР", percent: 20, endDate: Date(timeIntervalSinceNow: 1728000), info: "Скидка 20%", active: false),
                Order.Promocode(title: "ПОДАРОК", percent: 30, endDate: Date(timeIntervalSinceNow: 432000), info: "Скидка 30%", active: false),
                Order.Promocode(title: "ВЫГОДА", percent: 40, endDate: Date(timeIntervalSinceNow: 86400), info: "Скидка 40%", active: false),
                Order.Promocode(title: "КУДА ДЕШЕВЛЕ", percent: 50, endDate: Date(timeIntervalSinceNow: 172800), info: "Скидка 50%", active: false)
            ],
            products: [
                Order.Product(price: 500, title: "Товар 1"),
                Order.Product(price: 300, title: "Товар 2")
            ],
            paymentDiscount: 5,
            baseDiscount: 10
        )
        
        showOrder(order: sampleOrder)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // ScrollView по всему экрану
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        // Верхний UIView с лейблом «Оформление заказа»
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headerView)
        
        let orderLabel = UILabel()
        orderLabel.text = "Оформление заказа"
        orderLabel.font = UIFont(name: "Roboto", size: 16)
        orderLabel.textAlignment = .center
        orderLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(orderLabel)
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            orderLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            orderLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -0.5)
        ])
        
        // Добавляем серую полосу под header
        let separatorView = UIView()
        separatorView.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.9568627477, blue: 0.9568627477, alpha: 1)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        // Серый фон для блока с ценами и кнопкой оформления
        let grayBackgroundView = UIView()
        grayBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(grayBackgroundView)
        
        NSLayoutConstraint.activate([
            grayBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            grayBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            grayBackgroundView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 20),
            grayBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        
        // Лейбл «Промокоды» и поясняющий текст
        let promocodeLabel = UILabel()
        promocodeLabel.text = "Промокоды"
        promocodeLabel.font = UIFont(name: "Roboto", size: 24)
        promocodeLabel.numberOfLines = 0
        promocodeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(promocodeLabel)
        
        let promocodeInfoLabel = UILabel()
        promocodeInfoLabel.text = "На один товар можно применить только один промокод"
        promocodeInfoLabel.font = UIFont(name: "Roboto", size: 14)
        promocodeInfoLabel.textColor = .gray
        promocodeInfoLabel.numberOfLines = 0
        promocodeInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(promocodeInfoLabel)
        
        NSLayoutConstraint.activate([
            promocodeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            promocodeLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 20),
            
            promocodeInfoLabel.leadingAnchor.constraint(equalTo: promocodeLabel.leadingAnchor),
            promocodeInfoLabel.topAnchor.constraint(equalTo: promocodeLabel.bottomAnchor, constant: 5),
            promocodeInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        // Кнопка «Применить промокод» с иконкой слева
        let applyPromoButton = UIButton(type: .system)
        applyPromoButton.setTitle("Применить промокод", for: .normal)
        applyPromoButton.setTitleColor(#colorLiteral(red: 0.9985738397, green: 0.2762064636, blue: 0.06291877478, alpha: 1), for: .normal)
        applyPromoButton.backgroundColor = #colorLiteral(red: 1, green: 0.922723949, blue: 0.9025968909, alpha: 1)
        applyPromoButton.layer.cornerRadius = 12
        applyPromoButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(applyPromoButton)
        
        let imageView = UIImageView(image: UIImage(named: "promocode"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        applyPromoButton.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            applyPromoButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            applyPromoButton.topAnchor.constraint(equalTo: promocodeInfoLabel.bottomAnchor, constant: 20),
            applyPromoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            applyPromoButton.heightAnchor.constraint(equalToConstant: 54),
            
            imageView.leadingAnchor.constraint(equalTo: applyPromoButton.leadingAnchor, constant: 90),
            imageView.centerYAnchor.constraint(equalTo: applyPromoButton.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        // Создаем 5 серых кнопок с белыми полукруглыми элементами по бокам
        var previousButton: UIButton? = nil
        for i in 0..<5 {
            let button = UIButton(type: .system)
            button.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.9568627477, blue: 0.9568627477, alpha: 1)
            button.layer.cornerRadius = 12
            button.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(button)
            buttons.append(button) // Добавляем кнопки в массив
            
            // Добавляем полукруги по бокам
            let leftCircle = UIView()
            leftCircle.backgroundColor = .white
            leftCircle.layer.cornerRadius = 8
            leftCircle.translatesAutoresizingMaskIntoConstraints = false
            button.addSubview(leftCircle)
            
            let rightCircle = UIView()
            rightCircle.backgroundColor = .white
            rightCircle.layer.cornerRadius = 8
            rightCircle.translatesAutoresizingMaskIntoConstraints = false
            button.addSubview(rightCircle)
            
            // Три лейбла для каждой кнопки
            let label1 = UILabel()
            label1.translatesAutoresizingMaskIntoConstraints = false
            button.addSubview(label1)
 
            let label2 = UILabel()
            label2.translatesAutoresizingMaskIntoConstraints = false
            button.addSubview(label2)
 
            let label3 = UILabel()
            label3.translatesAutoresizingMaskIntoConstraints = false
            button.addSubview(label3)
            
            let promocodeSwitch = UISwitch()
            promocodeSwitch.translatesAutoresizingMaskIntoConstraints = false
            promocodeSwitch.tag = i
            promocodeSwitch.onTintColor = #colorLiteral(red: 0.9985738397, green: 0.2762064636, blue: 0.06291877478, alpha: 1)
            promocodeSwitch.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
            button.addSubview(promocodeSwitch)
            promocodeSwitches.append(promocodeSwitch)
            
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                button.heightAnchor.constraint(equalToConstant: 100),
                
                leftCircle.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: -8),
                leftCircle.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                leftCircle.widthAnchor.constraint(equalToConstant: 16),
                leftCircle.heightAnchor.constraint(equalToConstant: 16),
                
                rightCircle.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: 8),
                rightCircle.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                rightCircle.widthAnchor.constraint(equalToConstant: 16),
                rightCircle.heightAnchor.constraint(equalToConstant: 16),
                
                label1.topAnchor.constraint(equalTo: button.topAnchor, constant: 10),
                label1.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 40),
                
                label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 5),
                label2.leadingAnchor.constraint(equalTo: label1.leadingAnchor),
                
                label3.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 5),
                label3.leadingAnchor.constraint(equalTo: label1.leadingAnchor),
                
                promocodeSwitch.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                promocodeSwitch.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -20)
            ])
            
            if let previousButton = previousButton {
                NSLayoutConstraint.activate([
                    button.topAnchor.constraint(equalTo: previousButton.bottomAnchor, constant: 20)
                ])
            } else {
                button.topAnchor.constraint(equalTo: applyPromoButton.bottomAnchor, constant: 20).isActive = true
            }
            
            previousButton = button
        }
        // Кнопка "Скрыть промокоды"
        hidePromoCodesButton = UIButton(type: .system)
        hidePromoCodesButton.setTitle("Скрыть промокоды", for: .normal)
        hidePromoCodesButton.titleLabel?.font = UIFont(name: "Roboto", size: 16)
        hidePromoCodesButton.setTitleColor(#colorLiteral(red: 0.9985738397, green: 0.2762064636, blue: 0.06291877478, alpha: 1), for: .normal)
        hidePromoCodesButton.translatesAutoresizingMaskIntoConstraints = false
        hidePromoCodesButton.addTarget(self, action: #selector(hidePromoCodes), for: .touchUpInside)
        contentView.addSubview(hidePromoCodesButton)

        NSLayoutConstraint.activate([
            hidePromoCodesButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            hidePromoCodesButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            hidePromoCodesButton.topAnchor.constraint(equalTo: previousButton!.bottomAnchor, constant: 20), // После последней кнопки
            hidePromoCodesButton.heightAnchor.constraint(equalToConstant: 54)
        ])
        
        // Лейблы "Промокоды", "Способ оплаты" и "Размер скидки"
        promocodeSummaryLabel = UILabel()
        promocodeSummaryLabel.text = "Активированные промокоды: 0"
        promocodeSummaryLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(promocodeSummaryLabel)
        
        paymentMethodLabel = UILabel()
        paymentMethodLabel.text = "Способ оплаты: Не выбран"
        paymentMethodLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(paymentMethodLabel)
        
        discountLabel = UILabel()
        discountLabel.text = "Размер скидки: 0₽"
        discountLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(discountLabel)
        
        // Кнопка "Оформить заказ"
        let checkoutButton = UIButton(type: .system)
        checkoutButton.setTitle("Оформить заказ", for: .normal)
        checkoutButton.setTitleColor(.white, for: .normal)
        checkoutButton.backgroundColor = .red
        checkoutButton.layer.cornerRadius = 12
        checkoutButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(checkoutButton)
        
        NSLayoutConstraint.activate([
            promocodeSummaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            promocodeSummaryLabel.topAnchor.constraint(equalTo: hidePromoCodesButton.bottomAnchor, constant: 20),
            
            paymentMethodLabel.leadingAnchor.constraint(equalTo: promocodeSummaryLabel.leadingAnchor),
            paymentMethodLabel.topAnchor.constraint(equalTo: promocodeSummaryLabel.bottomAnchor, constant: 10),
            
            discountLabel.leadingAnchor.constraint(equalTo: promocodeSummaryLabel.leadingAnchor),
            discountLabel.topAnchor.constraint(equalTo: paymentMethodLabel.bottomAnchor, constant: 10),
            
            checkoutButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            checkoutButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            checkoutButton.topAnchor.constraint(equalTo: discountLabel.bottomAnchor, constant: 20),
            checkoutButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            checkoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Лейбл с текстом "нажимая кнопку «Оформить заказ», Вы соглашаетесь с условием оферты"
        let disclaimerLabel = UILabel()
        disclaimerLabel.numberOfLines = 0
        disclaimerLabel.textAlignment = .center
        disclaimerLabel.text = """
        Нажимая кнопку «Оформить заказ»,
        Вы соглашаетесь с условием оферты
        """
        disclaimerLabel.translatesAutoresizingMaskIntoConstraints = false
        grayBackgroundView.addSubview(disclaimerLabel)
        
        NSLayoutConstraint.activate([
            disclaimerLabel.topAnchor.constraint(equalTo: checkoutButton.bottomAnchor, constant: 5),
            disclaimerLabel.centerXAnchor.constraint(equalTo: grayBackgroundView.centerXAnchor),
            disclaimerLabel.leadingAnchor.constraint(equalTo: grayBackgroundView.leadingAnchor, constant: 20),
            disclaimerLabel.trailingAnchor.constraint(equalTo: grayBackgroundView.trailingAnchor, constant: -20)
        ])

        
    }
    private func showOrder(order: Order) {
        self.order = order
        promocodeSummaryLabel.text = "Активированные промокоды: \(order.promocodes.filter { $0.active }.count)"
        paymentMethodLabel.text = "Способ оплаты: Банковская карта"
        
        // Отображаем общую цену за товары
        //totalLabel.text = "Цена за товары: \(order.products.map { $0.price }.reduce(0, +))₽"
        
        // Отображаем размер скидки
        discountLabel.text = "Размер скидки: \(calculateDiscount())₽"
        
        // Отображаем итоговую стоимость
        //finalPriceLabel.text = "Итоговая стоимость: \(calculateFinalPrice())₽"
        
        // Заполнение кнопок данными из промокодов
        for (i, promocode) in order.promocodes.enumerated() {
            if i < buttons.count {
                let button = buttons[i]
                let labels = button.subviews.compactMap { $0 as? UILabel }
                
                // Лейбл 1: Название промокода
                labels[0].text = promocode.title
                
                // Лейбл 2: Размер скидки
                labels[1].text = "Размер скидки: \(promocode.percent)%"
                
                // Лейбл 3: Дата окончания действия промокода
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
                if let endDate = promocode.endDate {
                    labels[2].text = "До: \(dateFormatter.string(from: endDate))"
                } else {
                    labels[2].text = nil
                }
            }
        }
    }
    
    private func calculateDiscount() -> Double {
        guard let order = order else { return 0 }
        return order.promocodes.filter { $0.active }.map { Double($0.percent) }.reduce(0, +)
    }
    
    private func calculateFinalPrice() -> Double {
        guard let order = order else { return 0 }
        let totalPrice = order.products.map { $0.price }.reduce(0, +)
        let discount = calculateDiscount()
        return totalPrice - (totalPrice * (discount / 100))
    }
    
    @objc private func switchChanged(_ sender: UISwitch) {
        guard var order = order else { return }
        
        // Ограничение на количество активированных промокодов
        if sender.isOn && activePromocodes.count >= maxActivePromocodes {
            sender.setOn(false, animated: true)
            return
        }
        
        let promocodeIndex = sender.tag
        let promocode = order.promocodes[promocodeIndex]        
        if sender.isOn {
            activePromocodes.append(promocode)
        } else {
            activePromocodes.removeAll { $0.title == promocode.title }
        }
        
        // Обновляем заказ с изменёнными промокодами
        order.promocodes[promocodeIndex] = promocode
        showOrder(order: order)
    }
    @objc private func hidePromoCodes() {
          for button in buttons {
              if button.isHidden == false{
                  button.isHidden = true
                  hidePromoCodesButton.setTitle("Открыть промокоды", for: .normal)
              }else{
                  button.isHidden = false
                  hidePromoCodesButton.setTitle("Скрыть промокоды", for: .normal)
              }
          }
      }

}
