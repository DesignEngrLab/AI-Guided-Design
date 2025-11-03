# AI-Guided-Design

This repository contains the source code and relevant materials for "Human-in-the-loop Bayesian Optimization for AI-Guided Design". It includes the code to run the experiments as well as the cleaned up data collected from the user studies.

Note that some of the code was written in different folders and moved here for clarity. Some of the cross references (e.g. in the Analysis folder) may not be updated accordingly.  I probably forgot a bunch of stuff lol.

Please reach out to the authors if you have any questions or need assistance running the code.


## Overview

There are two main folders in this repository: code and data.

#### Code
There are two folders: `GUI` and `Analysis`.

Note that this requires Gaussian Process for Machine Learning (GPML) to run, although includes a `minimize_noprint.m` which is modified from the original `minimize.m` to avoid printing to the console.

To run the experiments, navigate to the `GUI` folder and run the scripts: `guided_design_group_gui.m` or `unguided_design_group_gui.m` for the guided and unguided design experiments respectively. Make sure to add the GPML toolbox to your MATLAB path or in the `dependencies` folder.

*NOTE*: The code includes an additional survey that did not make it into the final paper since it failed for technical reasons on MATLAB online. It should work fine if you run it locally.

The `Analysis` folder contains the code to analyze the data collected from the experiments. The cross references may not be updated accordingly since some of the code was moved here from different folders.

#### Data

Cleaned up data and Cleaned Survey Data folders contain the data collected from the user studies, cross referenced with the original raw data. Some naming issues occured in the original data collection, but the cleaned up data is accurate.

The material comparison sheets are those that take the original material that users entered compared to our measured amount.

The network data contains the design networks of the individual designs created by the users. These were created to look at whether they adhered to the design rules.