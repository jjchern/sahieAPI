
<!-- README.md is generated from README.Rmd. Please edit that file -->
About
=====

[![Travis-CI Build Status](https://travis-ci.org/jjchern/sahieAPI.svg?branch=master)](https://travis-ci.org/jjchern/sahieAPI)

`sahieAPI` is an R client for Census Bureau's API for [**S**mall **A**rea **H**ealth **I**nsurance **E**stimates (SAHIE)](http://www.census.gov/data/developers/data-sets/Health-Insurance-Statistics.html):

> The Small Area Health Insurance Estimates (SAHIE) program was created to develop model-based estimates of health insurance coverage for counties and states. SAHIE is only source of single-year health insurance coverage estimates for all U.S. counties. This program is partially funded by the Centers for Disease Control and Prevention's (CDC), National Breast and Cervical Cancer Early Detection Program (NBCCEDP). The SAHIE program models health insurance coverage by combining survey data from several sources and then producing timely and accurate estimates of health insurance coverage. Additionally, the SAHIE program's age model methodology and estimates have undergone internal U.S. Census Bureau review as well as external review.

> The SAHIE program produces data for the following domains:

> -   Ages 0-64, 18-64, 40-64, and 50-64
> -   Female, male, and both sexes
> -   All incomes and income-to-poverty ratios (IPR) 0-138, 0-200, 0-250, 0-400, and 138-400 percent of the poverty threshold
> -   For states only: White not Hispanic, Black not Hispanic, and Hispanic (any race)

> Read more about SAHIE here: [SAHIE](http://www.census.gov/did/www/sahie/)

Installation
============

``` r
# install.packages("devtools")
devtools::install_github("jjchern/sahieAPI")
```

Usage
=====

``` r
# Get national level uninsurance rate for various income groups in 2013 and 2014
sahieAPI::sahie_us(
        year = 2013:2014, 
        var = c("NAME", "NUI_PT", "IPR_DESC", "IPRCAT", "PCTUI_PT")
)
#> Source: local data frame [12 x 7]
#> 
#>             NAME   NUI_PT                IPR_DESC IPRCAT PCTUI_PT  time
#>            <chr>    <int>                   <chr>  <int>    <dbl> <int>
#> 1  United States 44477970             All Incomes      0     16.8  2013
#> 2  United States 26179205      <= 200% of Poverty      1     27.9  2013
#> 3  United States 31061686      <= 250% of Poverty      2     26.7  2013
#> 4  United States 18153802      <= 138% of Poverty      3     28.4  2013
#> 5  United States 38978520      <= 400% of Poverty      4     22.7  2013
#> 6  United States 20824718 138% to 400% of Poverty      5     19.3  2013
#> 7  United States 36013970             All Incomes      0     13.5  2014
#> 8  United States 21129964      <= 200% of Poverty      1     22.7  2014
#> 9  United States 25185542      <= 250% of Poverty      2     21.7  2014
#> 10 United States 14570388      <= 138% of Poverty      3     23.2  2014
#> 11 United States 31589074      <= 400% of Poverty      4     18.4  2014
#> 12 United States 17018686 138% to 400% of Poverty      5     15.7  2014
#> Variables not shown: us <int>.
```
