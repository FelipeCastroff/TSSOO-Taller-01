# TSSOO - Taller 1


Felipe Guillermo Castro Aguilar - <felipe.castroa@alumnos.uv.cl>

`Universidad de Valparaíso`


## Introducción

El presente repositorio responde al a un previo proceso de diseño el cual esta basado en el correcto desarrollo e implementación de scrips en una máquina virtual, logrando un manejo de archivos y a través de comandos Bash junto con todo el análisis del problema presentado.

## Diseño de Solución

Antes del desarrollo del scrip presentado en este repositorio se presentó un diseño de solución para cada uno de los problemas que se enfrentaron en este taller. Cada uno de estos problemas están especificados y diseñados en el documento adjunto a este repositorio.

El problema se planteo para que su desarrollo conste de 3 etapas o módulos a los cuales a cada uno de ellos se le desarrollo un diseño mediante diagramas de flujos. Estos diagramas cumplen como base para el desarrollo del scrip presentado.

Como objetivo del taller, se solicitó crear un script capaz de resolver las 3 problemáticas presentadas en este con un formato especifico.

Estas problemáticas están relacionadas con el calculo de estadísticas de archivos de texto los cuales fueron generados por una simulación. Se nos pide obtener datos específicos de estos mediante un correcto uso de comandos Bash.

## Estructura del Código

Para presentar la estructura del código debemos entender que existen etapas definidas las cuales explicaremos más adelante.

### Encontrar data correcta

Para dar inicio al proceso de análisis de datos primero debemos encontrar la data correcta para poder trabajar con ella. Los archivos de la simulación están estructurados de tal manera que cada uno de los archivos corresponde a un módulo de trabajo. Es importante mencionar que la cantidad de archivos puede aumentar o disminuir, cada simulación "N" tiene 3 archivos los cuales le corresponden a cada tarea para su análisis.

Otro requerimiento el cual es de importancia en este punto, fue el modo de uso que el script debe tener para su ejecución, este debe cumplir con ciertos parámetros para poder ejecutar y lograr el objetivo. Un ejemplo de los parámetros se encuentra en el siguiente aparatado

```{r}
Ejemplo de uso sin parámetros:
    ./stats.sh
    ./stats.sh -h
Deberá mostrar lo siguiente:
    Uso: ./stats.sh -d <direcorio datos> [-h]
        -d: directorio donde están los datos a procesar.
        -h: muestra este mensaje y termina.
```
Una vez analizado el ejemplo se buscó una manera de buscar el archivo mediante los parámetros de entrada para ello se ocupó la misma linea de código para cada una de las tareas pero con distintas condiciones, donde uno de los principales componentes será el comando gerp el cual busca un patrón que definamos en un archivo de texto. Cada tarea conlleva el mismo trabajo de buscar el directorio por lo tanto se explicará en la tarea 1.

### Tarea 1

Una vez analizado el caso de los directorios y ver la validez de ellos podemos analizar el caso de la tarea 1, donde buscaremos los archivos cuyo nombre contengan "executionSummary", ya que este es el necesario para cumplir con el requerimiento de esta tarea.

Los archivos se filtraran mediante esta linea de comandos:

`File0=(`find $searchDir -name '*.txt' -print | sort | grep executionSummary | grep -v '._'`)`

Una vez encontrado los archivos necesarios se continuo con el desarrollo para encontrar los resultados correspondientes. Para ello se utilizó una función for la cual recorra cada uno de los archivos que cumplan con la condición inicial, a través de los requerimientos iniciales se nos dijo que los datos a obtener son la suma de ciertos términos dentro de cada linea de los archivos seleccionados, por esta misma razón cada archivo de texto fue analizado linea a linea sumando las posiciones correspondientes y a través de un calculo simple de máximo, mínimo y promedio se logro obtener el resultado esperado.
La siguiente sección muestra el código para esta primera etapa.

````
for i in ${File0[*]};
do
        timeSimT=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN{sum=0}{sum=$6+$7+$8} END{print sum}')
        printf "$timeSimT \n" >>$timeS
        stats00=$(cat TimeS.txt | awk 'BEGIN{min=2**63-1;max=0} { if($1<min){min=$1};\
                                                                                                  if($1>max){max=$1};\
                                                                                                  total+=$1; count+=1;\
                                                                                                   } \
                                                                                                       END { print total":"total/count":"max":"min}')
````

Una obtenida los datos necesarios se realizó la siguiente etapa de esta tarea la cual era el calculo de la memoria usada y para ello solo basto con encontrar solo un dato en cada fila de cada archivo correspondiente, como se muestra a continuación:

````
memoryUsed=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN{memory=0}{memory=$9} END{print memory}')
        printf "$memoryUsed \n" >>$mTotal
        stats01=$(cat MTotal.txt | awk 'BEGIN{min=2**63-1;max=0} { if($1<min){min=$1};\
                                                                                                          if($1>max){max=$1};\
                                                                                                          total+=$1; count+=1;\
                                                                                                    } \
                                                                                                        END { print total":"total/count":"max":"min }')
````

Una vez finalizado la obtención de la data, esta se almacenó en el archivo solicitado. 

Es importante desatacar que se ocuparon 2 archivos temporales que me ayudaron al desarrollo de esta tarea.
## Tarea 2 
