CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
# echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point


# Then, add here code to compile and run, and do any post-processing of the
# tests
set -e

# Copy content of student-submission to grading-area/
cp -R student-submission/ grading-area
cp -R lib grading-area

# Copy test files to grading-area
cp TestListExamples.java grading-area

files_tocopy=$(find ./ -maxdepth 1 -name "*.java")
echo $files_tocopy


for file in $files_tocopy
do
    cp $file grading-area/
done

found=false
echo "Checking on files"
cd grading-area
echo `ls`
set +e
for file in *.java
do
    if [[ -f "$file" && "$file" == ListExamples.java ]]
    then 
        found=true
        javac -cp .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar "$file" > ./output-test-result.txt
       
        exit_code=$?
        # echo "$exit_code"
        if [ $exit_code -ne 0 ]
        then
            "$(pwd): Compile Error" > ./output-result.txt
            break
        fi

        javac -cp .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar TestListExamples.java ListExamples.java 
        java -cp  .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar org.junit.runner.JUnitCore TestListExamples > ./output-test-result.txt
        grep -h "Tests run" output-test-result.txt | awk '{print "Result: Getting " $5 - $3 " out of " $5 " right"}'
        rm -r ./output-test-result.txt
    fi
done 

if [[ "$found"==false ]]
then 
    echo "Cannot find ListExamples.java" >> ./output-result.txt
fi

cat ./output-result.txt