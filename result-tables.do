//////////////////////// DO-FILE for result tables////////////////////////////////////
*First created: Jan 20, 2024
*Since our final dataset was constructed using proprietary data sources, we cannot publicy share the data. 

clear
use "~\final_dataset.dta"

local ctr         "regulation_t_1 astspec_t_1  lnslack_avai_t_1 firmsize5_t_1 lnRnDinten_t_1  ROA_t_1"
local ctr_noROA   "regulation_t_1 astspec_t_1  lnslack_avai_t_1 firmsize5_t_1 lnRnDinten_t_1  "
local ctr_noSlack "regulation_t_1 astspec_t_1                   firmsize5_t_1 lnRnDinten_t_1  ROA_t_1"
local ctr_noFS    "regulation_t_1 astspec_t_1  lnslack_avai_t_1               lnRnDinten_t_1  ROA_t_1"
local IV_four     "quar_CO2_SIC_t_1 l_avg_deaths_indirect_t_1 pro_con_x_t_1 pro_con_d_t_1"
local main_IV     "r_D_original  r_A_original  r_B_original"
local main_IDV    "D_comb_s1h9_t_1 A_comb_s1h9_t_1 B_comb_s1h9_t_1"
local tail        "i.year i.gvkey if reg_362 == 1, difficult cluster(gvkey) robust"

*Table 1. Variable Description
*Table 2. Descriptive Statistics
sum    nbwc_to_Y02E  D_comb_s1h9 A_comb_s1h9 B_comb_s1h9 l_other_nbwc_two regulation astspec lnslack_avai firmsize5 lnRnDinten ROA    if !missing(A_comb_s1h9) & !missing(lnRnDinten) & !missing(lnslack_avai) & !missing(regulation) & !missing(pro_con_d) & !missing(lambda_main) & !missing(CO2_ABOVE_his_l_8_dum)
pwcorr nbwc_to_Y02E  D_comb_s1h9 A_comb_s1h9 B_comb_s1h9 l_other_nbwc_two regulation astspec lnslack_avai firmsize5 lnRnDinten ROA    if !missing(A_comb_s1h9) & !missing(lnRnDinten) & !missing(lnslack_avai) & !missing(regulation) & !missing(pro_con_d) & !missing(lambda_main) & !missing(CO2_ABOVE_his_l_8_dum)

*Table 3. Main Result: The impact of CO2 emissions vs. Aspiration on Search
**Model 1. Only control variables
est clear
eststo: qui nbreg nbwc_to_Y02E                     l_other_nbwc_two_t_1  `ctr'  lambda_main  `tail'

**Model 2. Only H1
eststo: qui nbreg nbwc_to_Y02E D_comb_s1h9_t_1     l_other_nbwc_two_t_1  `ctr' lambda_main r_D_original   `tail'

**Model 3. Full Model (H1, H2, H3)
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'         l_other_nbwc_two_t_1  `ctr' lambda_main  `main_IV'  `tail'

*Table 4. Comparison between Non-energy-intensive vs. Energy-intensive
preserve 

clear
use "~\suppl_dataset.dta"

local main_IDV  "D_comb_s1_h9_t_1  A_comb_s1_h9_t_1 B_comb_s1_h9_t_1"
local ctr_noRnD "regulation_t_1 astspec_t_1  lnslack_avai_t_1 firmsize5_t_1   ROA_t_1"
local ctr       "regulation_t_1 astspec_t_1  lnslack_avai_t_1 firmsize5_t_1 lnRnDinten_t_1  ROA_t_1"
local IV        "r_D_ene  r_A_ene  r_B_ene"

sum    nbwc_to_Y02E  D_comb_s1_h9 A_comb_s1_h9 B_comb_s1_h9 l_other_nbwc regulation astspec lnslack_avai firmsize5 lnRnDinten ROA   if !missing(D_comb_s1_h9) & !missing(lnRnDinten) & !missing(lnslack_avai) & !missing(regulation) & !missing(pro_con_d) & !missing(lambda_suppl) & year < 2016 & gvkey != 12053
pwcorr nbwc_to_Y02E  D_comb_s1_h9 A_comb_s1_h9 B_comb_s1_h9 l_other_nbwc regulation astspec lnslack_avai firmsize5 lnRnDinten ROA   if !missing(D_comb_s1_h9) & !missing(lnRnDinten) & !missing(lnslack_avai) & !missing(regulation) & !missing(pro_con_d) & !missing(lambda_suppl) & year < 2016 & gvkey != 12053

est clear
**result without RnDinten
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'  l_other_nbwc_t_1  `ctr_noRnD' lambda_suppl `IV'  i.year i.gvkey, difficult cluster(gvkey) robust
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'  l_other_nbwc_t_1  `ctr_noRnD' lambda_suppl `IV'  i.year i.gvkey if ene_inten_naics_ver2 ==0 , difficult cluster(gvkey) robust
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'  l_other_nbwc_t_1  `ctr_noRnD' lambda_suppl `IV'  i.year i.gvkey if ene_inten_naics_ver2 ==1 , difficult cluster(gvkey) robust

**result with RnDinten (original one)
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'  l_other_nbwc_t_1  `ctr' lambda_suppl `IV'  i.year i.gvkey  , difficult cluster(gvkey) robust
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'  l_other_nbwc_t_1  `ctr' lambda_suppl `IV'  i.year i.gvkey if ene_inten_naics_ver2 == 0 , difficult cluster(gvkey) robust
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'  l_other_nbwc_t_1  `ctr' lambda_suppl `IV'  i.year i.gvkey if ene_inten_naics_ver2 == 1 , difficult cluster(gvkey) robust

