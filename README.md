
# Monitoreo Sísmico 📡🌍

Sistema de monitoreo sísmico usando **Raspberry Pi Zero 2W** o **Orange Pi Zero 3** con sensor **MPU6050**.

---

## 🚀 Instalación automática

```bash
curl -fsSL https://raw.githubusercontent.com/akthanon/monitoreo_sismico/refs/heads/main/autoinstall.sh | sh
```

---

## 🍓 Raspberry Pi Zero 2W

### Conexiones MPU6050 ↔ Raspberry Pi

| MPU6050 Pin | Raspberry Pi Pin        |
| ----------- | ----------------------- |
| VCC         | 3.3V o 5V (Pin 1 o 2/4) |
| GND         | GND (Pin 6)             |
| SDA         | GPIO 2 (Pin 3)          |
| SCL         | GPIO 3 (Pin 5)          |

### Header J8 (Distribución de pines)

```
 J8:
    3V3  (1) (2)  5V
  GPIO2  (3) (4)  5V
  GPIO3  (5) (6)  GND
  GPIO4  (7) (8)  GPIO14
    GND  (9) (10) GPIO15
 GPIO17 (11) (12) GPIO18
 GPIO27 (13) (14) GND
 GPIO22 (15) (16) GPIO23
    3V3 (17) (18) GPIO24
 GPIO10 (19) (20) GND
  GPIO9 (21) (22) GPIO25
 GPIO11 (23) (24) GPIO8
    GND (25) (26) GPIO7
  GPIO0 (27) (28) GPIO1
  GPIO5 (29) (30) GND
  GPIO6 (31) (32) GPIO12
 GPIO13 (33) (34) GND
 GPIO19 (35) (36) GPIO16
 GPIO26 (37) (38) GPIO20
    GND (39) (40) GPIO21
```

---

## 🍊 Orange Pi Zero 3
# Importante:

Debido a que Orange Pi Zero utiliza la interfáz i2c3 en lugar de la i2c1 se tiene que editar el codigo

Editar *sensor.py* 
```bash
bus = smbus.SMBus(1) > bus = smbus.SMBus(3)
```

### Habilitar I2C-3

```bash
sudo orangepi-config
# Navegar a:
> System
> Hardware
> ph-i2c3
```



### Conexiones MPU6050 ↔ Orange Pi

| Señal | Pin físico | Función GPIO    |
| ----- | ---------- | --------------- |
| SDA   | Pin 3      | PA17 / TWI1-SDA |
| SCL   | Pin 5      | PA18 / TWI1-SCK |
| GND   | Pin 6      | GND             |
| 3.3V  | Pin 1      | 3.3V Power      |

### Mapa de pines (I2C3 resaltado)

```
 +------+-----+----------+--------+---+   H616   +---+--------+----------+-----+------+
 | GPIO | wPi |   Name   |  Mode  | V | Physical | V |  Mode  | Name     | wPi | GPIO |
 +------+-----+----------+--------+---+----++----+---+--------+----------+-----+------+
 |      |     |     3.3V |        |   |  1 || 2  |   |        | 5V       |     |      |
 |  229 |   0 |    SDA.3 |   ALT5 | 0 |  3 || 4  |   |        | 5V       |     |      |
 |  228 |   1 |    SCL.3 |   ALT5 | 0 |  5 || 6  |   |        | GND      |     |      |
 |   73 |   2 |      PC9 |    OFF | 0 |  7 || 8  | 0 | OFF    | TXD.5    | 3   | 226  |
 |      |     |      GND |        |   |  9 || 10 | 0 | OFF    | RXD.5    | 4   | 227  |
 |   70 |   5 |      PC6 |   ALT5 | 0 | 11 || 12 | 0 | OFF    | PC11     | 6   | 75   |
 |   69 |   7 |      PC5 |   ALT5 | 0 | 13 || 14 |   |        | GND      |     |      |
 |   72 |   8 |      PC8 |    OFF | 0 | 15 || 16 | 0 | OFF    | PC15     | 9   | 79   |
 |      |     |     3.3V |        |   | 17 || 18 | 0 | OFF    | PC14     | 10  | 78   |
 |  231 |  11 |   MOSI.1 |    OFF | 0 | 19 || 20 |   |        | GND      |     |      |
 |  232 |  12 |   MISO.1 |    OFF | 0 | 21 || 22 | 0 | OFF    | PC7      | 13  | 71   |
 |  230 |  14 |   SCLK.1 |    OFF | 0 | 23 || 24 | 0 | OFF    | CE.1     | 15  | 233  |
 |      |     |      GND |        |   | 25 || 26 | 0 | OFF    | PC10     | 16  | 74   |
 |   65 |  17 |      PC1 |    OFF | 0 | 27 || 28 | 0 | ALT2   | PWM3     | 21  | 224  |
 |  272 |  18 |     PI16 |   ALT2 | 0 | 29 || 30 | 0 | ALT2   | PWM4     | 22  | 225  |
 |  262 |  19 |      PI6 |    OFF | 0 | 31 || 32 |   |        |          |     |      |
 |  234 |  20 |     PH10 |   ALT3 | 0 | 33 || 34 |   |        |          |     |      |
 +------+-----+----------+--------+---+----++----+---+--------+----------+-----+------+
```

---

📎 Más detalles e instrucciones en la [Documentación de Orange Pi](http://www.orangepi.org/orangepiwiki/index.php/Orange_Pi_Zero_3)
