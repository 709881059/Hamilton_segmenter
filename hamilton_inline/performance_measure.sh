#!/bin/bash
#performance measure: /performance/measure_performance.sh --mode(all, function name) filename
# needs to run where ./ourtest is and store the result in current perf_result directory


#mode: All, profile the whole thing,qrsdet, classify

# Performance: flops/cycle
# Cache misses:
# Baseline Performance: flops/cycle


# Save output to ../performance/output/filename

#TO DO: memory bandwidth
#add flame 
usage()
{
    echo -e "usage: ./measure_performance.sh \n \t\t[-m modes [all,qrsdet,classify]]\n\t\t[-o outputname [user-defined filename to store the output]] \n\t\t| [-h help menu]]"
}

if [ $# -ne 4 ]; then
    usage
    exit 1
fi

mkdir -p ../performance/output/
outdir="../performance/output/"
while [ "$1" != "" ]; do
    case $1 in
        -m | --mode )           shift
                                mode=$1
                                echo -e "Profiling mode: $mode \n"
                                ;;
                               
  		-o | --outputname )     shift
								outputname=$1
								dash="_"
								DATE=`date '+%Y-%m-%d_%H:%M:%S'`
								outputfilename=$outdir$outputname$dash$DATE 
								echo -e "Result is at: $outputfilename \n"
								echo "YAY" > outputfilename
								
							   	
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done


if [ $mode == 'all' ]
	then
		echo -e "#define OPERATION_COUNTER \n#define RUNTIME_MEASURE \n#define RUNTIME_QRSDET \n#define RUNTIME_CLASSIFY \n " > performance.h
		echo -e "#define OPERATION_COUNTER \n#define RUNTIME_MEASURE \n#define RUNTIME_QRSDET \n#define RUNTIME_CLASSIFY \n " > ../hamilton_float/performance.h

elif [ $mode == 'qrsdet' ]
	then
		echo -e "#define OPERATION_COUNTER \n#define RUNTIME_MEASURE \n#define RUNTIME_QRSDET \n " > performance.h
		echo -e "#define OPERATION_COUNTER \n#define RUNTIME_MEASURE \n#define RUNTIME_QRSDET \n " > ../hamilton_float/performance.h

elif [ $mode == 'classify' ]
	then
		echo -e "#define OPERATION_COUNTER \n#define RUNTIME_MEASURE \n#define RUNTIME_CLASSIFY \n " > performance.h
		echo -e "#define OPERATION_COUNTER \n#define RUNTIME_MEASURE \n#define RUNTIME_CLASSIFY \n " > ../hamilton_float/performance.h

else
echo "Please specify the correct profiling mode: all, qrstdet, classify".
fi

make clean all

./ourtest 2>&1 | tee $outputfilename

echo -e "Start running baseline \n" | tee -a $outputfilename

cd ../hamilton_float
make clean all

./ourtest 2>&1 | tee -a $outputfilename

if command -v python3.6 &>/dev/null; then
    echo "Python 3.6 is installed"
    python3.6 ../performance/script/display_perf.py $outputfilename
else
    echo "Python 3.6 is not installed"
    python ../performance/script/display_perf.py $outputfilename

fi