**result with RnDinten (alternative one)
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'  l_other_nbwc_t_1  `ctr_noRnD' ln_RnDinten_lt_t_1 lambda_suppl `IV'  i.year i.gvkey  , difficult cluster(gvkey) robust
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'  l_other_nbwc_t_1  `ctr_noRnD' ln_RnDinten_lt_t_1 lambda_suppl `IV'  i.year i.gvkey if ene_inten_naics_ver2 ==0 , difficult cluster(gvkey) robust
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'  l_other_nbwc_t_1  `ctr_noRnD' ln_RnDinten_lt_t_1 lambda_suppl `IV'  i.year i.gvkey if ene_inten_naics_ver2 ==1 , difficult cluster(gvkey) robust

esttab  using "~\main_Table_4.csv"     , cells(b(fmt(3) star) se(par)) stats(r2 ll N, labels(R-squared Log-likelihood N)   ) starlevels(* 0.1 ** 0.05 *** 0.01) varwidth(15)  postfoot( `"{hline @width}"' `"  * p<0.10    ** p<0.05    *** p<0.01  "'   `"  Robust standard errors in parentheses"') replace 
esttab  using "~\main_Table_4_IRR.csv" , cells(b(fmt(3) star) se(par)) stats(r2 ll N, labels(R-squared Log-likelihood N)   ) starlevels(* 0.1 ** 0.05 *** 0.01) varwidth(15)  postfoot( `"{hline @width}"' `"  * p<0.10    ** p<0.05    *** p<0.01  "'   `"  Robust standard errors in parentheses"') eform replace

restore
	
*Table 5. Including controls for financial performance vs. aspiration
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'  D_ROA_s1h9_t_1 A_ROA_s1h9_t_1 B_ROA_s1h9_t_1   l_other_nbwc_two_t_1   `ctr_noROA'  lambda_main_ROA_ROS  `main_IV' `tail'
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'  D_ROS_s1h9_t_1 A_ROS_s1h9_t_1 B_ROS_s1h9_t_1   l_other_nbwc_two_t_1   `ctr_noROA'  lambda_main_ROA_ROS  `main_IV' `tail'
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'  D_EPS_s1h9_t_1 A_EPS_s1h9_t_1 B_EPS_s1h9_t_1   l_other_nbwc_two_t_1   `ctr_noROA'  lambda_main_EPS      `main_IV' `tail'

*Table 6. Including controls for concern on clean energy, incentive payment to managers
eststo: qui nbreg nbwc_to_Y02E `main_IDV'  env_str_d_ver2_t_1   l_other_nbwc_two_t_1  `ctr'  lambda_main_env_str_d  `main_IV' `tail'
eststo: qui nbreg nbwc_to_Y02E `main_IDV'  C1_2_dum_t_1         l_other_nbwc_two_t_1  `ctr'  lambda_main_incen      `main_IV' i.year i.gvkey if reg_362 == 1 & !missing(incen_money_new_t_1), difficult cluster(gvkey) robust
eststo: qui nbreg nbwc_to_Y02E `main_IDV'  incen_money_new_t_1  l_other_nbwc_two_t_1  `ctr'  lambda_main_incen      `main_IV' `tail'

esttab  using "~\main_Table_3_5_6.csv"     , cells(b(fmt(3) star) se(par)) stats(r2 ll N, labels(R-squared Log-likelihood N)   ) starlevels(* 0.1 ** 0.05 *** 0.01) varwidth(15)  postfoot( `"{hline @width}"' `"  * p<0.10    ** p<0.05    *** p<0.01  "'   `"  Robust standard errors in parentheses"') replace 
esttab  using "~\main_Table_3_5_6_IRR.csv" , cells(b(fmt(3) star) se(par)) stats(r2 ll N, labels(R-squared Log-likelihood N)   ) starlevels(* 0.1 ** 0.05 *** 0.01) varwidth(15)  postfoot( `"{hline @width}"' `"  * p<0.10    ** p<0.05    *** p<0.01  "'   `"  Robust standard errors in parentheses"') eform replace


*Table A1. List of firms in Final Sample (74 firms)
*Table A2. Heckman first stage

est clear

eststo: qui xtprobit samp_new_409   				  `ctr' i.year, re i(gvkey) vce(robust)
eststo: qui xtprobit samp_new_409 report_num_hq_t_1               `ctr' i.year, re i(gvkey) vce(robust)

*Table A3a. Instrumental validity tests
ivreg2 nbwc_to_Y02E l_other_nbwc_two_t_1  `ctr' (`main_IDV' = `IV_four') lambda_main i.year i.gvkey if  !missing(CO2_ABOVE_his_l_8_dum_t_1), robust cluster(gvkey) ffirst  partial(i.gvkey)

*Table A3b. Endogeneity and control function approach - first stage results
eststo: qui xtprobit D_comb_s1h9_t_1  `IV_four'                                 i.year if reg_362 ==1, re i(gvkey)  vce(robust) difficult
eststo: qui xtprobit D_comb_s1h9_t_1             l_other_nbwc_two_t_1   `ctr'   i.year if reg_362 ==1, re i(gvkey)  vce(robust) difficult
eststo: qui xtprobit D_comb_s1h9_t_1  `IV_four'  l_other_nbwc_two_t_1   `ctr'   i.year if reg_362 ==1, re i(gvkey)  vce(robust) difficult

eststo: qui reg A_comb_s1h9_t_1   `IV_four'                            `ctr'    i.year i.gvkey if reg_362 ==1, robust cluster(gvkey)
eststo: qui reg A_comb_s1h9_t_1               l_other_nbwc_two_t_1     `ctr'    i.year i.gvkey if reg_362 ==1, robust cluster(gvkey)
eststo: qui reg A_comb_s1h9_t_1   `IV_four'   l_other_nbwc_two_t_1     `ctr'    i.year i.gvkey if reg_362 ==1, robust cluster(gvkey)

eststo: qui reg B_comb_s1h9_t_1   `IV_four'                            `ctr'    i.year i.gvkey if reg_362 ==1, robust cluster(gvkey)
eststo: qui reg B_comb_s1h9_t_1               l_other_nbwc_two_t_1     `ctr'    i.year i.gvkey if reg_362 ==1, robust cluster(gvkey)
eststo: qui reg B_comb_s1h9_t_1   `IV_four'   l_other_nbwc_two_t_1     `ctr'    i.year i.gvkey if reg_362 ==1, robust cluster(gvkey)

*Table A4. Desciptive statistics (sample: firms in all sectors)
***Same code as Table 4

