# Automated importation of sea surface temperature data
Matlab functions to import the high-resolution sea surface temperature data from the JPL OurOcean group

[![View Automated importation of sea surface temperature data on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://se.mathworks.com/matlabcentral/fileexchange/87222-automated-importation-of-sea-surface-temperature-data)
[![DOI](https://zenodo.org/badge/337693090.svg)](https://zenodo.org/badge/latestdoi/337693090)
[![Donation](https://camo.githubusercontent.com/a37ab2f2f19af23730565736fb8621eea275aad02f649c8f96959f78388edf45/68747470733a2f2f77617265686f7573652d63616d6f2e636d68312e707366686f737465642e6f72672f316339333962613132323739393662383762623033636630323963313438323165616239616439312f3638373437343730373333613266326636393664363732653733363836393635366336343733326536393666326636323631363436373635326634343666366536313734363532643432373537393235333233303664363532353332333036313235333233303633366636363636363536353264373936353663366336663737363737323635363536653265373337363637)](https://www.buymeacoffee.com/echeynet)

## Summary

The function getSST reads and store the sea surface temperature (SST)  produced daily by the JPL OurOcean group [1]. The dataset is described in more details in Chao et al. [2]. The SST data are available on a grid of 0.009 degree, which represents a horizontal resolution of approximatively  1 km. In the documentation, the second example uses the function borders.m and/or bordersm.m [3,4]. This is the first version of the submission, some bugs may still be present. Credits should go to [1,2] for the dataset.

## Content

The repository contains:
  - The function getSST, which read the netcdf files and extract the SST data, time and corresponding coordinates
  - An example within the Matlab livescript Documentation.mlx
  

## References
[1] https://podaac.jpl.nasa.gov/dataset/JPL_OUROCEAN-L4UHfnd-GLOB-G1SST

[2] Chao, Y., Z. Li, J. D. Farrara, and P. Huang: Blended sea surface  temperatures from multiple satellites and in-situ observations for  coastal oceans, 2009: Journal of Atmospheric and Oceanic Technology, 26  (7), 1435-1446, 10.1175/2009JTECHO592.1

[3]    Greene, Chad A., et al. “The Climate Data Toolbox for MATLAB.”  Geochemistry, Geophysics, Geosystems, American Geophysical Union (AGU),  July 2019, doi:10.1029/2019gc008392.

[4] https://se.mathworks.com/matlabcentral/fileexchange/50390-borders

## Example 1 (case of the North Sea) 

The fitting of the extended SEIR model to real data provides the following results:

![SST map of the North Sea](illustration.jpg)
