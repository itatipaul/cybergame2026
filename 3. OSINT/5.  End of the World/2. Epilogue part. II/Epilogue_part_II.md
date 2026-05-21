# End of the world - Epilogue part II


The challenge includes three screenshots.


## Ender eye

Use a stronghold calculator, for instance: https://stronghold-calculator.pages.dev  


to get a coordinate approximation of where the stronghold can be located. You can get these values from the first two screenshots.


## Seed cracking app


Use https://github.com/cubitect/cubiomes-viewer  


to quickly iterate through. When adding landmarks/biomes, try to draw a bounding box of where the specific feature could be contained, for instance if your stronghold is at `X` `Z`, then do `X1: X - 50` `Z1: Z - 50` `X2: X + 50` `Z2: Z + 50`


## Narrowing down the search


From all the screenshots provided, you can see the biome, and in case of `MC2.png`, you can also see that the screenshot was taken in an abandoned mineshaft. Inputting all this information into cubiomes-viewer is enough to get the right seed in the specified seed range.


`SK-CERT{5293851048}`
