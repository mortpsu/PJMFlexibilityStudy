#!/bin/bash

for jobcounter in {101..130}
do
cd ~/scratch/run-12555460[${jobcounter}]
cp results_${jobcounter}_v5.mat ~/base_50
done
