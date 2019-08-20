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
	# echo -e "<tr><td><center><b>caseId123</b></center></td></tr>"

	headNames=($(echo $resultsArray | awk -F '\\},\\{' '{print $1}' | awk -F ',' '{i=1; while(i<=NF) {print "<td>"$i"</td>";i++}}'))
	echo "headNames: "$headNames

	# echo $resultsArray | awk -F '\\},\\{' '{i=1; while(i<=NF) {print "<td>"$i"</td>";i++}}'

	
	echo $1
	td_str=`echo $1 | awk 'BEGIN{FS=","}''{i=1; while(i<=NF) {print "<td>"$i"</td>";i++}}'`
	echo $td_str

}

function create_table_rows(){
	echo -e "<tr><td>dfasdfasfd123</td>
	</tr>"
}

function create_html_end(){
	echo -e "</table>
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