*Table A5. Adding contrl variables: Total energy use, Innovation score, GRI, duration
**Model 1. Only duration. No IDVs
eststo: qui nbreg nbwc_to_Y02E               A_dur_s1h9_t_1 B_dur_s1h9_t_1 l_other_nbwc_two_t_1  `ctr'  lambda_main  `main_IV' `tail'

**Model 2. Duration & IDVs
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'   A_dur_s1h9_t_1 B_dur_s1h9_t_1 l_other_nbwc_two_t_1  `ctr'  lambda_main `main_IV' `tail'

**Model 3. No Duration & IDVs & Total energy use & Innovation score & GRI
eststo: qui nbreg nbwc_to_Y02E `main_IDV'   ln_total_energy_use_t_1 InnovationScore_t_1 GRI_t_1  l_other_nbwc_two_t_1    `ctr' lambda_main_TIG  `main_IV' i.gvkey i.year, robust cluster(gvkey)

**Model 4. Full (Duration & IDVs & Total energy use & Innovation score & GRI)
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'  A_dur_s1h9_t_1 B_dur_s1h9_t_1 ln_total_energy_use_t_1 InnovationScore_t_1 GRI_t_1  l_other_nbwc_two_t_1   `ctr'  lambda_main_TIG  `main_IV' `tail'


*Table A6. Adding control variables: Controls for CA-headquartered from 2012, ETS participation, Carbon credit transaction
**Model 1. Adding CA-headquartered
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'  CAT_CA_t_1                                 l_other_nbwc_two_t_1  `ctr'  lambda_main `main_IV' `tail'

**Model 2. Adding ETS part, Carbon credit transaction
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'  ETS_part_t_1 carbon_credit_t_1             l_other_nbwc_two_t_1   `ctr'  lambda_main_ETS `main_IV' `tail'

**Model 3. Full (CA-headquartered, ETS part, Carbon credit transaction)
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'  CAT_CA_t_1 ETS_part_t_1 carbon_credit_t_1  l_other_nbwc_two_t_1  `ctr'   lambda_main_ETS `main_IV' `tail'

*Table A7. Alternative Estimation method
**Model 1. Poisson
eststo: qui poisson nbwc_to_Y02E `main_IDV' l_other_nbwc_two_t_1  `ctr'  lambda_main `main_IV' `tail'

**Model 2. ZINB
eststo: qui  zinb    nbwc_to_Y02E `main_IDV' l_other_nbwc_two_t_1  `ctr'  lambda_main `main_IV'  i.year i.gvkey if reg_362 == 1, inflate(`ctr_noROA')  cluster(gvkey) difficult robust

***nbreg nbwc_to_Y02E `main_IDV'      l_other_nbwc_two_t_1  `ctr' lambda_main   `main_IV'  i.gvkey i.year, difficult
***>>> LR test of alpha=0: chibar2(01) = 276.47               Prob >= chibar2 = 0.000
*** nbvargr    nbwc_to_Y02E  if reg_362 == 1

*Table A8. Alternative measures of control variables
**Model 1. Financial performance (ROS)
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'  l_other_nbwc_two_t_1  `ctr_noROA'    ROS_t_1            lambda_main_A8_ROS  `main_IV' `tail'

**Model 2. Financial performance (EPS)
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'  l_other_nbwc_two_t_1  `ctr_noROA'    EPS_t_1            lambda_main_A8_EPS  `main_IV' `tail'

**Model 3. Slack (profit margin)
eststo: qui nbreg nbwc_to_Y02E `main_IDV'   l_other_nbwc_two_t_1  `ctr_noSlack'  ib_revt_t_1        lambda_main_A8_ibrevt `main_IV' `tail'

**Model 4. Slack (potential slack)
eststo: qui nbreg nbwc_to_Y02E `main_IDV'   l_other_nbwc_two_t_1  `ctr_noSlack'  lnslack_poten_t_1  lambda_main_A8_slpoten `main_IV' `tail'

**Model 5. Slack (slack index)
eststo: qui nbreg nbwc_to_Y02E `main_IDV'   l_other_nbwc_two_t_1  `ctr_noSlack'  lnslack_index_t_1  lambda_main_A8_slind   `main_IV' `tail'

**Model 6. Firm size (employees)
eststo: qui nbreg nbwc_to_Y02E `main_IDV'   l_other_nbwc_two_t_1  `ctr_noFS'     firmsize1_t_1      lambda_main_A8_fs1 `main_IV' `tail'

**Model 7. Firm size (total asset)
eststo: qui nbreg nbwc_to_Y02E `main_IDV'   l_other_nbwc_two_t_1  `ctr_noFS'     firmsize2_t_1      lambda_main_A8_fs2  `main_IV' `tail'

**Model 8. Firm size (total asset by net sales) 
eststo: qui nbreg nbwc_to_Y02E `main_IDV'   l_other_nbwc_two_t_1  `ctr_noFS'     firmsize3_t_1      lambda_main_A8_fs3  `main_IV' `tail'

**Model 9. Firm size (market capitalization)
eststo: qui nbreg nbwc_to_Y02E `main_IDV'   l_other_nbwc_two_t_1  `ctr_noFS'     firmsize4_t_1      lambda_main_A8_fs4  `main_IV' `tail'


*Table A9. Alternative measures of aspiration: Intensity-based measures of emissions, real emissions
**Model 1. cogs
eststo: qui nbreg nbwc_to_Y02E D_cogs_s1h9_v2_t_1 A_cogs_s1h9_v2_t_1 B_cogs_s1h9_v2_t_1           l_other_nbwc_two_t_1 `ctr'   lambda_main_cogs  r_D_original_cogs r_A_original_cogs r_B_original_cogs `tail'

**Model 2. invt
eststo: qui nbreg nbwc_to_Y02E  D_invt_s1h9_v2_t_1 A_invt_s1h9_v2_t_1 B_invt_s1h9_v2_t_1          l_other_nbwc_two_t_1  `ctr'  lambda_main_invt  r_D_original_invt r_A_original_invt r_B_original_invt  `tail'

