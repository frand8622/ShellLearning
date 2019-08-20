# !/bin/sh
ARRAY=($(awk -F ',' '{print $0}' '/c/jmeterworkspace/sapmodelcompany/results/trunkcaseowners.csv'))
count=0
successcase=0
failcase=0
for file in /c/BeyondsoftProjects/hera/integration-api-test/target/IngestionResults/*.json
do
    filename=$(basename ${file})
    fileextension=${filename##*.}
    filetype="html"
	for i in ${ARRAY[@]}
	do
		if [ ${i%%,*} = ${filename%%.*} ]
		then
			name=${i#*,}
			echo $name
			break
		fi
	done
	
	if test -f $file
	then
        if [ $fileextension = $filetype ]
        then
            finstr1='xsl\/images\/pass\.gif'
            finstr2='xsl\/images\/error\.gif'
            count1=`grep -o ${finstr1} ${file} | wc -l`
            count2=`grep -o ${finstr2} ${file} | wc -l`
            passrate=$(printf "%d%%" $(($count1*100/($count2+$count1))))
			filename1=${filename%%.*}
			link='<a href="http://10.116.38.160:8080/userContent/APICustomized/${BUILD_NUMBER}/'${filename}'">'$filename1'</a>'
            if [ $passrate = '100%' ]
            then
                resultstatus='<center><font color="green">Pass</font></center>'
                successcase=$[successcase+1]
            else
                resultstatus='<center><font color="red">Fail</font></center>'
                failcase=$[failcase+1]
            fi
            outputstring=${link}"|"$resultstatus"|""<center>"$passrate"</center>""|"$name
            echo $outputstring
            echo ${outputstring} >> '/c/jmeterworkspace/sapmodelcompany/results/trunktest1.txt'
	     fi
	fi
	
    let "count+=1"
done

failratio=$(printf "%d%%" $(($successcase*100/($failcase+$successcase))))
cat /c/jmeterworkspace/sapmodelcompany/results/trunktest1.txt | sort -t '|' -k 2,2r -k 4,4 > /c/jmeterworkspace/sapmodelcompany/results/trunkfinalsort1.txt
file_origininput='/c/jmeterworkspace/sapmodelcompany/results/trunktest1.txt'
file_input='/c/jmeterworkspace/sapmodelcompany/results/trunkfinalsort1.txt'
file_output='/c/jmeterworkspace/sapmodelcompany/results/customizedAPIReport.html'
td_str=''

function create_html_head(){
	echo -e "<html>
	<body>
	<h1><center>API Report</center></h1>"
}

function create_table_head(){
	echo -e "<center><table border="1"><tr><td><center><b>TestCase</b></center></td><td><center><b>Status</b></center></td><td><center><b>Pass Rate</b></center></td><td><center><b>Case Owner</b></center></td></tr>"
}

function create_td(){
	# if [ -e ./"$1" ]; then
	echo $1
	td_str=`echo $1 | awk 'BEGIN{FS="|"}''{i=1; while(i<=NF) {print "<td>"$i"</td>";i++}}'`
	echo $td_str
	# fi
}

function create_tr(){
	create_td "$1"
	echo -e "<tr>
	$td_str
	</tr>" >> $file_output
}

function create_table_end(){
	echo -e "</table></center>"
}

function create_html_end(){
	echo -e "</body></html>"
}

function create_total_lines(){
	echo -e "<h2><center>Total we have $count test cases. And passing rate is <green>${failratio}</green>.</center></h2>"
}

function create_html(){
	rm -rf $file_output
	touch $file_output
	rm -rf $file_origininput
	create_html_head >> $file_output
	create_total_lines >> $file_output
	create_table_head >> $file_output
	
	while read line
	do
		echo $line
		create_tr "$line" 
	done < $file_input
	
	create_table_end >> $file_output
	create_html_end >> $file_output
	rm -rf $file_input
}

create_html
