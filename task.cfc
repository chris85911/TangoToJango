/**
* Task for sorting a gimp pallete file to order values in columns
*/
component {

	/**
	* 1) Reads in the Tango.gpl file, 
	* 2) Turns the lines with pallete values into an array
	* 3) Turns the array into a query object
	* 4) Sort the query object by ascending value
	* 5) Writes the newly sorted Jango.gpl file 
	*/
	function run() {
		
		variables.outputFileText = ""

		// Get file contents
		fileContent = fileRead(expandPath("./docs/Tango.gpl"), "utf-8") 

		// Create query object for sorting 
	    myQuery = queryNew("number,description","Integer,Varchar");


		// Create array from line separated list (aka file contents)
		myArray = ListToArray(fileContent , chr(10))

		// Loop through array and add pallete value info as new query object entries
		for(i = 1; i <= arrayLen(myArray); i=i+1) {
			useNumber = mid(myArray[i], 2, 3)

			if(isNumeric(useNumber)) {
				queryAddRow(myQuery, [ 
						[ 	
							replaceNoCase( left(myArray[i], 11), " ", "0", "all" ), 
							mid(myArray[i], 13, 20) 
						] 
					])
				
			}
			else { // Add any non-pallete values to output variable header
				variables.outputFileText=listAppend(variables.outputFileText, myArray[i], chr(10)) 
			}
		}

		// Sort the query based on the number result from the pallete value
		sortedQuery=QuerySort(myQuery,function(obj1,obj2){
        	return compare(obj1.number,obj2.number) // compare on number values
   		 })

		// Write the sorted values to the output file text
		QueryEach(myQuery,function(any obj){
        	variables.outputFileText=listAppend(variables.outputFileText, "#numberFormat(mid(obj.number,1,3),'___')# #numberFormat(mid(obj.number,5,3),'___')# #numberFormat(mid(obj.number,9,3),'___')##chr(9)##obj.description#" , chr(10))
   		})

		
		//print.redLine(variables.outputFileText)
		//print.line( formatterUtil.formatJSON( myQuery ) );

		// Write updated value to Jango file
		fileWrite(expandPath("./docs/Jango.gpl"), variables.outputFileText, "utf-8")
		print.greenLine("DONE!")
	}

}
