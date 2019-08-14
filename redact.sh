
#!/bin/bash
redac=$1
doc=$2
###############################################################

lines=$(wc -l $doc )
set -- $lines
totalLinesDoc=$1
# echo "Total lines in document $totalLinesDoc"


lines=$(wc -l $redac )
set -- $lines
totalLinesRdt=$1
# echo "Total lines in rdt $totalLinesRdt"


lines=$(wc -w $doc )
set -- $lines
totalLinesWords=$1
# echo "Total words in rdt $totalLinesWords"
###############################################################

# Fetch words from rdt file and saving them to array
input=$redac
w=0

declare -a wordarray
while IFS= read -r wordlist
do
  wordarray[$w]=$wordlist
  
  w=$((w+1))
 
done < "$input"

        
###############################################################        

# traversing doc file
declare -a countarray
lineCount=0
count=0
charCount=0
# counting the number of appearances

inputdocfile=$doc
    while IFS= read -r linelist
    do
        line=$linelist
         echo "$line" >> lineWordFile.txt
        
         #it is having one line now
         # totalLineWord is having the number of words for a single line
            lwc=$(wc -w lineWordFile.txt )
            set -- $lwc
            totalLineWord=$1
        
                            
                    for (( k=0; k < $totalLinesRdt; k++ ))
                           
                    do
                                   
                        count=$((count + $(grep -o -i ${wordarray[$k]} <<<"$line" | grep -c .) ))  
                                    
                    done
              
        # echo $line
        # echo "value of COUNT $count"
        
        # check if word count is more than 1
        if [ $count -gt 1 ]
        then        
                   wordCount=$(echo -n $line | wc -c)
                   wordCount=$((wordCount+1))
                   lineCount=$((lineCount+1))
                    replaceword=-
                    
              
                
                    for i in $(seq 1 ${#line})
                    do
                      sed -i "${lineCount}s/${line:i-1:1}/$replaceword/g" $doc
                    done
           
              count=0 
              
        else
                    replaceword=----
                    lineCount=$((lineCount+1))
                    for ((k=0; k<$totalLinesRdt; k++))
                    do
                      sed -i ${lineCount}s/${wordarray[k]}/$replaceword/g $doc
                    done
                    count=0
               
        fi
   
    done < "$inputdocfile"
    
    
          
echo""
echo "DONE please see the UPDATED FILE"
echo "=================BELOW IS UPDATED CONTENT =================================="      
cat $doc