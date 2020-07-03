#!/bin/bash
forma_uso(){
        echo -e "Uso: $0 -d <archivo_datos> [-h]\n -d: directorio donde están los datos a procesar.\n -h: muestra este mensaje y termina."
        exit 1
}

#set -x
#Parte 1------------------------------------------------------------------------------------------------------------------------------------------------
execution(){
File0=(`find $searchDir -name '*.txt' -print | sort | grep executionSummary | grep -v '._'`)

timeS="TimeS.txt"
mTotal="MTotal.txt"

rm -f TimeS.txt
rm -f MTotal.txt
rm -f metrics.txt

for i in ${File0[*]};
do
        timeSimT=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN{sum=0}{sum=$6+$7+$8} END{print sum}')
        printf "$timeSimT \n" >>$timeS
        stats00=$(cat TimeS.txt | awk 'BEGIN{min=2**63-1;max=0} { if($1<min){min=$1};\
                                                                                                  if($1>max){max=$1};\
                                                                                                  total+=$1; count+=1;\
                                                                                                   } \
                                                                                                       END { print total":"total/count":"max":"min}')

        memoryUsed=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN{memory=0}{memory=$9} END{print memory}')
   	printf "$memoryUsed \n" >>$mTotal
        stats01=$(cat MTotal.txt | awk 'BEGIN{min=2**63-1;max=0} { if($1<min){min=$1};\
                                                                                                          if($1>max){max=$1};\
                                                                                                          total+=$1; count+=1;\
                                                                                                    } \
                                                                                                        END { print total":"total/count":"max":"min }')
done
echo $stats00 >>metrics.txt
echo $stats01 >>metrics.txt

rm -f TimeS.txt
rm -f MTotal.txt

}

#Parte 2-------------------------------------------------------------------------------------------------------------------------------------------------
summary(){
File1=(`find $searchDir -name '*.txt' -print | sort | grep summary | grep -v '._'`)

tFile01="TFile01.txt"
tFile02="TFile02.txt"
every="everyoneStats.txt"
evacua="evacuation.txt"
#rm -f evacuation.txt
#rm -f everyoneStats.txt
#rm -f TFile01.txt
#Datos de todos las personas simuladas
rm -f evacuation.txt

for i in ${File1[*]};
do
cat $i | tail -n+2 | awk -F ':' 'BEGIN{min=2**63-1;max=0}{ if($8<min){min=$8};\
                                                             	 if($8>max){max=$8};\
                                                                 totalQ+=$8; countQ+=1;\
                                                                 }\
                                                                 END{print totalQ":"totalQ/countQ":"min":"max}' >> $every

stats02=$(cat $every | awk -F ':' 'BEGIN{min=2**63-1;max=0} { if($3<min){min=$3};\
								if($4>max){max=$4};\
								totalW+=$1; countW+=1;\
                                                                } \
                                                                END {print totalW/countW":"min":"max}')
done
printf "alls:promedio:min:max\n" >>$evacua
echo $stats02 >> $evacua

#Residentes y Visitante de tipo I---------------------------------------------------------
printf "residents:promedio:min:max\n" >>$evacua
printf "visitorsI: promedio:min:max\n" >> $evacua
for i in $(seq 0 1)
do
rm -f $tFile01
	for j in ${File1[*]};
	do
	cat $j | tail -n+2 | awk -F ':' 'BEGIN{min=2**63-1;max=0}{ if($3 == '$i'){if($8<min){min=$8}};\
                                                                 if($8>max){max=$8};\
                                                                 totalE+=$8; countE+=1;\
                                                                 }\
                                                                 END{print totalE":"totalE/countE":"min":"max}' >> $tFile01
	done
	stats03=$(cat $tFile01 | awk -F ':' 'BEGIN{min=2**63-1;max=0} { if($3<min){min=$3};\
                                                                if($4>max){max=$4};\
                                                                totalS+=$1; countS+=1;\
                                                                }\
                                                                END {print totalS/countS":"min":"max}')
	printf "$stats03 \n" >> $evacua
	less $evacua
done

#Residentes y Visitantes dependiendo su Gupo etario.------------------------------------
printf "residents-G0:promedio:min:max\n" >> $evacua
printf "residents-G1:promedio:min:max\n" >> $evacua
printf "residents-G2:promedio:min:max\n" >> $evacua
printf "residents-G3:promedio:min:max\n" >> $evacua
printf "visitorsI-G0:promedio:min:max\n" >> $evacua
printf "visitorsI-G1:promedio:min:max\n" >> $evacua
printf "visitorsI-G2:promedio:min:max\n" >> $evacua
printf "visitorsI-G3:promedio:min:max\n" >> $evacua
for i in $(seq 03)
do
	for j in $(seq 0 1);
	do
	rm -f $tFile02
		for k in ${File1[*]};
		do
		cat $k | tail -n+2 | awk -F ':' 'BEGIN{min=2**63-1;max=0}{ if($3 == '$j' && $4== '$i'){ if($8<min){min0$8}};\
								if($8>max){max=$8};\
                                                                 totalR+=$8; countR+=1;\
                                                                 }\
                                                                 END{print totalR":"totalR/countR":"min":"max}' >> $tFile02
		done
		stats04=$(cat $tFile02 | awk -F ':' 'BEGIN{min=2**63-1;max=0} { if($3<min){min=$3};\
                                                                if($4>max){max=$4};\
                                                                totalT+=$1; countT+=1;\
                                                                }\
                                                                END {print totalT/countT":"min":"max}')
	done
	printf "$stats04 \n" >> $evacua
done
rm -f everyoneStats.txt
rm -f TFile02.txt
rm -f TFile01.txt

}
#Parte 3---------------------------------------------------------------------------------------------------------------------------------------------------
usePhone(){
File2=(`find $searchDir -name '*.txt' -print | sort | grep usePhone | grep -v '._'`)

usePhone="usePhone-stats.txt"
tFile04="TFile04.txt"

rm -f $tFile04
rm -f $usePhone

for i in ${File2[*]};
do
	timeStamp=(`cat $i | tail -n+3 | cut -d ':' -f 3`)
	for i in ${timeStamp[*]};
	do
		printf "%d:" $i >> $tFile04
	done
	printf "\n" >> $tFile04
done

totalData=$(head -1 $tFile04 | sed 's/.$//' | tr ':' '\n'| wc -l)

printf "#timestamp:promedio:min:max\n" >> $usePhone
for i in $(seq 1 $totalData); do
	dataUsePhone=$(cat $tFile04 | cut -d ':' -f $i | awk 'BEGIN{ min=2**63-1; max=0}\
						{if($1<min){min=$1};if($1>max){max=$1};total+=$1; count+=1;}\
						END {print total/count":"max":"min}')
	printf "$i:$dataUsePhone\n" >> $usePhone
done

rm -f $tFile04

}
#set +x
while getopts "d:h" opt; do
  case ${opt} in
	    d )
		searchDir=$OPTARG
      ;;
    h )
		forma_uso
      ;;
    \* ) 
		echo "Para visualizar la forma de uso debe utilizar [-h]"
      ;;
  esac
done
shift $((OPTIND -1))

if [ ! -d $searchDir ]; then
        echo "$searchDir no es un directorio"
        exit
fi

printf "Directorio busqueda: %s\n" $searchDir
execution
summary
usePhone

