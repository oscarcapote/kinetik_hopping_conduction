# kinetik_hopping_conduction

El programa principal se llama `main_KMC.f90` y depende de unas librerías
contenidas en la carpeta module:
1. `geometry.f90`: Contiene todo lo relacionado con la grometría
2. `mtfort90.f90`: Generador de números aleatorios Mersen twister
3. `search_arguments.f90`: Contiene un par de funciones que gestionan la entrada de argumentos por consola


Para instalarlo hay un makefile que lo que hace es compilar y generar imputs para hacer un bucle para diferentes temperaturas y tamaños. Para cambiar los tamaños sólo hay que cambiar la variable `L` del makefile. Para compilar sólo basta ejecutar el comando `make` en la consola des del directorio donde se encuantra `main_KMC.f90` teniendo en cuanta que han de estar las dependencias y la carpeta scripts que contiene los scripts que genera los bucles. 

Al compilar, se generará una carpeta llamada results. En ella vendrán otras carpetas para cada tamaño que contendrán los scripts `loop_T.sh` (ejecuta el programa para varias temperaturas) y `basic_plots.gp` (hace los plots). Por defecto, los scripts `loop_T.sh` y `basic_plots.gp` vienen para temperaturas 0.5 0.4 0.3 0.25 0.1 0.075 0.05.

En el directorio donde se encuentra `main_KMC.f90` también hay un archivo de nombre `parameter.par` y `launcher.sh`. Lo que hace `launcher.sh` es ejecutar el programa para los parámetros que contiene `parameter.par`. Los parámetros a cambiar son:
* T: Temperatura
* W: Valor del potencial por el que estará acotado en valor absoluto.
* rc: Radio de corte
* L: Tamaño de la caja
* Nitt: Número de iteraciones
* nMeasure: Cada cuantos pasos medir la polarización y la temperatura

Al ejecutar el programa `launcher.sh` se generará un output llamado `EP.dat` con tres columnas: El tiempo, la energía y la polarización.
