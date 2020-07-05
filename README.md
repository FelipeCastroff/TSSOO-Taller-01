# TSSOO - taller 1

Felipe Guillermo Castro Aguilar - <felipe.castroa@alumnos.uv.cl>

>`Universidad de Valparaíso`

## Introducción

El presente documento responde al previo proceso de diseño, el cual esta descrito en el reporte técnico del mismo repositorio. Este informe esta basado en el desarrollo e implementación de scrips en una máquina virtual, logrando el manejo de archivos a través de comandos *Bash* junto con todo el análisis del problema presentado.

Como objetivo del taller, se solicitó crear un script capaz de resolver las 3 problemáticas en un formato especifico.

Es destacable mencionar que este documento es una extensión del reporte técnico presentado en este repositorio el cual muestra las directrices del problema, junto con el problema y su descripción, el diseño de solución y resultados.

### Diseño de la Solución

Antes de dar inicio con el desarrollo del scrip presentado en este repositorio se realizó un diseño de solución para cada uno de los problemas enfrentados en este taller. Cada uno de estos problemas están especificados y diseñados en el reporte técnico adjunto en el repositorio.

El problema se planteo para que su desarrollo conste de 3 etapas o módulos a los cuales a cada uno de ellos se desarrollo un diseño mediante diagramas de flujos. Estos diagramas sirven como base para el desarrollo del scrip desarrollado.
Cada una de las problemáticas están relacionadas con el calculo de estadísticas de archivos de texto los cuales fueron generados por una simulación. Se nos pide obtener datos específicos de estos mediante un correcto uso de comandos Bash.

## Estructura del Código

Para presentar la estructura del código debemos entender que existen etapas definidas las cuales explicaremos más adelante.

### Encontrar la data correcta

Para dar inicio al proceso de análisis de datos primero debemos encontrar los archivos correctos para poder trabajar con ellos. Los archivos de cada simulación están estructurados de tal manera que cada uno de los archivos corresponde a un módulo de trabajo. Es importante mencionar que la cantidad de archivos puede aumentar o disminuir, cada simulación "N" tiene 3 archivos los cuales le corresponden a cada tarea para su análisis, por lo tanto es necesario recorrer cada simulación y seleccionar el archivo correcto para cada una de las tareas.

Otro requerimiento el cual es de importancia en este punto, fue el modo de uso que el script debe tener para su ejecución, este debe cumplir con ciertos parámetros para poder ejecutar y lograr el objetivo. Un ejemplo de los parámetros se encuentra en el siguiente aparatado

> ## Ejemplo de uso sin parámetros:
> ./stats.sh
>
> ./stats.sh -h
> ### Deberá mostrar lo siguiente:
> - Uso: ./stats.sh -d <direcorio datos> [-h] 
> - -d: directorio donde están los datos a procesar.
> - -h: muestra este mensaje y termina.
  
Una vez analizado el ejemplo se buscó una manera de encontrar el archivo mediante los parámetros de entrada, para ello se ocupó la misma lógica para cada una de las tareas pero con distintas condiciones, donde uno de los principales componentes será el comando **grep** el cual busca un patrón que definamos en un archivo de texto. Cada tarea conlleva el mismo trabajo de buscar el directorio por lo tanto se explicará en la tarea 1.

- ### Tarea 1

Una vez analizado el caso de los directorios y ver la validez de ellos podemos estudiar el caso de la tarea 1, donde se busco los archivos cuyo nombre contengan "executionSummary", ya que este es el necesario para cumplir con el requerimiento de esta tarea.

Los archivos se filtraron mediante esta linea de comandos:

`File0=(`find $searchDir -name '*.txt' -print | sort | grep executionSummary | grep -v '._'`)`

Donde ***$searchDir*** se encargará de buscar cualquier archivo de extensión **.txt** y el comando ***grep*** se encargará de seleccionar solo los que contengan executionSummary en su nombre.

Una vez encontrados los archivos necesarios se continuo con el desarrollo para encontrar los resultados correspondientes. Para ello se utiliza un **ciclo for** el cual recorre cada uno de los archivos que cumpla con la condición inicial, a través de los requerimientos iniciales se nos dijo que los datos a obtener son la suma de ciertos términos dentro de cada linea de los archivos seleccionados, por esta misma razón cada archivo de texto fue analizado linea a linea sumando las posiciones correspondientes y a través de un calculo de máximo, mínimo y promedio por simulación y cada valor obtenido fue almacenado en un archivo temporal, ***timeS***. Luego de tener los datos sumados de cada una de las simulaciones se procede a calcular lo solicitado desde el archivo temporal.

La siguiente sección muestra el código para esta primera etapa.

~~~
for i in ${File0[*]};
do
        timeSimT=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN{sum=0}{sum=$6+$7+$8} END{print sum}')
        printf "$timeSimT \n" >>$timeS
        stats00=$(cat $timeS | awk 'BEGIN{min=2**63-1;max=0} { if($1<min){min=$1};\
                                                                if($1>max){max=$1};\
                                                                total+=$1; count+=1;\
                                                                } \
                                                                END { print total":"total/count":"max":"min}')
~~~

Una vez obtenidos los datos necesarios se realizó la siguiente etapa de esta tarea la cual era el calculo de la memoria usada y para ello solo basto con encontrar solo un dato en cada fila de cada archivo correspondiente. Se obtuvo de la misma manera que la anterior solo que para este caso solo se obtenía un solo valor por linea.

Una vez finalizado la obtención de la data, esta se almacenó en el archivo solicitado.