**Model 3. real emissiosn
eststo: qui nbreg nbwc_to_Y02E CO2_ABOVE_d_l_real_t_1 CO2_ABOVE_l_real_t_1 CO2_BELOW_l_real_t_1   l_other_nbwc_two_t_1  `ctr'  lambda_main_real  r_D_original_real r_A_original_real r_B_original_real     i.year i.gvkey if !missing(t_scope1n2) & reg_362 == 1, difficult cluster(gvkey)


*Table A10. Alternative measures of aspiration: Predicted emissions
eststo: qui nbreg nbwc_to_Y02E  Dum_ABOVE_holt_t_1 ABOVE_holt_t_1 BELOW_holt_t_1  l_other_nbwc_two_t_1  `ctr'   lambda_main  r_D_original_holt r_A_original_holt r_B_original_holt   i.year i.gvkey, robust cluster(gvkey) difficult


*Table A11. Alternative dependent variable: self-citation vs. non-self-citation
**Model 1. self-citation
eststo: qui  zinb  adj_C_self_nbwc_to_Y02E   `main_IDV'   l_other_nbwc_two_t_1  `ctr'  lambda_main  `main_IV'  i.gvkey i.year if reg_362 == 1, inflate(astspec_t_1  firmsize5_t_1 lnRnDinten_t_1)  cluster(gvkey) difficult robust
**Model 2. non-self-citation
eststo: qui nbreg adj_C_others_nbwc_to_Y02E  `main_IDV'   l_other_nbwc_two_t_1  `ctr'  lambda_main  `main_IV' `tail' 


*Table A12. Alternative dependent variable: in-house vs. acquired
**Model 1. in-house
eststo: qui nbreg nbwc_to_Y02E_inhouse      `main_IDV'   l_other_nbwc_inhouse_t_1  `ctr'  lambda_main `main_IV' `tail'

