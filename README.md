# Implementation of Optical Flow Algorithm

### The implementation has 4 parts:

1. Naive dense optical flow.(`opticalFlow.m`)
  Windowsize and threshold for smallest eigen value are free parameter
  
2. Corner-based sparse optical flow 
  - Corner detection is based on Gaussian deviation (`CornerDetect.m`, `gaussian.m`, `d_gaussian.m`)
  
3.  Iterative Coarse to Fine Optical Flow (details can be found in `report.pdf`)
  - Multi-resolution pyramid (`pyramidFlow.m`)
  - apply Lucas-Kanada optical flow iteratively to estimate potential motion velocity on each level (`iterOpticalflow.m`)
  
4. Experiments
  - Motion based Background Subtraction (`bg.m`)
    Remove the dynamic portions of an image from a static background
  - Motion based Image Segmentation 
