# Proyecto_Optimizaci-NII

Este repositorio está dedicado al proyecto de la UEA de Optimización II en la Universidad Autónoma Metropolitana (UAM) Cuajimalpa.

El proyecto fue desarrollado utilizando Julia (implementaciones de ACO y BH) y C++ (implementación de SA). Para garantizar un funcionamiento correcto, es esencial contar con una instalación funcional de un compilador de C++ y la versión más reciente del intérprete de Julia.

## Instalación de Julia

Puedes descargar Julia desde el siguiente enlace: [Descargar Julia](https://julialang.org/downloads/).

## Instalación de paquetes en Julia

Para instalar los paquetes necesarios, abre el REPL de Julia y ejecuta los siguientes comandos:

```julia
using Pkg
Pkg.add("Random")
Pkg.add("Distributions")
```

## Instalación de GCC

Para instalar GCC (GNU Compiler Collection), puedes seguir las instrucciones según tu sistema operativo:

### En Windows

1. **Descargar MinGW**: Ve al sitio web de MinGW: [MinGW Installation](https://sourceforge.net/projects/mingw/).
2. **Instalar**: Sigue las instrucciones del instalador. Asegúrate de seleccionar los componentes de **C++ Compiler**.
3. **Agregar a PATH**: Durante la instalación, asegúrate de añadir MinGW a la variable de entorno PATH para poder usar `gcc` desde la línea de comandos.

### En macOS

Puedes instalar GCC utilizando Homebrew. Abre la terminal y ejecuta:

```bash
brew install gcc
```

### En Linux

Para instalar GCC en distribuciones basadas en Debian (como Ubuntu), abre la terminal y ejecuta:

```bash
sudo apt update
sudo apt install build-essential
```

## Referencias Bibliográficas

- Matayoshi, M., Nakamura, M., & Miyagi, H. (2004). A genetic algorithm with the improved 2-opt method for quadratic assignment problem. *IEEJ Transactions on Electronics, Information and Systems, 124*(9), 1896-1906. https://doi.org/10.1541/ieejeiss.124.1896

- Croes, G. A. (1958). A method for solving traveling-salesman problems. *Operations Research, 6*(6), 791-812.

- Burkard, R. E. (1984). Quadratic assignment problems. *European Journal of Operational Research, 15*(3), 283-289.

- GeeksforGeeks. (2023, 17 de noviembre). Quadratic assignment problem (QAP). https://www.geeksforgeeks.org/quadratic-assignment-problem-qap/

- Ministerio de Educación Superior de Malasia para Fundamental Research Grant Scheme. "Enhanced Differential Evolution Algorithm by Balancing the Exploitation and Exploration Search Behavior for Data Clustering."

- Kirkpatrick, S.; Gelatt, C. D.; Vecchi, M. P. (1983). «Optimization by Simulated Annealing». *Science*, 220(4598), 671-680.

- Deeb, H., Sarangi, A., Mishra, D., & Sarangi, S. K. (2022). Improved Black Hole optimization algorithm for data clustering. *Journal of King Saud University - Computer and Information Sciences, 34*(8), 5020–5029. https://doi.org/10.1016/j.jksuci.2020.12.013