**Model 2. acquired
eststo: qui zinb  nbwc_to_Y02E_acquire      `main_IDV'   l_other_nbwc_acquire_t_1  `ctr'  lambda_main  `main_IV'  i.gvkey i.year if reg_362 == 1, inflate(`ctr_noROA')  cluster(gvkey) difficult robust


*Table A13a. Split-sample analysis: High- vs. Low-energy usage
**Model 1. High-energy
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'     l_other_nbwc_two_t_1  `ctr'   lambda_main  `main_IV'  i.gvkey i.year  if ABOVE_avg_ene_naics_new_2 == 1, robust cluster(gvkey) difficult

**Model 2. Low-energy
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'     l_other_nbwc_two_t_1  `ctr'   lambda_main  `main_IV'  i.gvkey i.year  if ABOVE_avg_ene_naics_new_2 == 0, robust cluster(gvkey) difficult

***Wald test using suest 
*qui nbreg nbwc_to_Y02E  `main_IDV'     l_other_nbwc_two_t_1  `ctr'   lambda_main  `main_IV'  i.gvkey i.year  if ABOVE_avg_ene_naics_new_2 == 1, difficult
*est store high
*gen gvkey_2 = gvkey
*qui nbreg nbwc_to_Y02E  `main_IDV'     l_other_nbwc_two_t_1  `ctr'   lambda_main  `main_IV'  i.gvkey_2 i.year  if ABOVE_avg_ene_naics_new_2 == 0, difficult
*est store low
*suest high low, cluster(gvkey) robust

*test _b[high_nbwc_to_Y02E:D_comb_s1h9_t_1] = _b[low_nbwc_to_Y02E:D_comb_s1h9_t_1]
*           chi2(  1) =    0.02
*         Prob > chi2 =    0.8836

*test _b[high_nbwc_to_Y02E:A_comb_s1h9_t_1] = _b[low_nbwc_to_Y02E:A_comb_s1h9_t_1]
*          chi2(  1) =    5.92
*        Prob > chi2 =    0.0150

*test _b[high_nbwc_to_Y02E:B_comb_s1h9_t_1] = _b[low_nbwc_to_Y02E:B_comb_s1h9_t_1]
*           chi2(  1) =    5.48
*         Prob > chi2 =    0.0193


*Table A14. Split-sample analysis: Manufacturing vs. Service
**Model 1. Manufacturing
eststo: qui nbreg nbwc_to_Y02E   `main_IDV'    l_other_nbwc_two_t_1  `ctr'  lambda_main  `main_IV'  i.gvkey i.year  if naics_new_class_v2  == 1, robust cluster(gvkey) difficult

**Model 2. Service
eststo: qui nbreg nbwc_to_Y02E   `main_IDV'    l_other_nbwc_two_t_1  `ctr'  lambda_main  `main_IV'  i.gvkey i.year  if naics_new_class_v2  == 2, robust cluster(gvkey) difficult

***Wald test using suest 
*qui nbreg nbwc_to_Y02E   `main_IDV'    l_other_nbwc_two_t_1  `ctr'  lambda_main  `main_IV'  i.gvkey i.year  if naics_new_class_v2  == 1,  difficult
*est store manu
*gen gvkey_2 = gvkey
*qui nbreg nbwc_to_Y02E   `main_IDV'    l_other_nbwc_two_t_1  `ctr'  lambda_main  `main_IV'  i.gvkey_2 i.year  if naics_new_class_v2  == 2, difficult
*est store ser
*suest manu ser, cluster(gvkey) robust

*test _b[manu_nbwc_to_Y02E:D_comb_s1h9_t_1] = _b[ser_nbwc_to_Y02E:D_comb_s1h9_t_1]
*           chi2(  1) =    0.82
*         Prob > chi2 =    0.3638

*test _b[manu_nbwc_to_Y02E:A_comb_s1h9_t_1] = _b[ser_nbwc_to_Y02E:A_comb_s1h9_t_1]
*          chi2(  1) =    0.20
*        Prob > chi2 =    0.6547

*test _b[manu_nbwc_to_Y02E:B_comb_s1h9_t_1] = _b[ser_nbwc_to_Y02E:B_comb_s1h9_t_1]
*           chi2(  1) =    1.93
*         Prob > chi2 =    0.1643


*Table A15. Split-sample analysis: Datacenter importance High vs. Low
**Model 1. High
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'     l_other_nbwc_two_t_1  `ctr'  lambda_main  `main_IV'  i.gvkey i.year  if datacenter  == 1, robust cluster(gvkey) difficult

**Model 2. Low
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'     l_other_nbwc_two_t_1  `ctr'  lambda_main  `main_IV'  i.gvkey i.year  if datacenter  == 0, robust cluster(gvkey) difficult

***Wald test using suest 
*qui nbreg nbwc_to_Y02E  `main_IDV'     l_other_nbwc_two_t_1  `ctr'  lambda_main  `main_IV'  i.gvkey i.year  if datacenter  == 1,  difficult
*est store high
*gen gvkey_2 = gvkey
*qui qui nbreg nbwc_to_Y02E  `main_IDV'     l_other_nbwc_two_t_1  `ctr'  lambda_main  `main_IV'  i.gvkey_2 i.year  if datacenter  == 0,  difficult
*est store low
*suest high low, cluster(gvkey) robust

*test _b[high_nbwc_to_Y02E:D_comb_s1h9_t_1] = _b[low_nbwc_to_Y02E:D_comb_s1h9_t_1]
*           chi2(  1) =    10.03
*         Prob > chi2 =    0.0015

*test _b[high_nbwc_to_Y02E:A_comb_s1h9_t_1] = _b[low_nbwc_to_Y02E:A_comb_s1h9_t_1]
*          chi2(  1) =    0.78
*        Prob > chi2 =    0.3775

*test _b[high_nbwc_to_Y02E:B_comb_s1h9_t_1] = _b[low_nbwc_to_Y02E:B_comb_s1h9_t_1]
*           chi2(  1) =    0.00
*         Prob > chi2 =    0.9578


*Table A16. Post-hoc Analysis (1) Aspiration level constructed based on hist only vs. social only
**Model 1. Historical only
eststo: qui nbreg nbwc_to_Y02E CO2_ABOVE_his_l_8_dum_t_1 CO2_ABOVE_his_l_8_t_1   CO2_BELOW_his_l_8_t_1   l_other_nbwc_two_t_1  `ctr'  lambda_main_his r_D_original_his r_A_original_his r_B_original_his  `tail' 
**Model 2. Social only
eststo: qui nbreg nbwc_to_Y02E D_soc_ver1_ps5_t_1        A_soc_ver1_ps5_t_1      B_soc_ver1_ps5_t_1      l_other_nbwc_two_t_1  `ctr'  lambda_main_soc r_D_original_soc r_A_original_soc r_B_original_soc  `tail' 

*Table A17. Post-hoc Analysis (2) DV = Energy Purchased
eststo: qui reg ln_elec_purch   `main_IDV'   l_other_nbwc_two_t_1  `ctr'  lambda_main_elec_purch    `main_IV' i.gvkey i.year, robust cluster(gvkey)
eststo: qui reg ln_renew_purch  `main_IDV'   l_other_nbwc_two_t_1  `ctr'  lambda_main_renew_purch   `main_IV' i.gvkey i.year, robust cluster(gvkey)  
eststo: qui reg ln_energy_purch `main_IDV'   l_other_nbwc_two_t_1 `ctr'   lambda_main_energy_purch  `main_IV' i.gvkey i.year, robust cluster(gvkey)

eststo: qui reg ln_elec_purch    `main_IDV'  l_other_nbwc_two_t_1  `ctr'  lambda_main_elec_purch    C12_1_cate_t_1   `main_IV' i.gvkey i.year, robust cluster(gvkey)
eststo: qui reg ln_renew_purch   `main_IDV'  l_other_nbwc_two_t_1  `ctr'  lambda_main_renew_purch   C12_1_cate_t_1   `main_IV' i.gvkey i.year, robust cluster(gvkey)
eststo: qui reg ln_energy_purch  `main_IDV'  l_other_nbwc_two_t_1  `ctr'  lambda_main_energy_purch  C12_1_cate_t_1   `main_IV' i.gvkey i.year, robust cluster(gvkey)

*C12_1_cate: from CDP questionnaire
*total operational spend on energy
*more than 0% ~ but less than or equal to 10% ..
*large number of C12_1_cate means that the firm spends a lot for energy spending


*Table A18. Post-hoc Analysis (3) DV = Environmental Product Development
eststo: qui reg  ln_Env_Product CO2_ABOVE_his_l_8_dum_t_1 CO2_ABOVE_his_l_8_t_1   CO2_BELOW_his_l_8_t_1   l_other_nbwc_two_t_1  `ctr'   lambda_main_Env_Prod r_D_original_his r_A_original_his r_B_original_his  i.gvkey i.year if reg_362 == 1, cluster(gvkey) robust
eststo: qui reg  ln_Env_Product D_soc_ver1_ps5_t_1        A_soc_ver1_ps5_t_1      B_soc_ver1_ps5_t_1      l_other_nbwc_two_t_1  `ctr'   lambda_main_Env_Prod r_D_original_soc r_A_original_soc r_B_original_soc   i.gvkey i.year if reg_362 == 1, cluster(gvkey) robust


*Table A19. Varying levels of alpha when computing historical aspiration
foreach x of numlist 1/9 {
	eststo: qui  nbreg nbwc_to_Y02E CO2_ABOVE_his_l_`x'_dum_t_1 CO2_ABOVE_his_l_`x'_t_1   CO2_BELOW_his_l_`x'_t_1   l_other_nbwc_two_t_1  `ctr' lambda_main_his  i.year i.gvkey if reg_362==1, robust cluster(gvkey)  difficult
}

eststo: qui  nbreg nbwc_to_Y02E `main_IDV'      l_other_nbwc_two_t_1  `ctr' lambda_main  `main_IV'    `tail' 


*Table A20. Social aspiration - Different peer size
foreach num of numlist 3 4 6 7 {
eststo: qui nbreg nbwc_to_Y02E D_comb_s1h9_ps`num'_t_1   A_comb_s1h9_ps`num'_t_1   B_comb_s1h9_ps`num'_t_1     l_other_nbwc_two_t_1  `ctr'  lambda_main   r_D_ori_s1h9_ps`num' r_A_ori_s1h9_ps`num' r_B_ori_s1h9_ps`num'  `tail'
}


*Table A21a. Combined aspiration different weighted scheme (Variable on Poor Emissions Performance Indicator)
eststo: qui nbreg nbwc_to_Y02E       D_comb_s1h9_t_1      l_other_nbwc_two_t_1    `ctr' lambda_main r_D_original  `tail'
foreach x of numlist 2/9 {
	local w = 10 - `x'
	eststo: qui nbreg nbwc_to_Y02E   D_comb_s`x'h`w'_t_1   l_other_nbwc_two_t_1   `ctr' lambda_main  r_D_ori_s`x'h`w'  `tail' 
}


*Table A21b. Combined aspiration different weighted scheme (Variables on Degree of Poor Emissions Performance and Degree of Good Emissions Performance)
eststo: qui nbreg nbwc_to_Y02E A_comb_s1h9_t_1 B_comb_s1h9_t_1    l_other_nbwc_two_t_1  `ctr' lambda_main  r_A_original  r_B_original  `tail'
foreach x of numlist 2/9 {
	local w = 10 - `x'
	eststo: qui nbreg nbwc_to_Y02E A_comb_s`x'h`w'_t_1 B_comb_s`x'h`w'_t_1   l_other_nbwc_two_t_1   `ctr' lambda_main  r_A_ori_s`x'h`w' r_B_ori_s`x'h`w'  `tail' 
}


*Table A22. Alternative DV = Ratio-based DV
**Model 1. DV = Ratio (our IDV)
eststo: qui reg DV_ratio_ver2_two `main_IDV'                                            `ctr'  lambda_main   `main_IV'  i.gvkey i.year if reg_362 == 1, cluster(gvkey) 

**Model 2. DV = Ratio (logged-IDV)
eststo: qui reg DV_ratio_ver2_two D_comb_s1h9_t_1 l_A_comb_s1h9_t_1 l_B_comb_s1h9_t_1   `ctr'  lambda_main r_D_original r_A_original_log r_B_original_log   i.gvkey i.year  if reg_362 == 1, cluster(gvkey)


*Table A23. Dependent Variable of Energy Purchased, with Independent Variables Constructed Based on Historical Aspiration Only or Social Aspiration Only
local historical "CO2_ABOVE_his_l_8_dum_t_1 CO2_ABOVE_his_l_8_t_1   CO2_BELOW_his_l_8_t_1"
local social "D_soc_ver1_ps5_t_1 A_soc_ver1_ps5_t_1 B_soc_ver1_ps5_t_1"

local his_IV "r_D_original_his r_A_original_his r_B_original_his"
local soc_IV "r_D_original_soc r_A_original_soc r_B_original_soc"

*****electricity purchase
eststo: qui reg ln_elec_purch  `historical'  l_other_nbwc_two_t_1  `ctr'  lambda_main_elec_purch   `his_IV' i.gvkey i.year, robust cluster(gvkey)
eststo: qui reg ln_elec_purch  `social'      l_other_nbwc_two_t_1  `ctr'  lambda_main_elec_purch   `soc_IV' i.gvkey i.year if !missing(CO2_ABOVE_his_l_8_dum_t_1), robust cluster(gvkey)

*****renew purchase
eststo: qui reg ln_renew_purch `historical'  l_other_nbwc_two_t_1  `ctr'  lambda_main_renew_purch  `his_IV' i.gvkey i.year, robust cluster(gvkey)
eststo: qui reg ln_renew_purch `social'      l_other_nbwc_two_t_1  `ctr'  lambda_main_renew_purch  `soc_IV' i.gvkey i.year if !missing(CO2_ABOVE_his_l_8_dum_t_1), robust cluster(gvkey)

*****energy purchase
eststo: qui reg ln_energy_purch `historical' l_other_nbwc_two_t_1  `ctr'  lambda_main_energy_purch `his_IV' i.gvkey i.year, robust cluster(gvkey)
eststo: qui reg ln_energy_purch `social'     l_other_nbwc_two_t_1  `ctr'  lambda_main_energy_purch `soc_IV' i.gvkey i.year if !missing(CO2_ABOVE_his_l_8_dum_t_1), robust cluster(gvkey)
	

*Table A24. Robustness of Main analysis (Bootstrap)
preserve
keep if reg_362 == 1
capture program drop my_clust_mvreg_bs
program define my_clust_mvreg_bs, rclass
    nbreg nbwc_to_Y02E      l_other_nbwc_two_t_1  regulation_t_1 astspec_t_1  lnslack_avai_t_1 firmsize5_t_1 lnRnDinten_t_1  ROA_t_1 lambda_main   i.year i.gvkey, difficult cluster(gvkey)
	
	local b4 = _b[nbwc_to_Y02E:l_other_nbwc_two_t_1]
	local b5 = _b[nbwc_to_Y02E:regulation_t_1]
	local b6 = _b[nbwc_to_Y02E:astspec_t_1]
	local b7 = _b[nbwc_to_Y02E:lnslack_avai_t_1]
	local b8 = _b[nbwc_to_Y02E:firmsize5_t_1]
	local b9 = _b[nbwc_to_Y02E:lnRnDinten_t_1]
	local b10 = _b[nbwc_to_Y02E:ROA_t_1]
	local b11 = _b[nbwc_to_Y02E:lambda_main]
	local b15 = e(ll)
	local b16 = _b[_cons]

    ereturn clear
	return scalar b4 = `b4'
	return scalar b5 = `b5'
	return scalar b6 = `b6'
	return scalar b7 = `b7'
	return scalar b8 = `b8'
	return scalar b9 = `b9'
	return scalar b10 = `b10'
	return scalar b11 = `b11'
	return scalar b15 = `b15'
	return scalar b16 = `b16'

end
bootstrap   l_other_nbwc_two_t_1=r(b4) regulation_t_1=r(b5) astspec_t_1=r(b6) lnslack_avai_t_1=r(b7) firmsize5_t_1=r(b8) lnRnDinten_t_1=r(b9) ROA_t_1=r(b10) lambda_main=r(b11) Constant=r(b16) log_likelihood = r(b15) , reps(1000) seed(9876) cluster(gvkey) idcluster(new_gvkey) group(gvkey): my_clust_mvreg_bs
est store model1

capture program drop my_clust_mvreg_bs
program define my_clust_mvreg_bs, rclass
    nbreg nbwc_to_Y02E D_comb_s1h9_t_1     l_other_nbwc_two_t_1  regulation_t_1 astspec_t_1  lnslack_avai_t_1 firmsize5_t_1 lnRnDinten_t_1  ROA_t_1 lambda_main r_D_original   i.year i.gvkey , difficult cluster(gvkey)
	
    local b1 = _b[nbwc_to_Y02E:D_comb_s1h9_t_1]
	local b4 = _b[nbwc_to_Y02E:l_other_nbwc_two_t_1]
	local b5 = _b[nbwc_to_Y02E:regulation_t_1]
	local b6 = _b[nbwc_to_Y02E:astspec_t_1]
	local b7 = _b[nbwc_to_Y02E:lnslack_avai_t_1]
	local b8 = _b[nbwc_to_Y02E:firmsize5_t_1]
	local b9 = _b[nbwc_to_Y02E:lnRnDinten_t_1]
	local b10 = _b[nbwc_to_Y02E:ROA_t_1]
	local b11 = _b[nbwc_to_Y02E:lambda_main]
	local b12 = _b[nbwc_to_Y02E:r_D_original]
	local b15 = e(ll)
	local b16 = _b[_cons]

    ereturn clear
    return scalar b1 = `b1'
	return scalar b4 = `b4'
	return scalar b5 = `b5'
	return scalar b6 = `b6'
	return scalar b7 = `b7'
	return scalar b8 = `b8'
	return scalar b9 = `b9'
	return scalar b10 = `b10'
	return scalar b11 = `b11'
	return scalar b12 = `b12'
	return scalar b15 = `b15'
	return scalar b16 = `b16'

end
bootstrap Dummy=r(b1)  l_other_nbwc_two_t_1=r(b4) regulation_t_1=r(b5) astspec_t_1=r(b6) lnslack_avai_t_1=r(b7) firmsize5_t_1=r(b8) lnRnDinten_t_1=r(b9) ROA_t_1=r(b10) lambda_main=r(b11) r_D_original=r(b12) Constant=r(b16)  log_likelihood = r(b15) , reps(1000) seed(9876) cluster(gvkey) idcluster(new_gvkey) group(gvkey): my_clust_mvreg_bs
est store model2

capture program drop my_clust_mvreg_bs
program define my_clust_mvreg_bs, rclass

	nbreg nbwc_to_Y02E   D_comb_s1h9_t_1 A_comb_s1h9_t_1 B_comb_s1h9_t_1  l_other_nbwc_two_t_1 regulation_t_1 astspec_t_1  lnslack_avai_t_1 firmsize5_t_1 lnRnDinten_t_1  ROA_t_1  lambda_main  r_D_original  r_A_original  r_B_original  i.gvkey i.year, difficult cluster(gvkey)

	local b1 = _b[nbwc_to_Y02E:D_comb_s1h9_t_1]
	local b2 = _b[nbwc_to_Y02E:A_comb_s1h9_t_1]
	local b3 = _b[nbwc_to_Y02E:B_comb_s1h9_t_1]
	local b4 = _b[nbwc_to_Y02E:l_other_nbwc_two_t_1]
	local b5 = _b[nbwc_to_Y02E:regulation_t_1]
	local b6 = _b[nbwc_to_Y02E:astspec_t_1]
	local b7 = _b[nbwc_to_Y02E:lnslack_avai_t_1]
	local b8 = _b[nbwc_to_Y02E:firmsize5_t_1]
	local b9 = _b[nbwc_to_Y02E:lnRnDinten_t_1]
	local b10 = _b[nbwc_to_Y02E:ROA_t_1]
	local b11 = _b[nbwc_to_Y02E:lambda_main]
	local b12 = _b[nbwc_to_Y02E:r_D_original]
	local b13 = _b[nbwc_to_Y02E:r_A_original]
	local b14 = _b[nbwc_to_Y02E:r_B_original]
	local b15 = e(ll)
	local b16 = _b[_cons]
	ereturn clear
	return scalar b1 = `b1'
	return scalar b2 = `b2'
	return scalar b3 = `b3'
	return scalar b4 = `b4'
	return scalar b5 = `b5'
	return scalar b6 = `b6'
	return scalar b7 = `b7'
	return scalar b8 = `b8'
	return scalar b9 = `b9'
	return scalar b10 = `b10'
	return scalar b11 = `b11'
	return scalar b12 = `b12'
	return scalar b13 = `b13'
	return scalar b14 = `b14'
	return scalar b15 = `b15'
	return scalar b16 = `b16'
end

bootstrap Dummy=r(b1) ABOVE=r(b2) BELOW=r(b3) l_other_nbwc_two_t_1=r(b4) regulation_t_1=r(b5) astspec_t_1=r(b6) lnslack_avai_t_1=r(b7) firmsize5_t_1=r(b8) lnRnDinten_t_1=r(b9) ROA_t_1=r(b10) lambda_main=r(b11) r_D_original=r(b12) r_A_original=r(b13) r_B_original=r(b14) Constant=r(b16) log_likelihood = r(b15) , reps(500) seed(9876) cluster(gvkey) idcluster(new_gvkey) group(gvkey): my_clust_mvreg_bs
bootstrap Dummy=r(b1) ABOVE=r(b2) BELOW=r(b3) l_other_nbwc_two_t_1=r(b4) regulation_t_1=r(b5) astspec_t_1=r(b6) lnslack_avai_t_1=r(b7) firmsize5_t_1=r(b8) lnRnDinten_t_1=r(b9) ROA_t_1=r(b10) lambda_main=r(b11) r_D_original=r(b12) r_A_original=r(b13) r_B_original=r(b14) Constant=r(b16) log_likelihood = r(b15) , reps(1000) seed(9876) cluster(gvkey) idcluster(new_gvkey) group(gvkey): my_clust_mvreg_bs
bootstrap Dummy=r(b1) ABOVE=r(b2) BELOW=r(b3) l_other_nbwc_two_t_1=r(b4) regulation_t_1=r(b5) astspec_t_1=r(b6) lnslack_avai_t_1=r(b7) firmsize5_t_1=r(b8) lnRnDinten_t_1=r(b9) ROA_t_1=r(b10) lambda_main=r(b11) r_D_original=r(b12) r_A_original=r(b13) r_B_original=r(b14) Constant=r(b16) log_likelihood = r(b15) , reps(2000) seed(9876) cluster(gvkey) idcluster(new_gvkey) group(gvkey): my_clust_mvreg_bs

esttab model1 model2 model3 using "~\appendix_Table_A24.csv" , cells(b(fmt(3) star) se(par)) stats(r2 ll N, labels(R-squared Log-likelihood N)   ) starlevels(* 0.1 ** 0.05 *** 0.01) varwidth(15)  postfoot( `"{hline @width}"' `"  * p<0.10    ** p<0.05    *** p<0.01  "'   `"  Robust standard errors in parentheses"') 
esttab model1 model2 model3 using "~\appendix_Table_A24_IRR.csv" , cells(b(fmt(3) star) se(par)) stats(r2 ll N, labels(R-squared Log-likelihood N)   ) starlevels(* 0.1 ** 0.05 *** 0.01) varwidth(15)  postfoot( `"{hline @width}"' `"  * p<0.10    ** p<0.05    *** p<0.01  "'   `"  Robust standard errors in parentheses"') eform
restore

*Table A25. Robustness of Main analysis (alternative IVs)
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'   l_other_nbwc_two_t_1  `ctr' lambda_hat_3rd_rev3 r_D_robust r_A_robust r_B_robust  i.gvkey i.year if reg_382 == 1, robust cluster(gvkey) difficult

*Table A25a. Instrumental validity tests (alternative IVs)
ivreg2 nbwc_to_Y02E l_other_nbwc_two_t_1  regulation_t_1 astspec_t_1  lnslack_avai_t_1 firmsize5_t_1 lnRnDinten_t_1  ROA_t_1 (D_comb_s1h9_t_1 A_comb_s1h9_t_1 B_comb_s1h9_t_1 = quar_CO2_SIC_t_1 ratio_subsidiary_t_1  l_avg_damage_crops_2_t_1  cum_num_incen_t_1     ) lambda_hat_3rd_rev3  i.year i.gvkey if reg_382 ==1, robust cluster(gvkey) ffirst  partial(i.gvkey)

*Table A25b. Endogeneity and control function approach - first stage results (alternative IVs)
local IV_alt "quar_CO2_SIC_t_1 ratio_subsidiary_t_1  l_avg_damage_crops_2_t_1  cum_num_incen_t_1"

eststo: qui xtprobit D_comb_s1h9_t_1   `IV_alt'                                    i.year if reg_382 == 1, re i(gvkey)  vce(robust) difficult
eststo: qui xtprobit D_comb_s1h9_t_1               l_other_nbwc_two_t_1    `ctr'   i.year if reg_382 == 1, re i(gvkey)  vce(robust) difficult
eststo: qui xtprobit D_comb_s1h9_t_1   `IV_alt'    l_other_nbwc_two_t_1    `ctr'   i.year if reg_382 == 1, re i(gvkey)  vce(robust) difficult
						  
eststo: qui reg A_comb_s1h9_t_1  `IV_alt'                                          i.gvkey  i.year if reg_382 == 1, robust cluster(gvkey)
eststo: qui reg A_comb_s1h9_t_1             l_other_nbwc_two_t_1            `ctr'  i.gvkey  i.year if reg_382 == 1, robust cluster(gvkey)
eststo: qui reg A_comb_s1h9_t_1  `IV_alt'   l_other_nbwc_two_t_1            `ctr'  i.gvkey  i.year if reg_382 == 1, robust cluster(gvkey)

eststo: qui reg B_comb_s1h9_t_1  `IV_alt'                                          i.gvkey  i.year if reg_382 == 1, robust cluster(gvkey) 
eststo: qui reg B_comb_s1h9_t_1             l_other_nbwc_two_t_1            `ctr'  i.gvkey  i.year if reg_382 == 1, robust cluster(gvkey) 
eststo: qui reg B_comb_s1h9_t_1  `IV_alt'   l_other_nbwc_two_t_1            `ctr'  i.gvkey  i.year if reg_382 == 1, robust cluster(gvkey) 

esttab using "~\appendix_tables.csv" , cells(b(fmt(3) star) se(par)) stats(r2 ll N, labels(R-squared Log-likelihood N)   ) starlevels(* 0.1 ** 0.05 *** 0.01) varwidth(15)  postfoot( `"{hline @width}"' `"  * p<0.10    ** p<0.05    *** p<0.01  "'   `"  Robust standard errors in parentheses"')
esttab using "~\appendix_tables_IRR.csv" , cells(b(fmt(3) star) se(par)) stats(r2 ll N, labels(R-squared Log-likelihood N)   ) starlevels(* 0.1 ** 0.05 *** 0.01) varwidth(15)  postfoot( `"{hline @width}"' `"  * p<0.10    ** p<0.05    *** p<0.01  "'   `"  Robust standard errors in parentheses"') eform


*Figure 1. Summary of theoretical model
*Figure 2. Annual Co2 emissions of Top five emitters
*Figure 3. Visualization of the effect of emissions vs. aspiration on search renewable
qui nbreg nbwc_to_Y02E `main_IDV'      l_other_nbwc_two_t_1  `ctr' lambda_main  `main_IV' `tail'
qui margins, at(A_comb_s1h9_t_1 = (0(.05)1 )) atmeans post
est store ABOVE

qui nbreg nbwc_to_Y02E `main_IDV'      l_other_nbwc_two_t_1  `ctr' lambda_main  `main_IV' `tail'
qui margins , at(B_comb_s1h9_t_1 =(0(.05)1)) atmeans post
est store BELOW
coefplot  ABOVE BELOW, at noci recast(line)

*Figure A1. Sample Construction Process
*Figure A2. Number of patents by ICT firms and patent class
*Figure A3. Risk perception on regulations by non-energy-intensive and energy-intensiv industry
*Figure A4. Patenting trend of non-energy-intensive and energy-intensive industry
*Figure A5. Graphical analysis of poisson & negaitve binomial model fit for DV (Search Renewable)




