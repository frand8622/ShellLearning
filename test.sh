#!/bin/sh

# file_input='/c/BeyondsoftProjects/hera/integration-api-test/target/IngestionResults/2019-08-15.json'
# file_output='/c/BeyondsoftProjects/hera/integration-api-test/target/IngestionResults/table.html'
file_input='/c/shell/2019-08-15.json'
file_output='/c/shell/table.html'

file_temp1='/c/shell/temp1.txt'
file_temp2='/c/shell/temp2.txt'
file_temp3='/c/shell/temp3.txt'

resultsArray=''
headNames=''

# for file in /c/BeyondsoftProjects/hera/integration-api-test/target/IngestionResults/2019-08-15.json
for file in $file_input
do
	#echo $file
	#cat $file
	# echo $(basename ${file})
	
	#echo $(awk -F ':\\[\\{' '{print $2}' $file) | awk -F '\\}\\]\\}' '{print $1}'
	
	#awk -F ':\\[\\{' '{print $2}' $file | awk -F '\\}\\]\\}' '{print $1}' | awk -F '\\},\\{' '{print $1, $2}'
	
	# awk -F ':\\[\\{' '{print $2}' $file | awk -F '\\}\\]\\}' '{print $1}' | awk -F '\\},\\{' '{i=1; while(i<=NF) {print "<td>"$i"</td>";i++}}'
	
	resultsArray=($(awk -F ':\\[\\{' '{print $2}' $file | awk -F '\\}\\]\\}' '{print $1}'))
	echo "results: "$resultsArray
	
	# resultsArray=`echo "aaa},{bbb"`
	
	# echo $resultsArray | awk -F '\\},\\{' '{i=1; while(i<=NF) {print "<td>"$i"</td>";i++}}'
	
done

function create_html_head(){
	echo -e "<html>
				<body>
					<h1><center>Ingestion Results</center></h1>
					<center>
						<table border='1'>"
}

function create_table_head(){
	echo "<tr>"

	# resultsArray is: "caseId":"id-1","status":"READY","Message":null,"ingestionTime":123},{"caseId":"id-2","status":"READY","Message":null,"ingestionTime":456

	heads=`echo $resultsArray | awk -F '},{' '{print $1}' | awk 'BEGIN{FS=","} {i=1; while(i<=NF) {split($i, keyy, ":"); split(keyy[1], key, "\""); print "<td>"key[2]"</td>";i++}}'`
	# heads=`echo $resultsArray | awk -F '},{' '{print $1}' | awk -F ',' '{i=1; while(i<=NF) {split($i, keyy, ":"); split(keyy[1], key, "\""); print "<td>"key[2]"</td>";i++}}'`
	echo $heads		# will get: <td>caseId</td> <td>status</td> <td>Message</td> <td>ingestionTime</td>
	
	echo "</tr>"
}

function create_table_rows(){
	echo "<tr>"

	# resultsArray is: "caseId":"id-1","status":"READY","Message":null,"ingestionTime":123},{"caseId":"id-2","status":"READY","Message":null,"ingestionTime":456

	rows=`echo $resultsArray | awk -F '},{' '{print $2}' | awk '
		BEGIN{FS=","} 
		{
			i=1; 
			while(i<=NF) {
				split($i, valuee, ":"); 
				if(index(valuee[2],"\"")==1){
					split(valuee[2], value, "\""); 
					print "<td>"value[2]"</td>";
				}
				else{
					print "<td>"valuee[2]"</td>";
				}
				i++;
			}
		}
		'
		`
	echo $rows		# will get: <td>id-1</td> <td>READY</td> <td>null</td> <td>123</td>
	
	echo "</tr>"
}

function create_html_end(){
	echo "</table>
		</center>
	</body>
</html>"
}

function create_html(){
	rm -rf $file_output
	touch $file_output
	create_html_head >> $file_output	
	create_table_head >> $file_output
		
	create_table_rows >> $file_output
	create_html_end >> $file_output
	
}

#create_html

create_table_head
create_table_rows