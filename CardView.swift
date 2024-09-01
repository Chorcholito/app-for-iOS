import UIKit

class CustomCardView: UIView {

    // Elementos de la tarjeta
    private let nombreLabel: UILabel = {
        let label = UILabel()
        label.text = "Nombre del dispositivo"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let settingsButton: UIButton = {
        let button = UIButton()
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "gearshape"), for: .normal)
        } else {
            // Fallback on earlier versions
        } // Icono de ajustes
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let temperaturaLabel: UILabel = {
        let label = UILabel()
        label.text = "50"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let temperaturaUnidadLabel: UILabel = {
        let label = UILabel()
        label.text = "°C"
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let humedadLabel: UILabel = {
        let label = UILabel()
        label.text = "50"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let humedadUnidadLabel: UILabel = {
        let label = UILabel()
        label.text = "%"
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let luminosidadLabel: UILabel = {
        let label = UILabel()
        label.text = "10"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let luminosidadUnidadLabel: UILabel = {
        let label = UILabel()
        label.text = "lux"
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let sensor1Label: UILabel = {
        let label = UILabel()
        label.text = "Sensor 1"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let sensor1SettingsButton: UIButton = {
        let button = UIButton()
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "gearshape"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let sensor2Label: UILabel = {
        let label = UILabel()
        label.text = "Sensor 2"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let sensor2SettingsButton: UIButton = {
        let button = UIButton()
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "gearshape"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let humedadSensor1Label: UILabel = {
        let label = UILabel()
        label.text = "80"
        label.font = UIFont.systemFont(ofSize: 80, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let humedadSensor1UnidadLabel: UILabel = {
        let label = UILabel()
        label.text = "%"
        label.font = UIFont.systemFont(ofSize: 50, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let humedadSensor2Label: UILabel = {
        let label = UILabel()
        label.text = "70"
        label.font = UIFont.systemFont(ofSize: 80, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let humedadSensor2UnidadLabel: UILabel = {
        let label = UILabel()
        label.text = "%"
        label.font = UIFont.systemFont(ofSize: 50, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let regarButton1: UIButton = {
        let button = UIButton()
        button.setTitle("Regar", for: .normal)
        button.backgroundColor = UIColor(red: 0.63, green: 0.40, blue: 0.28, alpha: 1.0) // Color #A16648
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let regarButton2: UIButton = {
        let button = UIButton()
        button.setTitle("Regar", for: .normal)
        button.backgroundColor = UIColor(red: 0.63, green: 0.40, blue: 0.28, alpha: 1.0) // Color #A16648
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        // Establece las propiedades de la tarjeta
        backgroundColor = UIColor.white
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4

        // Añade todos los subviews
        addSubview(nombreLabel)
        addSubview(settingsButton)
        addSubview(temperaturaLabel)
        addSubview(temperaturaUnidadLabel)
        addSubview(humedadLabel)
        addSubview(humedadUnidadLabel)
        addSubview(luminosidadLabel)
        addSubview(luminosidadUnidadLabel)
        addSubview(sensor1Label)
        addSubview(sensor1SettingsButton)
        addSubview(sensor2Label)
        addSubview(sensor2SettingsButton)
        addSubview(humedadSensor1Label)
        addSubview(humedadSensor1UnidadLabel)
        addSubview(humedadSensor2Label)
        addSubview(humedadSensor2UnidadLabel)
        addSubview(regarButton1)
        addSubview(regarButton2)

        // Configuración de Constraints (Auto Layout)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Constraints para nombreLabel
            nombreLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            nombreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),

            // Constraints para settingsButton
            settingsButton.centerYAnchor.constraint(equalTo: nombreLabel.centerYAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            settingsButton.widthAnchor.constraint(equalToConstant: 30),
            settingsButton.heightAnchor.constraint(equalToConstant: 30),

            // Bloque de temperatura
            temperaturaLabel.topAnchor.constraint(equalTo: nombreLabel.bottomAnchor, constant: 10),
            temperaturaLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            temperaturaUnidadLabel.centerYAnchor.constraint(equalTo: temperaturaLabel.centerYAnchor),
            temperaturaUnidadLabel.leadingAnchor.constraint(equalTo: temperaturaLabel.trailingAnchor, constant: 5),

            // Bloque de humedad
            humedadLabel.centerYAnchor.constraint(equalTo: temperaturaLabel.centerYAnchor),
            humedadLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -30),
            humedadUnidadLabel.centerYAnchor.constraint(equalTo: humedadLabel.centerYAnchor),
            humedadUnidadLabel.leadingAnchor.constraint(equalTo: humedadLabel.trailingAnchor, constant: 5),

            // Bloque de luminosidad
            luminosidadLabel.centerYAnchor.constraint(equalTo: temperaturaLabel.centerYAnchor),
            luminosidadLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            luminosidadUnidadLabel.centerYAnchor.constraint(equalTo: luminosidadLabel.centerYAnchor),
            luminosidadUnidadLabel.leadingAnchor.constraint(equalTo: luminosidadLabel.trailingAnchor, constant: 5),

            // Bloque de sensor 1
            sensor1Label.topAnchor.constraint(equalTo: temperaturaLabel.bottomAnchor, constant: 20),
            sensor1Label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            sensor1SettingsButton.centerYAnchor.constraint(equalTo: sensor1Label.centerYAnchor),
            sensor1SettingsButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -20),
            sensor1SettingsButton.widthAnchor.constraint(equalToConstant: 30),
            sensor1SettingsButton.heightAnchor.constraint(equalToConstant: 30),

            // Bloque de sensor 2
            sensor2Label.centerYAnchor.constraint(equalTo: sensor1Label.centerYAnchor),
            sensor2Label.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 20),
            sensor2SettingsButton.centerYAnchor.constraint(equalTo: sensor2Label.centerYAnchor),
            sensor2SettingsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            sensor2SettingsButton.widthAnchor.constraint(equalToConstant: 30),
            sensor2SettingsButton.heightAnchor.constraint(equalToConstant: 30),

            // Bloque de humedad sensor 1
            humedadSensor1Label.topAnchor.constraint(equalTo: sensor1Label.bottomAnchor, constant: 20),
            humedadSensor1Label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            humedadSensor1UnidadLabel.centerYAnchor.constraint(equalTo: humedadSensor1Label.centerYAnchor),
            humedadSensor1UnidadLabel.leadingAnchor.constraint(equalTo: humedadSensor1Label.trailingAnchor, constant: 5),

            // Bloque de humedad sensor 2
            humedadSensor2Label.centerYAnchor.constraint(equalTo: humedadSensor1Label.centerYAnchor),
            humedadSensor2Label.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 20),
            humedadSensor2UnidadLabel.centerYAnchor.constraint(equalTo: humedadSensor2Label.centerYAnchor),
            humedadSensor2UnidadLabel.leadingAnchor.constraint(equalTo: humedadSensor2Label.trailingAnchor, constant: 5),

            // Botón de regar 1
            regarButton1.topAnchor.constraint(equalTo: humedadSensor1Label.bottomAnchor, constant: 20),
            regarButton1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            regarButton1.widthAnchor.constraint(equalToConstant: 100),

            // Botón de regar 2
            regarButton2.topAnchor.constraint(equalTo: humedadSensor2Label.bottomAnchor, constant: 20),
            regarButton2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            regarButton2.widthAnchor.constraint(equalToConstant: 100),
            regarButton2.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