Es importante desatacar que se ocuparon 2 archivos temporales que me ayudaron al desarrollo de esta tarea.
- ### Tarea 2
  
Antes de dar inicio al desarrollo de la tarea es importante recalcar que código generado no cumple con lo solicitado en el taller, este muestra datos erróneos pero en este apartado explicaré el funcionamiento el cual esperaba.

Esta tarea se dividió en 3 secciones donde la primera se encarga de la obtención del tiempo promedio, mínimo y máximo de evacuación de todos las personas de la simulación, la segunda de los residentes y visitantes de tipo I y la tercera de los grupos etarios de los residentes y visitantes.

1. #### Primera parte(Todas las personas simuladas)

    Para esta primera parte se analizó todos los datos seleccionados anteriormente para luego buscar los mínimos, máximos y promedio del archivo de cada simulación y esto son almacenados en un archivo temporal, que para el caso de este taller fueron once lineas en el archivo temporal, ya que el taller contempla solo once simulaciones.

    Una vez obtenido los máximos, mínimos y promedio de cada simulación se recorrió el archivo temporal y se calculó el máximo, mínimo y promedio de la misma forma que la primera parte, pero esta vez de los máximos, mínimos y promedios de cada una de las simulaciones.

    Esto dio como resultado el máximo de los máximos obtenidos, el mínimo de los mínimos obtenidos y el promedio de los promedios obtenidos.

2. #### Segunda parte(Visitantes y Residentes)
   
   Para el desarrollo de este punto se observo que existía un campo que identificaba el tipo de persona, por lo tanto el desarrollo de este punto fue centrado en la función ***seq***, ya que esta se encarga de que el calculo de los mínimos, máximos y promedios sea dividida para ambos casos.
   La forma de calcular dichos valores es de la misma forma que en el primera parte de la Tarea 2.
    
        for i in ( seq 0 1)
        do        
            rm -f $tFile01
                for j in ${File1[*]};
                do
                    Calculo de promedio, máximo y mínimo de cada una de las
                    simulaciones para ser almacenadas en un archivo temporal
                    y luego calcular las mismas medidas para el archivo temporal.
                done
            *Almacenar los datos en el archivo solicitado*
        done
  
   Es importan destacar que los datos son almacenados en el mismo archivo temporal por lo que este debe ser borrado y creado nuevamente para que los datos no se vean alterados cuando se calculé el mínimo, máximo y promedio del Residente y los Visitantes de tipo I.

3. #### Tercera parte(Grupo etario para Visitantes y Residentes)

    Como ultima parte de esta tarea y la más compleja, se utilizo la misma estructura que ocupamos en el segunda parte de este punto, pero con el agregado de ocupar otro ***bucle for*** con la función ***seq*** el cual estará definido entre los valores: 0, 1, 2 y 3 los cuales representan a los grupos etarios. Los datos obtenido seran procesados igual que el punto anterior generando la estadística correspondiente dividida en Visitantes I y Residentes.
    
    De manera de explicativa y de resumen, la tercera parte primero buscará el tiempo de evacuación de las personas del grupo etario 0 y luego serán filtradas por tipo de persona, llenando de esta manera el documento solicitado.

        for i in (seq 0 3)   #Indica el grupo etario con el que se trabajará
        do
            for j in (seq 0 1);
            do 
                rm -f $tFile02
                for k uin ${File1[*]};
                do
                    Calculo de promedio, máximo y mínimo de cada una de las
                    simulaciones para ser almacenadas en un archivo temporal
                    y luego calcular las mismas medidas para el archivo temporal.
                done
            *Almacenar los datos en el archivo solicitado*
            done
        done


   
- ### Tarea 3
Para el desarrollo de esta tarea se utilizó la misma forma de obtención de los datos que las otras dos. Una vez obtenidos los datos se optó por determinar los instantes de tiempos específicos de cada simulación y estos guardarlos en un archivo temporal para luego dependiendo del tiempo buscar el uso de teléfono. Para ello ocupamos 2 ciclos **for** donde el primero se encarga de obtener todos los tiempos específicos de cada simulación y el segundo los separa en cada una de ellas.

Después se trabajo con el comando ***seq*** desde una posición 1 hasta la cantidad de lineas del archivo temporal. Las lineas fueron obtenidas modificando el archivo temporal como se muestra a continuación:

~~~
totalData=$(head -1 $tFile04 | sed 's/.$//' | tr ':' '\n'| wc -l)
~~~

Por cada linea se busco la información solicitada y esta se aplico el calculo de máximo, mínimo y promedio para luego ser almacenado en el documento de texto junto con el tiempo especifico de cada uno de ellos obtenidos.

## Conclución

En cuanto a lo abordado con anterioridad, es importante destacar que el trabajo realizado en este taller no esta realizado de manera eficiente pero se logró entender el funcionamiento de los script y el manejo de datos entre archivos de texto. De igual manera se rescata que el trabajar con un *cliente SSH* es una manera muy cómoda y eficiente a la hora de trabajar con datos y necesitar los analizar lo realizado.

Al igual que el informe técnico podemos llegar a la conclusión que el proceso de diseño a la hora del desarrollo de un código es de suma importancia, ya que este coloca las directrices y guía el desarrollo mediante una idea concreta, pero esto no garantiza que el diseño sea una correcta implementación, ya que durante el desarrollo pueden existir mas de alguna razón para cambiar el del desarrollo.

Finalmente el código presentado puede ser mejorado a través de funciones, las cuales ayudarían a un trabajo más limpio y un buen manejo del tiempo el cual es fundamental para el desarrollo de este.
