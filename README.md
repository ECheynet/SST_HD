Automated importation of high-resolution sea surface temperature data
Matlab functions to import the high-resolution sea surface temperature data from the JPL OurOcean group

## Summary

The function getSST reads and store the sea surface temperature (SST)  produced on a daily basis by the JPL OurOcean group [1]. The dataset is described in more details in CHao et al. [2]. The SST data are available on a grid of 0.009 degrees, which represent  a horizontal resolution of approximatively  1 km. The second example works with the function borders.m and/or bordersm.m [3,4]

## Content

The repository contains:
  - The function getFilesName, which extract the addresse of the netcdf files containing the SST data
  - The function getSST, which read the netcdf files and extract the SST data, time and corresponding coordinates
  - An example file Documentation.mlx
  

## References
[1] https://podaac.jpl.nasa.gov/dataset/JPL_OUROCEAN-L4UHfnd-GLOB-G1SST

[2] Chao, Y., Z. Li, J. D. Farrara, and P. Huang: Blended sea surface  temperatures from multiple satellites and in-situ observations for  coastal oceans, 2009: Journal of Atmospheric and Oceanic Technology, 26  (7), 1435-1446, 10.1175/2009JTECHO592.1

[3]    Greene, Chad A., et al. “The Climate Data Toolbox for MATLAB.”  Geochemistry, Geophysics, Geosystems, American Geophysical Union (AGU),  July 2019, doi:10.1029/2019gc008392.

[4] https://se.mathworks.com/matlabcentral/fileexchange/50390-borders

## Example 1 (case of the North Sea) 

The fitting of the extended SEIR model to real data provides the following results:

![SST map of the North Sea](illustration.png)
