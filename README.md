##Introduction
Use various financial optimization models to construct portfolios from a selected group of stocks.

##Usage:
1. Select your stocks and put them in a separate text file, separate stocks by new lines. 
2. Set the parameters in build_pf.m
3. Run build_pf.m

##Status
Currently support the following models:
*MVO
*Mean-Absolute Deviation

More models will be added in future updates.

##Dependencies
Stock data are retrieved from Finance Yahoo using hist_stock_data.m by Josiah Renfree. hist_stock_data.m is included in this package.