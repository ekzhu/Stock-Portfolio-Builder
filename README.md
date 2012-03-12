##Introduction
Use various financial optimization models to construct portfolios from a selected group of stocks. The optimization model should be used for education purpose only. No responsibility for loss incurred when applied to real-world market trading.

##Usage:
1. Select your stocks and put them in a separate text file, separate stocks by new lines. 
2. Set the parameters in *build_pf.m*
3. Run *build_pf.m*

##Status:
Currently contains the following models:

1. MVO
2. Mean-Absolute Deviation

More models will be added in future updates.

##Dependencies:
Stock data are retrieved from Finance Yahoo using *hist_stock_data.m* by Josiah Renfree. *hist_stock_data.m* is included in this package.