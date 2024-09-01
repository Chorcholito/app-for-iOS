import UIKit
import CoreData


class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configurar la vista principal
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
            self.view.backgroundColor = .white
        }

        // Crear un contenedor de tarjetas usando UIScrollView para permitir el desplazamiento si hay muchas tarjetas
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)

        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        } else {
            // Fallback on earlier versions
        }

        // Contenedor para las tarjetas dentro del scrollView
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40) // Ancho constante
        ])

        // Obtener todas las tarjetas de la base de datos y crear una vista para cada una
        let cards = DatabaseManager.sharedManager().fetchAllCards()

        for card in cards {
            let cardView = CustomCardView()

            if let nombreCard = card.value(forKey: "nombreCard") as? String {
                cardView.nombreLabel.text = nombreCard
            } else {
                cardView.nombreLabel.text = "--"
            }

            if let tipoCard = card.value(forKey: "tipoCard") as? String {
                cardView.tipoCardLabel.text = tipoCard // Suponiendo que tienes un label para tipoCard
            } else {
                cardView.tipoCardLabel.text = "--"
            }

            // Configurar otros elementos de la tarjeta aquí...

            stackView.addArrangedSubview(cardView)

            NSLayoutConstraint.activate([
                cardView.heightAnchor.constraint(equalToConstant: 300)
            ])
        }
    }
}
