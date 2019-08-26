#!/bin/sh

file_input='./IngestionResults/*.json'
file_output='./IngestionResults/TableView.html'

resultsArray=''

function initial(){
	for file in $file_input
	do
		#echo $file
		#cat $file

		# fileFullName=$(basename ${file})
		# fileName=`echo $fileFullName | awk -F '.' '{print $1}'`
		# file_output=$file_output'/'$fileName'.html'

		results=($(awk -F ':\\[\\{' '{print $2}' $file | awk -F '\\}\\]\\}' '{print $1}'))
		resultsArray=$resultsArray'},{'$results
		# resultsArray is: },{"caseId":"id-1","status":"READY","Message":null,"ingestionTime":123},{"caseId":"id-2","status":"READY","Message":null,"ingestionTime":456
	done
}

function create_html_head(){
	echo "<html>
	<body>
		<h1><center>Ingestion Results</center></h1>
			<center>
				<table border='1'>"
}

function create_table_head(){
	# both of the two ways can get: <tr><th>caseId</th><th>status</th><th>Message</th><th>ingestionTime</th></tr>
	# echo "<tr>"
	# heads=`echo $resultsArray | awk -F '},{' '{print $1}' | awk 'BEGIN{FS=","} {i=1; while(i<=NF) {split($i, keyy, ":"); split(keyy[1], key, "\""); print "<th>"key[2]"</th>";i++}}'`
	# echo $heads
	# echo "</tr>"

	echo $resultsArray | awk -F '},{' '{print $2}' | awk -F ',' '{
		print "<tr>";
		i=1; 
		while(i<=NF) {
			split($i, keyy, ":"); 
			split(keyy[1], key, "\""); 
			print "	<th>"key[2]"</th>";
			i++;
		}
		print "</tr>";
	}'
}

function create_table_rows(){
	# will get: <tr><td>id-1</td><td>READY</td><td>null</td><td>123</td></tr><tr><td>id-2</td><td>READY</td><td>null</td><td>456</td></tr>
	echo $resultsArray | awk -F '},{' '{
		i=1;
		while(i<=NF) {
			print "<tr>";
			count=split($i, keyValues, ",");
			j=1;
			while(j<=count) {
				split(keyValues[j], keyValue, ":"); 
				if(index(keyValue[2],"\"")==1){
					split(keyValue[2], value, "\""); 
					print "	<td>"value[2]"</td>";
				}
				else{
					print "	<td>"keyValue[2]"</td>";
				}

				j++;
			}

			print "</tr>";
			i++;
		}
	}'
}

function create_html_end(){
	echo "				</table>
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

initial
create_html