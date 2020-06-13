#!/bin/bash

#Parte1
File0=(`find $searchDir -name '*.txt' -print | sort | grep executionSummary | grep -v '._'`)
rm -f TimeS.txt
rm -f MTotal.txt
rm -f metrics.txt
rm -f evacuation.txt
for i in ${File0[*]};
do
        printf '> %s\n' $i
        timeSimT=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN{sum=0}{sum=$6+$7+$8} END{print sum}')
        printf "$timeSimT \n" >>TimeS.txt
        stats00=$(cat TimeS.txt | awk 'BEGIN{min=2**63-1;max=0} { if($1<min){min=$1};\
                                                                                                  if($1>max){max=$1};\
                                                                                                  total+=$1; count+=1;\
                                                                                                   } \
                                                                                                       END { print total":"total/count":"max":"min}')

        memoryUsed=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN{memory=0}{memory=$10} END{print memory}')
   	printf "$memoryUsed \n" >>MTotal.txt
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


#parte 2

File1=(`find $searchDir -name '*.txt' -print | sort | grep summary | grep -v '._'`)


for i in ${File1[*]};
do
	printf '> %s\n' $i
	everyone=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN{every=0}{every+=$8} END{print every}')
	printf "$everyone \n" >>everyoneStats.txt
	stats02=$(cat everyoneStats.txt | awk 'BEGIN{min=2**63-1;max=0} { if($1<min){min=$1};\
                                                                                                  if($1>max){max=$1};\
                                                                                                  total+=$1; count+=1;\
                                                                                            } \
                                                                                                END { print total":"total/count":"max":"min}')
	resident=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN{resid=0;min=2**63-1;max=0}{ if($3==0){resid+=$8};\
												if($resid<min){min=$resid};\
                                                                                                  if($resid>max){max=$resid};\
                                                                                                  total+=$resid; count+=1;\
                                                                                            } \
                                                                                                END { print total":"total/count":"max":"min}')
	Visit=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN{vis=0;min=2**63-1;max=0}{ if($3== 1){vis+=$8};\
												if($vis<min){min=$vis};\
                                                                                                  if($vis>max){max=$vis};\
                                                                                                  total+=$vis; count+=1;\
                                                                                            } \
                                                                                                END { print total":"total/count":"max":"min}')
	#resident=$(cat $i | tail -n+2 | grep

	#stats03=$(cat $i | tail -n+2 | cut -d ":" -f 3,4,8 )
	#printf $stats03 \n
	#resident=$(cat $i | tail -n+2 | awk -F ':' 'BEGIN{resid=0}{resid+=$
done
echo $stats02 >>evacuation.txt
echo $resident >>evacuation.txt
echo $Visit >>evacuation.txt
rm -f everyoneStats.txt

#parte 3

File2=(`find $searchDir -name '*.txt' -print | sort | grep usePhone | grep -v '._'`)
rm -f $TFile04
rm -f tStamp.txt

for i in ${File2[*]};
do
	printf '> %s\n' $i
	timeStamp=$(cat $i | tail -n+3 | cut -d ':' -f 2)
	printf $timeStamp \n
done



