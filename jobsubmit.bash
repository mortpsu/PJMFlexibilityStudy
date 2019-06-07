#!/bin/bash

for jobcounter in {1..363}
do
qsub -v JOBCOUNT=$jobcounter -N ERCOT_$jobcounter Parallel.pbs 
done
