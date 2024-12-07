## DESCRIPTION
This is a code repository for the first project "CO2 emissions and search for renewable energy".

This project is published in Production and Operations Management on Mar 2024. https://doi.org/10.1177/10591478241240126

This project investigates when firms explore environmental technology, which is one of costly environmental strategies. When explaining firms’ environmental strategy, much of prior literature has focused on factors external to the firm, such as pressures from governments, NGOs, investors, supply chain partners, media, and customers (e.g., Berrone et al., 2013; Jira and Toffel, 2013). In this paper, we divert this focus to a factor internal to the firm—intrinsic motivation. Using the framework of the behavioral theory of the firm (BTOF), we argue that firms decrease exploration for environmental technology when their environmental performance increase far above (decrease far below) the environmental performance level they aspired to. We find support for our arguments using patent data on renewable energy technology and CO2 emissions data of U.S. ICT firms. 

### What does this repository have?
+ independent-variable.do
  + STATA do-file for computing independent variables

### Data used for this project
+ For firms' technology search ... (used to contruct main dependent variable)
  + USPTO Patent data [patentsview](https://patentsview.org/download/data-download-tables)
+ For firms' annual emissions ... (used to construct main independent variables)
  + Manual collection from firms' corporate sustainability reports and corporate websites
  + Carbon Disclosure Project (CDP) questionnaires (Proprietary data)
  + Refinitiv (Proprietary data)
+ For control variables ... 
  + Compustat (Proprietary data)
  + External pressures on firms to decrease emissions
    + [Environmental Council of the States](https://www.ecos.org/)
    + Reference: [Berrone et al. 2013](https://onlinelibrary.wiley.com/doi/full/10.1002/smj.2041)
+ For instrumental variables ...
  + [Storm Events Database](https://www.ncdc.noaa.gov/stormevents/ftp.jsp)
  + KLD (Proprietary data)

