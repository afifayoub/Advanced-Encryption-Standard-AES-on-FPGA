# 🔒 Coprocesseur Cryptographique AES-128 en VHDL

![VHDL](https://img.shields.io/badge/Language-VHDL-blue.svg)
![Standard](https://img.shields.io/badge/Standard-NIST_FIPS_197-success.svg)
![Status](https://img.shields.io/badge/Status-Verified_&_Synthesizable-brightgreen.svg)

## 📖 Résumé du Travail Effectué
Ce projet présente l'implémentation matérielle complète de l'algorithme de chiffrement symétrique **AES (Advanced Encryption Standard)** dans sa variante **128 bits**. Le développement a suivi une approche modulaire et itérative, optimisée pour minimiser l'empreinte logique sur FPGA :

* **`top.vhd` (Top-Level) :** Le chef d'orchestre. Il contient la FSM (IDLE, INIT, RUN, DONE) qui synchronise les 10 tours d'horloge et gère les registres de données et de clés.
* **`AES_Round.vhd` :** Le chemin de données principal (Datapath) qui exécute un tour complet d'AES. Il gère l'aiguillage spécifique du 10ème tour (désactivation du MixColumns).
* **`KeyExpansion.vhd` :** Générateur de clés "à la volée" (On-the-fly). Implémenté en logique purement combinatoire pour économiser la mémoire RAM/Registres du FPGA.
* **`SubBytes.vhd` :** Implémentation matérielle de la S-Box via une Look-Up Table (LUT) asynchrone de 256 octets.
* **`MixColumns.vhd` :** Unité de calcul mathématique effectuant les multiplications matricielles dans le corps de Galois $GF(2^8)$.

* **Document de référence :** [NIST FIPS 197 - Advanced Encryption Standard (AES)](https://nvlpubs.nist.gov/nistpubs/fips/nist.fips.197.pdf)




## 🧪 Validation et Simulation (NIST FIPS-197)

Le processeur a été rigoureusement testé sous **ModelSim** à l'aide d'un banc d'essai complet (`tb_top.vhd`). 


**Vecteur de test validé :**
* **Clé Secrète :** `2b 7e 15 16 28 ae d2 a6 ab f7 15 88 09 cf 4f 3c`
* **Texte en clair (Plaintext) :** `32 43 f6 a8 88 5a 30 8d 31 31 98 a2 e0 37 07 34`
* **Texte chiffré obtenu (Ciphertext) :** `39 25 84 1D 02 DC 09 FB DC 11 85 97 19 6A 0B 32` 

## 📂 Structure du Répertoire

```text
AES-128-VHDL-Core/
├── .gitignore              
├── README.md               
├── images/                 # Captures d'écran du resultat du testbench
│   └── resulat_tb.png
├── src/                    
│   ├── SubBytes.vhd
│   ├── MixColumns.vhd
│   ├── KeyExpansion.vhd
│   ├── AES_Round.vhd
│   └── top.vhd
└── sim/                    # Fichiers de simulation
    └── tb_top.vhd
    └── tb_sbox.vhd
    └── tb_mixcolumns.vhd
