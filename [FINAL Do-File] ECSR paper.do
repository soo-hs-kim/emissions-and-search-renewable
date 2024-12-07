////////////////// ECSR paper POMS 3rd Revision /////////////////////
////////////////// FINAL DO-FILE ////////////////////////////////////
*최초 작성 일자: Jan 20, 2024
log using "E:\ECSR_3rd revision\SIC 2-digit\FINAL Tables log.smcl"

clear
use "E:\ECSR_3rd revision\SIC 2-digit\[MAIN DATA] 3rd Revision_as of Jan 19, 2024.dta"

*Table 1. Variable Description
*Table 2. Descriptive Statistics
sum nbwc_to_Y02E_two  D_comb_s1h9 A_comb_s1h9 B_comb_s1h9 l_other_nbwc_two regulation astspec lnslack_avai firmsize5 lnRnDinten ROA    if !missing(A_comb_s1h9) & !missing(lnRnDinten) & !missing(lnslack_avai) & !missing(regulation) & !missing(pro_con_d) & !missing(lambda_hat_new_409) & !missing(CO2_ABOVE_his_l_8_dum)

pwcorr nbwc_to_Y02E_two  D_comb_s1h9 A_comb_s1h9 B_comb_s1h9 l_other_nbwc_two regulation astspec lnslack_avai firmsize5 lnRnDinten ROA    if !missing(A_comb_s1h9) & !missing(lnRnDinten) & !missing(lnslack_avai) & !missing(regulation) & !missing(pro_con_d) & !missing(lambda_hat_new_409) & !missing(CO2_ABOVE_his_l_8_dum)


local ctr         "regulation_t_1 astspec_t_1  lnslack_avai_t_1 firmsize5_t_1 lnRnDinten_t_1  ROA_t_1"
local ctr_noROA   "regulation_t_1 astspec_t_1  lnslack_avai_t_1 firmsize5_t_1 lnRnDinten_t_1  "
local ctr_noSlack "regulation_t_1 astspec_t_1                   firmsize5_t_1 lnRnDinten_t_1  ROA_t_1"
local ctr_noFS    "regulation_t_1 astspec_t_1  lnslack_avai_t_1               lnRnDinten_t_1  ROA_t_1"
local IV_four     "quar_CO2_SIC_t_1 l_avg_deaths_indirect_t_1 pro_con_x_t_1 pro_con_d_t_1"
local main_IV     "r_D_original  r_A_original  r_B_original"
local main_IDV    "D_comb_s1h9_t_1 A_comb_s1h9_t_1 B_comb_s1h9_t_1"
local tail        "i.year i.gvkey if reg_362 == 1, difficult cluster(gvkey) robust"


*Table 3. Main Result: The impact of CO2 emissions vs. Aspiration on Search
**Model 1. Only control variables
est clear
eststo: qui nbreg nbwc_to_Y02E_two      l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409  `tail'

**Model 2. Only H1
eststo: qui nbreg nbwc_to_Y02E_two D_comb_s1h9_t_1     l_other_nbwc_two_t_1  `ctr' lambda_hat_new_409 r_D_original   `tail'

**Model 3. Full Model (H1, H2, H3)
eststo: qui nbreg nbwc_to_Y02E_two  `main_IDV'    l_other_nbwc_two_t_1  `ctr' lambda_hat_new_409  `main_IV'  `tail'



*Table 4. Comparison between Non-energy-intensive vs. Energy-intensive
{
clear
use "E:\ECSR_3rd revision\SIC 2-digit\[SUPPL DATA] 3rd Revision_all COMPUSTAT variables.dta"

sum nbwc_to_Y02E  D_comb_s1_h9 A_comb_s1_h9 B_comb_s1_h9 l_other_nbwc regulation astspec lnslack_avai firmsize5 lnRnDinten ROA   if !missing(D_comb_s1_h9) & !missing(lnRnDinten) & !missing(lnslack_avai) & !missing(regulation) & !missing(pro_con_d) & !missing(lambda_399_409_inten_v2) & year < 2016 & gvkey != 12053
pwcorr nbwc_to_Y02E  D_comb_s1_h9 A_comb_s1_h9 B_comb_s1_h9 l_other_nbwc regulation astspec lnslack_avai firmsize5 lnRnDinten ROA   if !missing(D_comb_s1_h9) & !missing(lnRnDinten) & !missing(lnslack_avai) & !missing(regulation) & !missing(pro_con_d) & !missing(lambda_399_409_inten_v2) & year < 2016 & gvkey != 12053

*gen RnDinten_lt = xrd / lt
*lnskew0 ln_RnDinten_lt = RnDinten_lt
*sort gvkey year
*by gvkey: gen ln_RnDinten_lt_t_1 = ln_RnDinten_lt[_n-1]
sum nbwc_to_Y02E  D_comb_s1_h9 A_comb_s1_h9 B_comb_s1_h9 l_other_nbwc regulation astspec lnslack_avai firmsize5  ROA    ln_RnDinten_lt  if !missing(D_comb_s1_h9)  & !missing(lnslack_avai) & !missing(regulation) & !missing(pro_con_d) & !missing(lambda_399_409_inten_v2) & year < 2016 & gvkey != 12053 & !missing(astspec) & year < 2016 & !missing( ln_RnDinten_lt )

pwcorr nbwc_to_Y02E  D_comb_s1_h9 A_comb_s1_h9 B_comb_s1_h9 l_other_nbwc regulation astspec lnslack_avai firmsize5  ROA    ln_RnDinten_lt  if !missing(D_comb_s1_h9)  & !missing(lnslack_avai) & !missing(regulation) & !missing(pro_con_d) & !missing(lambda_399_409_inten_v2) & year < 2016 & gvkey != 12053 & !missing(astspec) & year < 2016 & !missing( ln_RnDinten_lt )

clear
use "E:\ECSR_3rd revision\SIC 2-digit\[SUPPL DATA] 3rd Revision_obs729.dta"

local main_IDV "D_comb_s1_h9_t_1  A_comb_s1_h9_t_1 B_comb_s1_h9_t_1"
local ctr_noRnD "regulation_t_1 astspec_t_1  lnslack_avai_t_1 firmsize5_t_1   ROA_t_1"
local ctr "regulation_t_1 astspec_t_1  lnslack_avai_t_1 firmsize5_t_1 lnRnDinten_t_1  ROA_t_1"
local IV "r_D_ene  r_A_ene  r_B_ene"
 
est clear
**result without RnDinten
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'  l_other_nbwc_t_1  `ctr_noRnD' lambda_399_409_inten_v2 `IV' i.year i.gvkey, difficult cluster(gvkey) robust
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'  l_other_nbwc_t_1  `ctr_noRnD' lambda_399_409_inten_v2 `IV'  i.year i.gvkey if ene_inten_naics_ver2 ==0 , difficult cluster(gvkey) robust
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'  l_other_nbwc_t_1  `ctr_noRnD' lambda_399_409_inten_v2 `IV'  i.year i.gvkey if ene_inten_naics_ver2 ==1 , difficult cluster(gvkey) robust

**result with RnDinten (original one)
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'  l_other_nbwc_t_1  `ctr' lambda_399_409_inten_v2 `IV'  i.year i.gvkey  , difficult cluster(gvkey) robust
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'  l_other_nbwc_t_1  `ctr' lambda_399_409_inten_v2 `IV'  i.year i.gvkey if ene_inten_naics_ver2 == 0 , difficult cluster(gvkey) robust
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'  l_other_nbwc_t_1  `ctr' lambda_399_409_inten_v2 `IV'  i.year i.gvkey if ene_inten_naics_ver2 == 1 , difficult cluster(gvkey) robust

**result with RnDinten (alternative one)
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'  l_other_nbwc_t_1  `ctr_noRnD' ln_RnDinten_lt_t_1 lambda_399_409_inten_v2 `IV'  i.year i.gvkey  , difficult cluster(gvkey) robust
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'  l_other_nbwc_t_1  `ctr_noRnD' ln_RnDinten_lt_t_1 lambda_399_409_inten_v2 `IV'  i.year i.gvkey if ene_inten_naics_ver2 ==0 , difficult cluster(gvkey) robust
eststo: qui nbreg nbwc_to_Y02E  `main_IDV'  l_other_nbwc_t_1  `ctr_noRnD' ln_RnDinten_lt_t_1 lambda_399_409_inten_v2 `IV'  i.year i.gvkey if ene_inten_naics_ver2 ==1 , difficult cluster(gvkey) robust




esttab  using "E:\ECSR_3rd revision\SIC 2-digit\[FINAL][SUPPL DATA] Table4.csv" , cells(b(fmt(3) star) se(par)) stats(r2 ll N, labels(R-squared Log-likelihood N)   ) starlevels(* 0.1 ** 0.05 *** 0.01) varwidth(15)  postfoot( `"{hline @width}"' `"  * p<0.10    ** p<0.05    *** p<0.01  "'   `"  Robust standard errors in parentheses"') replace 
esttab  using "E:\ECSR_3rd revision\SIC 2-digit\[FINAL][SUPPL DATA] Table4_IRR.csv" , cells(b(fmt(3) star) se(par)) stats(r2 ll N, labels(R-squared Log-likelihood N)   ) starlevels(* 0.1 ** 0.05 *** 0.01) varwidth(15)  postfoot( `"{hline @width}"' `"  * p<0.10    ** p<0.05    *** p<0.01  "'   `"  Robust standard errors in parentheses"') eform replace
}
	

	
*Table 5. Including controls for financial performance vs. aspiration
eststo: qui nbreg nbwc_to_Y02E_two  `main_IDV'  D_ROA_s1h9_t_1 A_ROA_s1h9_t_1 B_ROA_s1h9_t_1   l_other_nbwc_two_t_1   `ctr_noROA'  lambda_hat_new_409_ROA_ROS  `main_IV' `tail'
eststo: qui nbreg nbwc_to_Y02E_two  `main_IDV'  D_ROS_s1h9_t_1 A_ROS_s1h9_t_1 B_ROS_s1h9_t_1   l_other_nbwc_two_t_1   `ctr_noROA'  lambda_hat_new_409_ROA_ROS  `main_IV' `tail'
eststo: qui nbreg nbwc_to_Y02E_two  `main_IDV'  D_EPS_s1h9_t_1 A_EPS_s1h9_t_1 B_EPS_s1h9_t_1   l_other_nbwc_two_t_1   `ctr_noROA'  lambda_hat_new_409_EPS      `main_IV' `tail'

****for R2's response
sum nbwc_to_Y02E_two  D_comb_s1h9 A_comb_s1h9 B_comb_s1h9 l_other_nbwc_two regulation astspec lnslack_avai firmsize5 lnRnDinten ROA ROS EPS  D_ROA_s1h9 A_ROA_s1h9 B_ROA_s1h9    D_ROS_s1h9 A_ROS_s1h9 B_ROS_s1h9  D_EPS_s1h9 A_EPS_s1h9 B_EPS_s1h9  l_tobinQ   if !missing(A_comb_s1h9) & !missing(lnRnDinten) & !missing(lnslack_avai) & !missing(regulation) & !missing(pro_con_d) & !missing(lambda_hat_new_409) & !missing(CO2_ABOVE_his_l_8_dum) & !missing(D_EPS_s1h9)

pwcorr nbwc_to_Y02E_two  D_comb_s1h9 A_comb_s1h9 B_comb_s1h9 l_other_nbwc_two regulation astspec lnslack_avai firmsize5 lnRnDinten ROA ROS EPS  D_ROA_s1h9 A_ROA_s1h9 B_ROA_s1h9    D_ROS_s1h9 A_ROS_s1h9 B_ROS_s1h9  D_EPS_s1h9 A_EPS_s1h9 B_EPS_s1h9  l_tobinQ   if !missing(A_comb_s1h9) & !missing(lnRnDinten) & !missing(lnslack_avai) & !missing(regulation) & !missing(pro_con_d) & !missing(lambda_hat_new_409) & !missing(CO2_ABOVE_his_l_8_dum) & !missing(D_EPS_s1h9)

eststo: qui nbreg nbwc_to_Y02E_two  `main_IDV'  D_ROA_s1h9_t_1 A_ROA_s1h9_t_1 B_ROA_s1h9_t_1   l_other_nbwc_two_t_1   `ctr_noROA' l_tobinQ_t_1 lambda_hat_new_409_ROA_ROS  `main_IV' `tail'
eststo: qui nbreg nbwc_to_Y02E_two  `main_IDV'  D_ROS_s1h9_t_1 A_ROS_s1h9_t_1 B_ROS_s1h9_t_1   l_other_nbwc_two_t_1   `ctr_noROA' l_tobinQ_t_1 lambda_hat_new_409_ROA_ROS  `main_IV' `tail'
eststo: qui nbreg nbwc_to_Y02E_two  `main_IDV'  D_EPS_s1h9_t_1 A_EPS_s1h9_t_1 B_EPS_s1h9_t_1   l_other_nbwc_two_t_1   `ctr_noROA' l_tobinQ_t_1 lambda_hat_new_409_EPS      `main_IV' `tail'



*Table 6. Including controls for concern on clean energy, incentive payment to managers
eststo: qui nbreg nbwc_to_Y02E_two `main_IDV'  env_str_d_ver2_t_1   l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_env_str_d  `main_IV' `tail'
eststo: qui nbreg nbwc_to_Y02E_two `main_IDV'  C1_2_dum_t_1         l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_incen      `main_IV' i.year i.gvkey if reg_362 == 1 & !missing(incen_money_new_t_1), difficult cluster(gvkey) robust
eststo: qui nbreg nbwc_to_Y02E_two `main_IDV'  incen_money_new_t_1  l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_incen      `main_IV' `tail'



*Table A1. List of firms in Final Sample (74 firms)
*Table A2. Heckman first stage
{
clear
use "E:\ECSR_2nd revision\[MAIN DATA] 77 firms_2010-2018_PLEASE.dta"

eststo: qui xtprobit samp_new_409   				  `ctr' i.year if gvkey != 12053, re i(gvkey) vce(robust)
eststo: qui xtprobit samp_new_409 report_num_hq_t_1   `ctr' i.year if gvkey != 12053, re i(gvkey) vce(robust)
}

*Table A3a. Instrumental validity tests
{
ivreg2 nbwc_to_Y02E_two l_other_nbwc_two_t_1  regulation_t_1 astspec_t_1  lnslack_avai_t_1 firmsize5_t_1 lnRnDinten_t_1   ROA_t_1 (D_comb_s1h9_t_1 A_comb_s1h9_t_1 B_comb_s1h9_t_1 = quar_CO2_SIC_t_1 l_avg_deaths_indirect_t_1 pro_con_x_t_1 pro_con_d_t_1) lambda_hat_new_409 i.year i.gvkey if  !missing(CO2_ABOVE_his_l_8_dum_t_1), robust cluster(gvkey) ffirst  partial(i.gvkey)

*                                           (Underid)            (Weak id)
*Variable     | F(  4,    73)  P-val | SW Chi-sq(  2) P-val | SW F(  2,    73)
*D_comb_s1h9_ |      10.97    0.0000 |        1.96   0.3753 |        0.72
*A_comb_s1h9_ |      19.29    0.0000 |        2.81   0.2452 |        1.04
*B_comb_s1h9_ |       5.64    0.0005 |        2.00   0.3671 |        0.74

** First-stage F statistic
*Anderson-Rubin Wald test           F(4,73)=        1.20     P-val=0.3194
*Anderson-Rubin Wald test           Chi-sq(4)=      6.49     P-val=0.1654
*Stock-Wright LM S statistic        Chi-sq(4)=     28.25     P-val=0.0000

*Hansen J statistic (overidentification test of all instruments):         0.048
*                                                    Chi-sq(1) P-val =    0.8274
**Individual Hansen J
*ivreg2 nbwc_to_Y02E_two l_other_nbwc_two_t_1  regulation_t_1 astspec_t_1  lnslack_avai_t_1 firmsize5_t_1 lnRnDinten_t_1   ROA_t_1 (D_comb_s1h9_t_1 = quar_CO2_SIC_t_1 l_avg_deaths_indirect_t_1 pro_con_x_t_1 pro_con_d_t_1) lambda_hat_new_409 i.year i.gvkey if  !missing(CO2_ABOVE_his_l_8_dum_t_1), robust cluster(gvkey) ffirst  partial(i.gvkey)
*Dummy: 2.500 (Chi-sq(3) P-val =    0.4753)
*ABOVE: 2.741 (Chi-sq(3) P-val =    0.4334)
*BELOW: 2.346 ( Chi-sq(3) P-val =   0.5038)
}



*Table A3b. Endogeneity and control function approach - first stage results
eststo: qui xtprobit D_comb_s1h9_t_1  `IV_four'                                     i.year if reg_362 ==1, re i(gvkey)  vce(robust) difficult
eststo: qui xtprobit D_comb_s1h9_t_1             l_other_nbwc_two_t_1   `ctr'   i.year if reg_362 ==1, re i(gvkey)  vce(robust) difficult
eststo: qui xtprobit D_comb_s1h9_t_1  `IV_four'  l_other_nbwc_two_t_1   `ctr'   i.year if reg_362 ==1, re i(gvkey)  vce(robust) difficult
*predict hat_original, xb
*gen r_D_original = normalden(hat_original)/normal(hat_original)
*drop hat_original 

eststo: qui reg A_comb_s1h9_t_1   `IV_four'                            `ctr'    i.year i.gvkey if reg_362 ==1, robust cluster(gvkey)
*di e(r2_a) // 0.81959602
eststo: qui reg A_comb_s1h9_t_1               l_other_nbwc_two_t_1     `ctr'    i.year i.gvkey if reg_362 ==1, robust cluster(gvkey)
*di e(r2_a) // 0.74005172
eststo: qui reg A_comb_s1h9_t_1   `IV_four'   l_other_nbwc_two_t_1     `ctr'    i.year i.gvkey if reg_362 ==1, robust cluster(gvkey)
*di e(r2_a) // 0.81931607
*predict r_A_original, residual

eststo: qui reg B_comb_s1h9_t_1   `IV_four'                            `ctr'    i.year i.gvkey if reg_362 ==1, robust cluster(gvkey)
*di e(r2_a) // 0.57215545
eststo: qui reg B_comb_s1h9_t_1               l_other_nbwc_two_t_1     `ctr'    i.year i.gvkey if reg_362 ==1, robust cluster(gvkey)
*di e(r2_a) // 0.29097485
eststo: qui reg B_comb_s1h9_t_1   `IV_four'   l_other_nbwc_two_t_1     `ctr'    i.year i.gvkey if reg_362 ==1, robust cluster(gvkey)
*di e(r2_a) // 0.57061216
*predict r_B_original, residual
	


*Table A4. Desciptive statistics (sample: firms in all sectors)
***Relevant Codes are written in Table 4



*Table A5. Adding contrl variables: Total energy use, Innovation score, GRI, duration
**Model 1. Only duration. No IDVs
eststo: qui nbreg nbwc_to_Y02E_two            A_dur_s1h9_t_1 B_dur_s1h9_t_1 l_other_nbwc_two_t_1    `ctr' lambda_hat_new_409  `main_IV' `tail'

**Model 2. Duration & IDVs
eststo: qui nbreg nbwc_to_Y02E_two  `main_IDV'   A_dur_s1h9_t_1 B_dur_s1h9_t_1 l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409 `main_IV' `tail'

**Model 3. No Duration & IDVs & Total energy use & Innovation score & GRI
eststo: qui nbreg nbwc_to_Y02E_two `main_IDV'   ln_total_energy_use_t_1 InnovationScore_t_1 CG_In_VS_O06_t_1  l_other_nbwc_two_t_1    `ctr' lambda_hat_new_409_TIG  `main_IV' i.gvkey i.year, robust cluster(gvkey)

**Model 4. Full (Duration & IDVs & Total energy use & Innovation score & GRI)
eststo: qui nbreg nbwc_to_Y02E_two  `main_IDV'  A_dur_s1h9_t_1 B_dur_s1h9_t_1 ln_total_energy_use_t_1 InnovationScore_t_1 CG_In_VS_O06_t_1  l_other_nbwc_two_t_1   `ctr'  lambda_hat_new_409_TIG  `main_IV' `tail'



*Table A6. Adding control variables: Controls for CA-headquartered from 2012, ETS part, Carbon credit transaction
**Model 1. Adding CA-headquartered
eststo: qui nbreg nbwc_to_Y02E_two  `main_IDV' CAT_CA_t_1    l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409 `main_IV' `tail'

**Model 2. Adding ETS part, Carbon credit transaction
eststo: qui nbreg nbwc_to_Y02E_two  `main_IDV'  C14_1_dum_En_En_ER_DP068_t_1 C14_2_dum_En_En_ER_DP097_dum_t_1  l_other_nbwc_two_t_1   `ctr'  lambda_hat_new_409_ETS `main_IV' `tail'

**Model 3. Full (CA-headquartered, ETS part, Carbon credit transaction)
eststo: qui nbreg nbwc_to_Y02E_two  `main_IDV'  CAT_CA_t_1 C14_1_dum_En_En_ER_DP068_t_1 C14_2_dum_En_En_ER_DP097_dum_t_1  l_other_nbwc_two_t_1  `ctr'   lambda_hat_new_409_ETS `main_IV' `tail'


	
*Table A7. Alternative Estimation method
**Model 1. Poisson
eststo: qui poisson nbwc_to_Y02E_two `main_IDV' l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409 `main_IV' `tail'

**Model 2. ZINB
eststo: qui  zinb    nbwc_to_Y02E_two `main_IDV' l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409 `main_IV'  i.year i.gvkey if reg_362 == 1, inflate(`ctr_noROA')  cluster(gvkey) difficult robust

***nbreg nbwc_to_Y02E_two `main_IDV'      l_other_nbwc_two_t_1  `ctr' lambda_hat_new_409   `main_IV'  i.gvkey i.year, difficult
***>>> LR test of alpha=0: chibar2(01) = 276.47               Prob >= chibar2 = 0.000

*** nbvargr    nbwc_to_Y02E_two  if reg_362 == 1

*** (OLD ONE) // Vuong test --> should remove. No more supported by STATA



*Table A8. Alternative measures of control variables
**Model 1. Financial performance (ROS)
eststo: qui nbreg nbwc_to_Y02E_two  `main_IDV'  l_other_nbwc_two_t_1  `ctr_noROA'    ROS_t_1            lambda_hat_new_409_A9_ROS  `main_IV' `tail'

**Model 2. Financial performance (EPS)
eststo: qui nbreg nbwc_to_Y02E_two  `main_IDV'  l_other_nbwc_two_t_1  `ctr_noROA'    EPS_t_1            lambda_hat_new_409_A9_EPS  `main_IV' `tail'

**Model 3. Slack (profit margin)
eststo: qui nbreg nbwc_to_Y02E_two `main_IDV'   l_other_nbwc_two_t_1  `ctr_noSlack'  ib_revt_t_1        lambda_hat_new_409_A9_ibrevt `main_IV' `tail'

**Model 4. Slack (potential slack)
eststo: qui nbreg nbwc_to_Y02E_two `main_IDV'   l_other_nbwc_two_t_1  `ctr_noSlack'  lnslack_poten_t_1  lambda_hat_new_409_A9_slpoten `main_IV' `tail'

**Model 5. Slack (slack index)
eststo: qui nbreg nbwc_to_Y02E_two `main_IDV'   l_other_nbwc_two_t_1  `ctr_noSlack'  lnslack_index_t_1  lambda_hat_new_409_A9_slind   `main_IV' `tail'

**Model 6. Firm size (employees)
eststo: qui nbreg nbwc_to_Y02E_two `main_IDV'   l_other_nbwc_two_t_1  `ctr_noFS'     firmsize1_t_1      lambda_hat_new_409_A9_fs1 `main_IV' `tail'

**Model 7. Firm size (total asset)
eststo: qui nbreg nbwc_to_Y02E_two `main_IDV'   l_other_nbwc_two_t_1  `ctr_noFS'     firmsize2_t_1      lambda_hat_new_409_A9_fs2  `main_IV' `tail'

**Model 8. Firm size (total asset by net sales) 
eststo: qui nbreg nbwc_to_Y02E_two `main_IDV'   l_other_nbwc_two_t_1  `ctr_noFS'     firmsize3_t_1      lambda_hat_new_409_A9_fs3  `main_IV' `tail'

**Model 9. Firm size (market capitalization)
eststo: qui nbreg nbwc_to_Y02E_two `main_IDV'   l_other_nbwc_two_t_1  `ctr_noFS'     firmsize4_t_1      lambda_hat_new_409_A9_fs4  `main_IV' `tail'



*Table A9. Alternative measures of aspiration: Intensity-based measures of emissions, real emissions
**Model 1. cogs
eststo: qui nbreg nbwc_to_Y02E_two D_cogs_s1h9_v2_t_1 A_cogs_s1h9_v2_t_1 B_cogs_s1h9_v2_t_1      l_other_nbwc_two_t_1 `ctr'  lambda_hat_new_409_cogs_v2    r_D_original_cogs r_A_original_cogs r_B_original_cogs `tail'

**Model 2. invt
eststo: qui nbreg nbwc_to_Y02E_two  D_invt_s1h9_v2_t_1 A_invt_s1h9_v2_t_1 B_invt_s1h9_v2_t_1    l_other_nbwc_two_t_1  `ctr' lambda_hat_new_409_invt_v2  r_D_original_invt r_A_original_invt r_B_original_invt  `tail'

**Model 3. real emissiosn
eststo: qui nbreg nbwc_to_Y02E_two CO2_ABOVE_d_l_real_t_1 CO2_ABOVE_l_real_t_1 CO2_BELOW_l_real_t_1      l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_real r_D_original_real r_A_original_real r_B_original_real     i.year i.gvkey if !missing(t_scope1n2) & reg_362 == 1, difficult cluster(gvkey)



*Table A10. Alternative measures of aspiration: Predicted emissions
eststo: qui nbreg nbwc_to_Y02E_two  Dum_ABOVE_holt_t_1 ABOVE_holt_t_1 BELOW_holt_t_1  l_other_nbwc_two_t_1  `ctr'   lambda_hat_new_409  r_D_original_holt r_A_original_holt r_B_original_holt   i.year i.gvkey, robust cluster(gvkey) difficult



*Table A11. Alternative dependent variable: self-citation vs. non-self-citation
**Model 1. self-citation
eststo: qui  zinb  adj_C_self_nbwc_to_Y02E   `main_IDV'   l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409  `main_IV'  i.gvkey i.year if reg_362 == 1, inflate(astspec_t_1  firmsize5_t_1 lnRnDinten_t_1)  cluster(gvkey) difficult robust
**Model 2. non-self-citation
eststo: qui nbreg adj_C_others_nbwc_to_Y02E  `main_IDV'   l_other_nbwc_two_t_1  `ctr' lambda_hat_new_409  `main_IV' `tail' 



*Table A12. Alternative dependent variable: in-house vs. acquired
**Model 1. in-house
eststo: qui nbreg nbwc_to_Y02E_inhouse      `main_IDV'   l_other_nbwc_inhouse_t_1  `ctr'   lambda_hat_new_409 `main_IV' `tail'

**Model 2. acquired
eststo: qui zinb  nbwc_to_Y02E_acquire      `main_IDV'   l_other_nbwc_acquire_t_1  `ctr'  lambda_hat_new_409  `main_IV'  i.gvkey i.year if reg_362 == 1, inflate(`ctr_noROA')  cluster(gvkey) difficult robust



*Table A13a. Split-sample analysis: High- vs. Low-energy usage
**Model 1. High-energy
eststo: qui nbreg nbwc_to_Y02E_two  `main_IDV'     l_other_nbwc_two_t_1  `ctr'   lambda_hat_new_409  `main_IV'  i.gvkey i.year  if ABOVE_avg_ene_naics_new_2 == 1, robust cluster(gvkey) difficult

**Model 2. Low-energy
eststo: qui nbreg nbwc_to_Y02E_two  `main_IDV'     l_other_nbwc_two_t_1  `ctr'   lambda_hat_new_409  `main_IV'  i.gvkey i.year  if ABOVE_avg_ene_naics_new_2 == 0, robust cluster(gvkey) difficult

***Wald test using suest 
*qui nbreg nbwc_to_Y02E_two  `main_IDV'     l_other_nbwc_two_t_1  `ctr'   lambda_hat_new_409  `main_IV'  i.gvkey i.year  if ABOVE_avg_ene_naics_new_2 == 1, difficult
*est store high
*gen gvkey_2 = gvkey
*qui nbreg nbwc_to_Y02E_two  `main_IDV'     l_other_nbwc_two_t_1  `ctr'   lambda_hat_new_409  `main_IV'  i.gvkey_2 i.year  if ABOVE_avg_ene_naics_new_2 == 0, difficult
*est store low
*suest high low, cluster(gvkey) robust

*test _b[high_nbwc_to_Y02E_two:D_comb_s1h9_t_1] = _b[low_nbwc_to_Y02E_two:D_comb_s1h9_t_1]
*           chi2(  1) =    0.02
*         Prob > chi2 =    0.8836

*test _b[high_nbwc_to_Y02E_two:A_comb_s1h9_t_1] = _b[low_nbwc_to_Y02E_two:A_comb_s1h9_t_1]
*          chi2(  1) =    5.92
*        Prob > chi2 =    0.0150

*test _b[high_nbwc_to_Y02E_two:B_comb_s1h9_t_1] = _b[low_nbwc_to_Y02E_two:B_comb_s1h9_t_1]
*           chi2(  1) =    5.48
*         Prob > chi2 =    0.0193


*Table A13b. Statistical difference between High- vs. Low-energy usage



*Table A14. Split-sample analysis: Manufacturing vs. Service
**Model 1. Manufacturing
eststo: qui nbreg nbwc_to_Y02E_two   `main_IDV'    l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409  `main_IV'  i.gvkey i.year  if naics_new_class_v2  == 1, robust cluster(gvkey) difficult

**Model 2. Service
eststo: qui nbreg nbwc_to_Y02E_two   `main_IDV'    l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409  `main_IV'  i.gvkey i.year  if naics_new_class_v2  == 2, robust cluster(gvkey) difficult

***Wald test using suest 
*qui nbreg nbwc_to_Y02E_two   `main_IDV'    l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409  `main_IV'  i.gvkey i.year  if naics_new_class_v2  == 1,  difficult
*est store manu
*gen gvkey_2 = gvkey
*qui nbreg nbwc_to_Y02E_two   `main_IDV'    l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409  `main_IV'  i.gvkey_2 i.year  if naics_new_class_v2  == 2, difficult
*est store ser
*suest manu ser, cluster(gvkey) robust

*test _b[manu_nbwc_to_Y02E_two:D_comb_s1h9_t_1] = _b[ser_nbwc_to_Y02E_two:D_comb_s1h9_t_1]
*           chi2(  1) =    0.82
*         Prob > chi2 =    0.3638

*test _b[manu_nbwc_to_Y02E_two:A_comb_s1h9_t_1] = _b[ser_nbwc_to_Y02E_two:A_comb_s1h9_t_1]
*          chi2(  1) =    0.20
*        Prob > chi2 =    0.6547

*test _b[manu_nbwc_to_Y02E_two:B_comb_s1h9_t_1] = _b[ser_nbwc_to_Y02E_two:B_comb_s1h9_t_1]
*           chi2(  1) =    1.93
*         Prob > chi2 =    0.1643



*Table A15. Split-sample analysis: Datacenter importance High vs. Low
**Model 1. High
eststo: qui nbreg nbwc_to_Y02E_two  `main_IDV'     l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409  `main_IV'  i.gvkey i.year  if datacenter  == 1, robust cluster(gvkey) difficult

**Model 2. Low
eststo: qui nbreg nbwc_to_Y02E_two  `main_IDV'     l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409  `main_IV'  i.gvkey i.year  if datacenter  == 0, robust cluster(gvkey) difficult


***Wald test using suest 
*qui nbreg nbwc_to_Y02E_two  `main_IDV'     l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409  `main_IV'  i.gvkey i.year  if datacenter  == 1,  difficult
*est store high
*gen gvkey_2 = gvkey
*qui qui nbreg nbwc_to_Y02E_two  `main_IDV'     l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409  `main_IV'  i.gvkey_2 i.year  if datacenter  == 0,  difficult
*est store low
*suest high low, cluster(gvkey) robust

*test _b[high_nbwc_to_Y02E_two:D_comb_s1h9_t_1] = _b[low_nbwc_to_Y02E_two:D_comb_s1h9_t_1]
*           chi2(  1) =    10.03
*         Prob > chi2 =    0.0015

*test _b[high_nbwc_to_Y02E_two:A_comb_s1h9_t_1] = _b[low_nbwc_to_Y02E_two:A_comb_s1h9_t_1]
*          chi2(  1) =    0.78
*        Prob > chi2 =    0.3775

*test _b[high_nbwc_to_Y02E_two:B_comb_s1h9_t_1] = _b[low_nbwc_to_Y02E_two:B_comb_s1h9_t_1]
*           chi2(  1) =    0.00
*         Prob > chi2 =    0.9578



*Table A16. Post-hoc Analysis (1) Aspiration level constructed based on hist only vs. social only
**Model 1. Historical only
eststo: qui	 nbreg nbwc_to_Y02E_two CO2_ABOVE_his_l_8_dum_t_1 CO2_ABOVE_his_l_8_t_1   CO2_BELOW_his_l_8_t_1   l_other_nbwc_two_t_1 `ctr'  lambda_hat_new_409_his r_D_original_his r_A_original_his r_B_original_his  `tail' 
**Model 2. Social only
eststo: qui 	nbreg nbwc_to_Y02E_two D_soc_ver1_ps5_t_1 A_soc_ver1_ps5_t_1 B_soc_ver1_ps5_t_1  l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_soc r_D_original_soc r_A_original_soc r_B_original_soc  `tail' 



*Table A17. Post-hoc Analysis (2) DV = Energy Purchased
eststo: qui 	reg ln_elec_purch  `main_IDV'   l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_elec_purch    `main_IV' i.gvkey i.year, robust cluster(gvkey)
eststo: qui 	reg ln_renew_purch  `main_IDV'  l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_renew_purch   `main_IV' i.gvkey i.year, robust cluster(gvkey)  
eststo: qui 	reg ln_energy_purch `main_IDV'  l_other_nbwc_two_t_1 `ctr'   lambda_hat_new_409_energy_purch  `main_IV' i.gvkey i.year, robust cluster(gvkey)

eststo: qui 	reg ln_elec_purch    `main_IDV'   l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_elec_purch   C12_1_cate_t_1   `main_IV' i.gvkey i.year, robust cluster(gvkey)
eststo: qui	 reg ln_renew_purch   `main_IDV'   l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_renew_purch  C12_1_cate_t_1   `main_IV' i.gvkey i.year, robust cluster(gvkey)
eststo: qui 	reg ln_energy_purch  `main_IDV'   l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_energy_purch C12_1_cate_t_1   `main_IV' i.gvkey i.year, robust cluster(gvkey)
*C12_1_cate: from CDP questionnaire
*total operational spend on energy
*more than 0% ~ but less than or equal to 10% ..
*large number of C12_1_cate means that the firm spends a lot for energy spending


*Table A18. Post-hoc Analysis (3) DV = Environmental Product Development
eststo: qui 	reg  ln_En_En_PI_O01 CO2_ABOVE_his_l_8_dum_t_1 CO2_ABOVE_his_l_8_t_1   CO2_BELOW_his_l_8_t_1   l_other_nbwc_two_t_1  `ctr'   lambda_hat_new_409_Env_Prod r_D_original_his r_A_original_his r_B_original_his  i.gvkey i.year if reg_362 == 1, cluster(gvkey) robust

eststo: qui 	reg  ln_En_En_PI_O01 D_soc_ver1_ps5_t_1 A_soc_ver1_ps5_t_1 B_soc_ver1_ps5_t_1  l_other_nbwc_two_t_1 `ctr'   lambda_hat_new_409_Env_Prod r_D_original_soc r_A_original_soc r_B_original_soc   i.gvkey i.year if reg_362 == 1, cluster(gvkey) robust



*Table A19. Varying levels of alpha when computing historical aspiration
foreach x of numlist 1/9 {
	eststo: qui  nbreg nbwc_to_Y02E_two CO2_ABOVE_his_l_`x'_dum_t_1 CO2_ABOVE_his_l_`x'_t_1   CO2_BELOW_his_l_`x'_t_1   l_other_nbwc_two_t_1  `ctr' lambda_hat_new_409_his  i.year i.gvkey if reg_362==1, robust cluster(gvkey)  difficult
}

*** 혹시 모르니 확인 (historical aspiration correcting endogeneity) - log-likelihood 확인해야 함 
foreach num of numlist 1 2 3 4 5 6 7 9 {
	eststo: qui  nbreg nbwc_to_Y02E_two   D_s1h9_his`num'_t_1 A_s1h9_his`num'_t_1 B_s1h9_his`num'_t_1  l_other_nbwc_two_t_1  `ctr' lambda_hat_new_409_his r_D_ori_s1h9_his`num'  r_A_ori_s1h9_his`num' r_B_ori_s1h9_his`num'  `tail' 
}

eststo: qui  nbreg nbwc_to_Y02E_two `main_IDV'      l_other_nbwc_two_t_1  `ctr' lambda_hat_new_409  `main_IV'    `tail' 



*Table A20. Social aspiration - Different peer size
foreach num of numlist 3 4 6 7 {
eststo: qui nbreg nbwc_to_Y02E_two D_comb_s1h9_ps`num'_t_1   A_comb_s1h9_ps`num'_t_1   B_comb_s1h9_ps`num'_t_1     l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409   r_D_ori_s1h9_ps`num' r_A_ori_s1h9_ps`num' r_B_ori_s1h9_ps`num'  `tail'
}



*Table A21a. Combined aspiration different weighted scheme (Variable on Poor Emissions Performance Indicator)
eststo: qui nbreg nbwc_to_Y02E_two       D_comb_s1h9_t_1      l_other_nbwc_two_t_1    `ctr' lambda_hat_new_409 r_D_original  `tail'
foreach x of numlist 2/9 {
	local w = 10 - `x'
	eststo: qui nbreg nbwc_to_Y02E_two   D_comb_s`x'h`w'_t_1   l_other_nbwc_two_t_1   `ctr' lambda_hat_new_409  r_D_ori_s`x'h`w'  `tail' 
}



*Table A21b. Combined aspiration different weighted scheme (Variables on Degree of Poor Emissions Performance and Degree of Good Emissions Performance)
eststo: qui nbreg nbwc_to_Y02E_two A_comb_s1h9_t_1 B_comb_s1h9_t_1    l_other_nbwc_two_t_1  `ctr' lambda_hat_new_409  r_A_original  r_B_original  `tail'
foreach x of numlist 2/9 {
	local w = 10 - `x'
	eststo: qui nbreg nbwc_to_Y02E_two A_comb_s`x'h`w'_t_1 B_comb_s`x'h`w'_t_1   l_other_nbwc_two_t_1   `ctr' lambda_hat_new_409  r_A_ori_s`x'h`w' r_B_ori_s`x'h`w'  `tail' 
}




*Table A22. Alternative DV = Ratio-based DV
**Model 1. DV = Ratio (our IDV)
eststo: qui reg DV_ratio_ver2_two `main_IDV'  `ctr'  lambda_hat_new_409   `main_IV'  i.gvkey i.year if reg_362 == 1, cluster(gvkey) 

**Model 2. DV = Ratio (logged-IDV)
eststo: qui reg DV_ratio_ver2_two D_comb_s1h9_t_1 l_A_comb_s1h9_t_1 l_B_comb_s1h9_t_1   `ctr'  lambda_hat_new_409 r_D_original r_A_original_log r_B_original_log   i.gvkey i.year  if reg_362 == 1, cluster(gvkey)



*Table A23. Robustness of Main analysis (Bootstrap)
{
**keep if reg_362 == 1
*capture program drop my_clust_mvreg_bs
program define my_clust_mvreg_bs, rclass
    nbreg nbwc_to_Y02E_two      l_other_nbwc_two_t_1  regulation_t_1 astspec_t_1  lnslack_avai_t_1 firmsize5_t_1 lnRnDinten_t_1  ROA_t_1 lambda_hat_new_409   i.year i.gvkey, difficult cluster(gvkey)
	
	local b4 = _b[nbwc_to_Y02E_two:l_other_nbwc_two_t_1]
	local b5 = _b[nbwc_to_Y02E_two:regulation_t_1]
	local b6 = _b[nbwc_to_Y02E_two:astspec_t_1]
	local b7 = _b[nbwc_to_Y02E_two:lnslack_avai_t_1]
	local b8 = _b[nbwc_to_Y02E_two:firmsize5_t_1]
	local b9 = _b[nbwc_to_Y02E_two:lnRnDinten_t_1]
	local b10 = _b[nbwc_to_Y02E_two:ROA_t_1]
	local b11 = _b[nbwc_to_Y02E_two:lambda_hat_new_409]
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
*bootstrap   l_other_nbwc_two_t_1=r(b4) regulation_t_1=r(b5) astspec_t_1=r(b6) lnslack_avai_t_1=r(b7) firmsize5_t_1=r(b8) lnRnDinten_t_1=r(b9) ROA_t_1=r(b10) lambda_hat_new_409=r(b11) Constant=r(b16) log_likelihood = r(b15) , reps(1000) seed(9876) cluster(gvkey) idcluster(new_gvkey) group(gvkey): my_clust_mvreg_bs
*est store model1

*capture program drop my_clust_mvreg_bs
program define my_clust_mvreg_bs, rclass
    nbreg nbwc_to_Y02E_two D_comb_s1h9_t_1     l_other_nbwc_two_t_1  regulation_t_1 astspec_t_1  lnslack_avai_t_1 firmsize5_t_1 lnRnDinten_t_1  ROA_t_1 lambda_hat_new_409 r_D_original   i.year i.gvkey , difficult cluster(gvkey)
	
    local b1 = _b[nbwc_to_Y02E_two:D_comb_s1h9_t_1]
	local b4 = _b[nbwc_to_Y02E_two:l_other_nbwc_two_t_1]
	local b5 = _b[nbwc_to_Y02E_two:regulation_t_1]
	local b6 = _b[nbwc_to_Y02E_two:astspec_t_1]
	local b7 = _b[nbwc_to_Y02E_two:lnslack_avai_t_1]
	local b8 = _b[nbwc_to_Y02E_two:firmsize5_t_1]
	local b9 = _b[nbwc_to_Y02E_two:lnRnDinten_t_1]
	local b10 = _b[nbwc_to_Y02E_two:ROA_t_1]
	local b11 = _b[nbwc_to_Y02E_two:lambda_hat_new_409]
	local b12 = _b[nbwc_to_Y02E_two:r_D_original]
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
*bootstrap Dummy=r(b1)  l_other_nbwc_two_t_1=r(b4) regulation_t_1=r(b5) astspec_t_1=r(b6) lnslack_avai_t_1=r(b7) firmsize5_t_1=r(b8) lnRnDinten_t_1=r(b9) ROA_t_1=r(b10) lambda_hat_new_409=r(b11) r_D_original=r(b12) Constant=r(b16)  log_likelihood = r(b15) , reps(1000) seed(9876) cluster(gvkey) idcluster(new_gvkey) group(gvkey): my_clust_mvreg_bs
*est store model2

*capture program drop my_clust_mvreg_bs
program define my_clust_mvreg_bs, rclass

	nbreg nbwc_to_Y02E_two   D_comb_s1h9_t_1 A_comb_s1h9_t_1 B_comb_s1h9_t_1  l_other_nbwc_two_t_1 regulation_t_1 astspec_t_1  lnslack_avai_t_1 firmsize5_t_1 lnRnDinten_t_1  ROA_t_1  lambda_hat_new_409  r_D_original  r_A_original  r_B_original  i.gvkey i.year, difficult cluster(gvkey)

	local b1 = _b[nbwc_to_Y02E_two:D_comb_s1h9_t_1]
	local b2 = _b[nbwc_to_Y02E_two:A_comb_s1h9_t_1]
	local b3 = _b[nbwc_to_Y02E_two:B_comb_s1h9_t_1]
	local b4 = _b[nbwc_to_Y02E_two:l_other_nbwc_two_t_1]
	local b5 = _b[nbwc_to_Y02E_two:regulation_t_1]
	local b6 = _b[nbwc_to_Y02E_two:astspec_t_1]
	local b7 = _b[nbwc_to_Y02E_two:lnslack_avai_t_1]
	local b8 = _b[nbwc_to_Y02E_two:firmsize5_t_1]
	local b9 = _b[nbwc_to_Y02E_two:lnRnDinten_t_1]
	local b10 = _b[nbwc_to_Y02E_two:ROA_t_1]
	local b11 = _b[nbwc_to_Y02E_two:lambda_hat_new_409]
	local b12 = _b[nbwc_to_Y02E_two:r_D_original]
	local b13 = _b[nbwc_to_Y02E_two:r_A_original]
	local b14 = _b[nbwc_to_Y02E_two:r_B_original]
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
*bootstrap Dummy=r(b1) ABOVE=r(b2) BELOW=r(b3) l_other_nbwc_two_t_1=r(b4) regulation_t_1=r(b5) astspec_t_1=r(b6) lnslack_avai_t_1=r(b7) firmsize5_t_1=r(b8) lnRnDinten_t_1=r(b9) ROA_t_1=r(b10) lambda_hat_new_409=r(b11) r_D_original=r(b12) r_A_original=r(b13) r_B_original=r(b14) Constant=r(b16) log_likelihood = r(b15) , reps(500) seed(9876) cluster(gvkey) idcluster(new_gvkey) group(gvkey): my_clust_mvreg_bs

*bootstrap Dummy=r(b1) ABOVE=r(b2) BELOW=r(b3) l_other_nbwc_two_t_1=r(b4) regulation_t_1=r(b5) astspec_t_1=r(b6) lnslack_avai_t_1=r(b7) firmsize5_t_1=r(b8) lnRnDinten_t_1=r(b9) ROA_t_1=r(b10) lambda_hat_new_409=r(b11) r_D_original=r(b12) r_A_original=r(b13) r_B_original=r(b14) Constant=r(b16) log_likelihood = r(b15) , reps(1000) seed(9876) cluster(gvkey) idcluster(new_gvkey) group(gvkey): my_clust_mvreg_bs

*bootstrap Dummy=r(b1) ABOVE=r(b2) BELOW=r(b3) l_other_nbwc_two_t_1=r(b4) regulation_t_1=r(b5) astspec_t_1=r(b6) lnslack_avai_t_1=r(b7) firmsize5_t_1=r(b8) lnRnDinten_t_1=r(b9) ROA_t_1=r(b10) lambda_hat_new_409=r(b11) r_D_original=r(b12) r_A_original=r(b13) r_B_original=r(b14) Constant=r(b16) log_likelihood = r(b15) , reps(2000) seed(9876) cluster(gvkey) idcluster(new_gvkey) group(gvkey): my_clust_mvreg_bs

*esttab model1 model2 model3 using "E:\ECSR_3rd revision\SIC 2-digit\Main3_bootstrapped.csv" , cells(b(fmt(3) star) se(par)) stats(r2 ll N, labels(R-squared Log-likelihood N)   ) starlevels(* 0.1 ** 0.05 *** 0.01) varwidth(15)  postfoot( `"{hline @width}"' `"  * p<0.10    ** p<0.05    *** p<0.01  "'   `"  Robust standard errors in parentheses"') 

*esttab model1 model2 model3 using "E:\ECSR_3rd revision\SIC 2-digit\Main3_bootstrapped_IRR.csv" , cells(b(fmt(3) star) se(par)) stats(r2 ll N, labels(R-squared Log-likelihood N)   ) starlevels(* 0.1 ** 0.05 *** 0.01) varwidth(15)  postfoot( `"{hline @width}"' `"  * p<0.10    ** p<0.05    *** p<0.01  "'   `"  Robust standard errors in parentheses"') eform
}



*Table A24. Robustness of Main analysis (alternative IVs)
eststo: qui nbreg nbwc_to_Y02E_two  `main_IDV'   l_other_nbwc_two_t_1  `ctr' lambda_hat_3rd_rev3 r_D_robust r_A_robust r_B_robust  i.gvkey i.year if reg_382 == 1, robust cluster(gvkey) difficult



*Table A25a. Instrumental validity tests (alternative IVs)
{
ivreg2 nbwc_to_Y02E_two l_other_nbwc_two_t_1  regulation_t_1 astspec_t_1  lnslack_avai_t_1 firmsize5_t_1 lnRnDinten_t_1  ROA_t_1 (D_comb_s1h9_t_1 A_comb_s1h9_t_1 B_comb_s1h9_t_1 = quar_CO2_SIC_t_1 ratio_subsidiary_t_1  l_avg_damage_crops_2_t_1  cum_num_incen_t_1     ) lambda_hat_3rd_rev3  i.year i.gvkey if reg_382 ==1, robust cluster(gvkey) ffirst  partial(i.gvkey)
*                                           (Underid)            (Weak id)
*Variable     | F(  4,    75)  P-val | SW Chi-sq(  2) P-val | SW F(  2,    75)
*D_comb_s1h9_ |      13.83    0.0000 |        3.44   0.1789 |        1.28
*A_comb_s1h9_ |      17.89    0.0000 |        1.31   0.5200 |        0.49
*B_comb_s1h9_ |       2.06    0.0950 |        0.89   0.6409 |        0.33

*Kleibergen-Paap rk LM statistic          Chi-sq(2)=0.85     P-val=0.6538
*Kleibergen-Paap Wald rk F statistic                                 0.17
*Anderson-Rubin Wald test           F(4,75)=        0.62     P-val=0.6512
*Anderson-Rubin Wald test           Chi-sq(4)=      3.31     P-val=0.5069
*Stock-Wright LM S statistic        Chi-sq(4)=     11.97     P-val=0.0176
------------------------------------------------------------------------------
*Hansen J statistic (overidentification test of all instruments):         0.015
*                                                   Chi-sq(1) P-val =    0.9035
*Individual Hansen J statistic
*D_comb_s1h9_t_1: 2.477 (Chi-sq(3) P-val =    0.4794)
*A_comb_s1h9_t_1: 2.594 (Chi-sq(3) P-val =    0.4586)
*B_comb_s1h9_t_1: 2.280 (Chi-sq(3) P-val =    0.5164)
}



*Table A25b. Endogeneity and control function approach - first stage results (alternative IVs)
{
local IV_alt "quar_CO2_SIC_t_1 ratio_subsidiary_t_1  l_avg_damage_crops_2_t_1  cum_num_incen_t_1"

eststo: qui xtprobit D_comb_s1h9_t_1   `IV_alt'                                        i.year if reg_382 == 1, re i(gvkey)  vce(robust) difficult
eststo: qui xtprobit D_comb_s1h9_t_1               l_other_nbwc_two_t_1    `ctr'   i.year if reg_382 == 1, re i(gvkey)  vce(robust) difficult
eststo: qui xtprobit D_comb_s1h9_t_1   `IV_alt'    l_other_nbwc_two_t_1    `ctr'   i.year if reg_382 == 1, re i(gvkey)  vce(robust) difficult
*predict hat_IV, xb
*gen r_D_robust = normalden(hat_IV)/normal(hat_IV)
*drop hat_IV
						  
eststo: qui reg A_comb_s1h9_t_1  `IV_alt'                                       i.gvkey  i.year if reg_382 == 1, robust cluster(gvkey)
*di e(r2_a) // 0.75144543
eststo: qui reg A_comb_s1h9_t_1             l_other_nbwc_two_t_1     `ctr'  i.gvkey  i.year if reg_382 == 1, robust cluster(gvkey)
*di e(r2_a) // 0.68854905
eststo: qui reg A_comb_s1h9_t_1  `IV_alt'   l_other_nbwc_two_t_1     `ctr'  i.gvkey  i.year if reg_382 == 1, robust cluster(gvkey)
*di e(r2_a) // 0.76823141
 *predict r_A_robust, residual

eststo: qui reg B_comb_s1h9_t_1  `IV_alt'                                       i.gvkey  i.year if reg_382 == 1, robust cluster(gvkey) 
*di e(r2_a) // 0.58197367
eststo: qui reg B_comb_s1h9_t_1             l_other_nbwc_two_t_1     `ctr'  i.gvkey  i.year if reg_382 == 1, robust cluster(gvkey) 
*di e(r2_a) // 0.30856879
eststo: qui reg B_comb_s1h9_t_1  `IV_alt'   l_other_nbwc_two_t_1     `ctr'  i.gvkey  i.year if reg_382 == 1, robust cluster(gvkey) 
*di e(r2_a) // 0.58029644
*predict r_B_robust, residual
}


*Table A26. Robustness of Main analysis (regulation-based IVs)
eststo: qui nbreg nbwc_to_Y02E_two  `main_IDV'    l_other_nbwc_two_t_1  `ctr' lambda_samp_new_289    r_D_reguIV r_A_reguIV r_B_reguIV  i.year i.gvkey if reg_382 == 1, difficult cluster(gvkey) robust

{
capture program drop my_clust_mvreg_bs
program define my_clust_mvreg_bs, rclass
	
	nbreg nbwc_to_Y02E_two  D_comb_s1h9_t_1 A_comb_s1h9_t_1 B_comb_s1h9_t_1     l_other_nbwc_two_t_1  regulation_t_1 astspec_t_1  lnslack_avai_t_1 firmsize5_t_1 lnRnDinten_t_1  ROA_t_1  lambda_samp_new_289    r_D_R2 r_A_R2 r_B_R2  i.year i.gvkey if reg_382 == 1, difficult cluster(gvkey) robust

	
    local b1 = _b[nbwc_to_Y02E_two:D_comb_s1h9_t_1]
    local b2 = _b[nbwc_to_Y02E_two:A_comb_s1h9_t_1]
    local b3 = _b[nbwc_to_Y02E_two:B_comb_s1h9_t_1]
	local b4 = _b[nbwc_to_Y02E_two:l_other_nbwc_two_t_1]
	local b5 = _b[nbwc_to_Y02E_two:regulation_t_1]
	local b6 = _b[nbwc_to_Y02E_two:astspec_t_1]
	local b7 = _b[nbwc_to_Y02E_two:lnslack_avai_t_1]
	local b8 = _b[nbwc_to_Y02E_two:firmsize5_t_1]
	local b9 = _b[nbwc_to_Y02E_two:lnRnDinten_t_1]
	local b10 = _b[nbwc_to_Y02E_two:ROA_t_1]
	local b11 = _b[nbwc_to_Y02E_two:lambda_samp_new_289]
	local b12 = _b[nbwc_to_Y02E_two:r_D_R2]
	local b13 = _b[nbwc_to_Y02E_two:r_A_R2]
	local b14 = _b[nbwc_to_Y02E_two:r_B_R2]
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
bootstrap Dummy=r(b1) ABOVE=r(b2) BELOW=r(b3) l_other_nbwc_two_t_1=r(b4) regulation_t_1=r(b5) astspec_t_1=r(b6) lnslack_avai_t_1=r(b7) firmsize5_t_1=r(b8) lnRnDinten_t_1=r(b9) ROA_t_1=r(b10) lambda_samp_new_289=r(b11) r_D_R2=r(b12) r_A_R2=r(b13) r_B_R2=r(b14) Constant=r(b16) log_likelihood = r(b15) , reps(1000) seed(9876) cluster(gvkey) idcluster(new_gvkey) group(gvkey): my_clust_mvreg_bs
est store model3


}

*Table A26a. Instrumental validity tests (regulation-based IVs)
{
//quar_CO2_SIC_t_1  internal_carbon_v3_t_1   ln_En_En_PI_O20_t_1   l_avg_deaths_indirect_t_1
 ivreg2 nbwc_to_Y02E_two l_other_nbwc_two_t_1  regulation_t_1 astspec_t_1  lnslack_avai_t_1 firmsize5_t_1 lnRnDinten_t_1  ROA_t_1 (D_comb_s1h9_t_1 A_comb_s1h9_t_1 B_comb_s1h9_t_1 = quar_CO2_SIC_t_1  internal_carbon_v3_t_1   ln_En_En_PI_O20_t_1   l_avg_deaths_indirect_t_1) lambda_samp_new_289  i.year i.gvkey if reg_382 == 1, robust cluster(gvkey) first  partial(i.gvkey) liml
*                                           (Underid)            (Weak id)
*Variable     | F(  4,    54)  P-val | SW Chi-sq(  2) P-val | SW F(  2,    54)
*D_comb_s1h9_ |      12.71    0.0000 |        2.73   0.2549 |        1.01
*A_comb_s1h9_ |      24.96    0.0000 |        3.55   0.1698 |        1.31
*B_comb_s1h9_ |       2.44    0.0576 |       17.81   0.0001 |        6.56
*Stock-Wright LM S statistic        Chi-sq(4)=     27.77     P-val=0.0000

*individual Hansen'J statistics
*Dummy 5.801 (p=0.1217)
*ABOVE 5.963 (p=0.1134)
*BELOW 5.436 (p=0.1425)
}


*Table A26b. Endogeneity and control function approach - first stage results (regulation-based IVs)
{
*★ ln_En_En_PI_O20_t_1 <- maybe can be proxy for regulation-based IV
Has the company received product awards with respect to environmental responsibility? OR Does the company use product labels (e.g., FSC, Energy Star, MSC) indicating the environmental responsibility of its products? (Inactive as of FY2017 updates)

local IV_regu "quar_CO2_SIC_t_1  internal_carbon_v3_t_1   ln_En_En_PI_O20_t_1   l_avg_deaths_indirect_t_1"

eststo: qui xtprobit D_comb_s1h9_t_1   `IV_regu'                                 i.year if reg_382 == 1, re i(gvkey)  vce(robust) difficult
eststo: qui xtprobit D_comb_s1h9_t_1              l_other_nbwc_two_t_1   `ctr'   i.year if reg_382 == 1, re i(gvkey)  vce(robust) difficult
eststo: qui xtprobit D_comb_s1h9_t_1   `IV_regu'  l_other_nbwc_two_t_1   `ctr'   i.year if reg_382 == 1, re i(gvkey)  vce(robust) difficult
*predict hat_original, xb
*gen r_D_reguIV = normalden(hat_original)/normal(hat_original)
*drop hat_original 

eststo: qui reg A_comb_s1h9_t_1       `IV_regu'                                    i.year i.gvkey if reg_382 == 1, robust cluster(gvkey)
eststo: qui reg A_comb_s1h9_t_1                  l_other_nbwc_two_t_1     `ctr'    i.year i.gvkey if reg_382 == 1, robust cluster(gvkey)
eststo: qui reg A_comb_s1h9_t_1       `IV_regu'  l_other_nbwc_two_t_1     `ctr'    i.year i.gvkey if reg_382 == 1, robust cluster(gvkey)
*predict r_A_reguIV, residual

eststo: qui reg B_comb_s1h9_t_1     `IV_regu'                                     i.year i.gvkey if reg_382 == 1, robust cluster(gvkey)
eststo: qui reg B_comb_s1h9_t_1                 l_other_nbwc_two_t_1     `ctr'    i.year i.gvkey if reg_382 == 1, robust cluster(gvkey)
eststo: qui reg B_comb_s1h9_t_1     `IV_regu'   l_other_nbwc_two_t_1     `ctr'    i.year i.gvkey if reg_382 == 1, robust cluster(gvkey)
*predict r_B_reguIV, residual
}


*Table A27. Request from R1 - DV = Energy Purchased / IDV = historical, social
*** (with C12_1_cate_t_1)
eststo: qui	 reg ln_elec_purch CO2_ABOVE_his_l_8_dum_t_1 CO2_ABOVE_his_l_8_t_1   CO2_BELOW_his_l_8_t_1  C12_1_cate_t_1  l_other_nbwc_two_t_1 `ctr'  lambda_hat_new_409_elec_purch    r_D_original_his r_A_original_his r_B_original_his  i.gvkey i.year, robust cluster(gvkey)

eststo: qui 	reg ln_elec_purch D_soc_ver1_ps5_t_1 A_soc_ver1_ps5_t_1 B_soc_ver1_ps5_t_1 C12_1_cate_t_1 l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_elec_purch    r_D_original_soc r_A_original_soc r_B_original_soc  i.gvkey i.year if !missing(CO2_ABOVE_his_l_8_dum_t_1), robust cluster(gvkey)


***Wald test using suest 
*qui  reg ln_elec_purch CO2_ABOVE_his_l_8_dum_t_1 CO2_ABOVE_his_l_8_t_1   CO2_BELOW_his_l_8_t_1  C12_1_cate_t_1  l_other_nbwc_two_t_1 `ctr'  lambda_hat_new_409_elec_purch    r_D_original_his r_A_original_his r_B_original_his  i.gvkey i.year
*est store his
*gen gvkey_2 = gvkey
*qui  reg ln_elec_purch D_soc_ver1_ps5_t_1 A_soc_ver1_ps5_t_1 B_soc_ver1_ps5_t_1 C12_1_cate_t_1 l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_elec_purch    r_D_original_soc r_A_original_soc r_B_original_soc  i.gvkey_2 i.year if !missing(CO2_ABOVE_his_l_8_dum_t_1)
*est store soc
*suest his soc, cluster(gvkey) robust

*test _b[his_mean:CO2_ABOVE_his_l_8_dum_t_1] = _b[soc_mean:D_soc_ver1_ps5_t_1]
*           chi2(  1) =    1.30
*         Prob > chi2 =    0.2538


*test _b[his_mean:CO2_ABOVE_his_l_8_t_1] = _b[soc_mean:A_soc_ver1_ps5_t_1]
*           chi2(  1) =    3.26
*         Prob > chi2 =    0.0708


*test _b[his_mean:CO2_BELOW_his_l_8_t_1] = _b[soc_mean:B_soc_ver1_ps5_t_1]
*          chi2(  1) =    0.19
*        Prob > chi2 =    0.6661


eststo: qui 	reg ln_renew_purch CO2_ABOVE_his_l_8_dum_t_1 CO2_ABOVE_his_l_8_t_1   CO2_BELOW_his_l_8_t_1 C12_1_cate_t_1  l_other_nbwc_two_t_1 `ctr'  lambda_hat_new_409_renew_purch    r_D_original_his r_A_original_his r_B_original_his  i.gvkey i.year, robust cluster(gvkey)

eststo: qui	 reg ln_renew_purch D_soc_ver1_ps5_t_1 A_soc_ver1_ps5_t_1 B_soc_ver1_ps5_t_1 C12_1_cate_t_1 l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_renew_purch    r_D_original_soc r_A_original_soc r_B_original_soc  i.gvkey i.year if !missing(CO2_ABOVE_his_l_8_dum_t_1), robust cluster(gvkey)

***Wald test using suest 
*qui  reg ln_renew_purch CO2_ABOVE_his_l_8_dum_t_1 CO2_ABOVE_his_l_8_t_1   CO2_BELOW_his_l_8_t_1 C12_1_cate_t_1  l_other_nbwc_two_t_1 `ctr'  lambda_hat_new_409_renew_purch    r_D_original_his r_A_original_his r_B_original_his  i.gvkey i.year
*est store his
*gen gvkey_2 = gvkey
*qui  reg ln_renew_purch D_soc_ver1_ps5_t_1 A_soc_ver1_ps5_t_1 B_soc_ver1_ps5_t_1 C12_1_cate_t_1 l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_renew_purch    r_D_original_soc r_A_original_soc r_B_original_soc  i.gvkey_2 i.year if !missing(CO2_ABOVE_his_l_8_dum_t_1)
*est store soc
*suest his soc, cluster(gvkey) robust

*test _b[his_mean:CO2_ABOVE_his_l_8_dum_t_1] = _b[soc_mean:D_soc_ver1_ps5_t_1]
*           chi2(  1) =    0.27
*         Prob > chi2 =    0.6025

*test _b[his_mean:CO2_ABOVE_his_l_8_t_1] = _b[soc_mean:A_soc_ver1_ps5_t_1]
*           chi2(  1) =    1.23
*         Prob > chi2 =    0.2678

*test _b[his_mean:CO2_BELOW_his_l_8_t_1] = _b[soc_mean:B_soc_ver1_ps5_t_1]
*           chi2(  1) =    5.23
*         Prob > chi2 =    0.0222



eststo: qui 	reg ln_energy_purch CO2_ABOVE_his_l_8_dum_t_1 CO2_ABOVE_his_l_8_t_1   CO2_BELOW_his_l_8_t_1 C12_1_cate_t_1  l_other_nbwc_two_t_1 `ctr'  lambda_hat_new_409_energy_purch    r_D_original_his r_A_original_his r_B_original_his  i.gvkey i.year, robust cluster(gvkey)

eststo: qui	 reg ln_energy_purch D_soc_ver1_ps5_t_1 A_soc_ver1_ps5_t_1 B_soc_ver1_ps5_t_1 C12_1_cate_t_1  l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_energy_purch     r_D_original_soc r_A_original_soc r_B_original_soc  i.gvkey i.year if !missing(CO2_ABOVE_his_l_8_dum_t_1), robust cluster(gvkey)

***Wald test using suest 
*qui  reg ln_energy_purch CO2_ABOVE_his_l_8_dum_t_1 CO2_ABOVE_his_l_8_t_1   CO2_BELOW_his_l_8_t_1 C12_1_cate_t_1  l_other_nbwc_two_t_1 `ctr'  lambda_hat_new_409_energy_purch    r_D_original_his r_A_original_his r_B_original_his  i.gvkey i.year
*est store his
*gen gvkey_2 = gvkey
*qui  reg ln_energy_purch D_soc_ver1_ps5_t_1 A_soc_ver1_ps5_t_1 B_soc_ver1_ps5_t_1 C12_1_cate_t_1  l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_energy_purch     r_D_original_soc r_A_original_soc r_B_original_soc  i.gvkey_2 i.year if !missing(CO2_ABOVE_his_l_8_dum_t_1)
*est store soc
*suest his soc, cluster(gvkey) robust

*test _b[his_mean:CO2_ABOVE_his_l_8_dum_t_1] = _b[soc_mean:D_soc_ver1_ps5_t_1]
*           chi2(  1) =    0.00
*         Prob > chi2 =    0.9712

*test _b[his_mean:CO2_ABOVE_his_l_8_t_1] = _b[soc_mean:A_soc_ver1_ps5_t_1]
*           chi2(  1) =    7.13
*         Prob > chi2 =    0.0076

*test _b[his_mean:CO2_BELOW_his_l_8_t_1] = _b[soc_mean:B_soc_ver1_ps5_t_1]
*           chi2(  1) =    0.03
*         Prob > chi2 =    0.8577


*** (without C12_1_cate_t_1)
eststo: qui	 reg ln_elec_purch CO2_ABOVE_his_l_8_dum_t_1 CO2_ABOVE_his_l_8_t_1   CO2_BELOW_his_l_8_t_1   l_other_nbwc_two_t_1 `ctr'  lambda_hat_new_409_elec_purch    r_D_original_his r_A_original_his r_B_original_his  i.gvkey i.year, robust cluster(gvkey)

eststo: qui 	reg ln_elec_purch D_soc_ver1_ps5_t_1 A_soc_ver1_ps5_t_1 B_soc_ver1_ps5_t_1  l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_elec_purch    r_D_original_soc r_A_original_soc r_B_original_soc  i.gvkey i.year if !missing(CO2_ABOVE_his_l_8_dum_t_1), robust cluster(gvkey)

***Wald test using suest 
*qui  reg ln_elec_purch CO2_ABOVE_his_l_8_dum_t_1 CO2_ABOVE_his_l_8_t_1   CO2_BELOW_his_l_8_t_1   l_other_nbwc_two_t_1 `ctr'  lambda_hat_new_409_elec_purch    r_D_original_his r_A_original_his r_B_original_his  i.gvkey i.year
*est store his
*gen gvkey_2 = gvkey
*qui  reg ln_elec_purch D_soc_ver1_ps5_t_1 A_soc_ver1_ps5_t_1 B_soc_ver1_ps5_t_1  l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_elec_purch    r_D_original_soc r_A_original_soc r_B_original_soc  i.gvkey_2 i.year if !missing(CO2_ABOVE_his_l_8_dum_t_1)
*est store soc
*suest his soc, cluster(gvkey) robust

*test _b[his_mean:CO2_ABOVE_his_l_8_dum_t_1] = _b[soc_mean:D_soc_ver1_ps5_t_1]
*           chi2(  1) =    1.47
*         Prob > chi2 =    0.2248

*test _b[his_mean:CO2_ABOVE_his_l_8_t_1] = _b[soc_mean:A_soc_ver1_ps5_t_1]
*           chi2(  1) =    0.01
*         Prob > chi2 =    0.9123

*test _b[his_mean:CO2_BELOW_his_l_8_t_1] = _b[soc_mean:B_soc_ver1_ps5_t_1]
*           chi2(  1) =    4.51
*         Prob > chi2 =    0.0337


eststo: qui 	reg ln_renew_purch CO2_ABOVE_his_l_8_dum_t_1 CO2_ABOVE_his_l_8_t_1   CO2_BELOW_his_l_8_t_1   l_other_nbwc_two_t_1 `ctr'  lambda_hat_new_409_renew_purch    r_D_original_his r_A_original_his r_B_original_his  i.gvkey i.year, robust cluster(gvkey)

eststo: qui	 reg ln_renew_purch D_soc_ver1_ps5_t_1 A_soc_ver1_ps5_t_1 B_soc_ver1_ps5_t_1  l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_renew_purch    r_D_original_soc r_A_original_soc r_B_original_soc  i.gvkey i.year if !missing(CO2_ABOVE_his_l_8_dum_t_1), robust cluster(gvkey)

***Wald test using suest 
*qui  reg ln_renew_purch CO2_ABOVE_his_l_8_dum_t_1 CO2_ABOVE_his_l_8_t_1   CO2_BELOW_his_l_8_t_1   l_other_nbwc_two_t_1 `ctr'  lambda_hat_new_409_renew_purch    r_D_original_his r_A_original_his r_B_original_his  i.gvkey i.year
*est store his
*gen gvkey_2 = gvkey
*qui  reg ln_renew_purch D_soc_ver1_ps5_t_1 A_soc_ver1_ps5_t_1 B_soc_ver1_ps5_t_1  l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_renew_purch    r_D_original_soc r_A_original_soc r_B_original_soc  i.gvkey_2 i.year if !missing(CO2_ABOVE_his_l_8_dum_t_1)
*est store soc
*suest his soc, cluster(gvkey) robust

*test _b[his_mean:CO2_ABOVE_his_l_8_dum_t_1] = _b[soc_mean:D_soc_ver1_ps5_t_1]
*           chi2(  1) =    0.29
*         Prob > chi2 =    0.5927

*test _b[his_mean:CO2_ABOVE_his_l_8_t_1] = _b[soc_mean:A_soc_ver1_ps5_t_1]
*           chi2(  1) =    0.72
*         Prob > chi2 =    0.3966

*test _b[his_mean:CO2_BELOW_his_l_8_t_1] = _b[soc_mean:B_soc_ver1_ps5_t_1]
*           chi2(  1) =    0.53
*         Prob > chi2 =    0.4680


eststo: qui 	reg ln_energy_purch CO2_ABOVE_his_l_8_dum_t_1 CO2_ABOVE_his_l_8_t_1   CO2_BELOW_his_l_8_t_1   l_other_nbwc_two_t_1 `ctr'  lambda_hat_new_409_energy_purch    r_D_original_his r_A_original_his r_B_original_his  i.gvkey i.year, robust cluster(gvkey)

eststo: qui	 reg ln_energy_purch D_soc_ver1_ps5_t_1 A_soc_ver1_ps5_t_1 B_soc_ver1_ps5_t_1  l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_energy_purch     r_D_original_soc r_A_original_soc r_B_original_soc  i.gvkey i.year if !missing(CO2_ABOVE_his_l_8_dum_t_1), robust cluster(gvkey)

***Wald test using suest 
*qui  reg ln_energy_purch CO2_ABOVE_his_l_8_dum_t_1 CO2_ABOVE_his_l_8_t_1   CO2_BELOW_his_l_8_t_1   l_other_nbwc_two_t_1 `ctr'  lambda_hat_new_409_energy_purch    r_D_original_his r_A_original_his r_B_original_his  i.gvkey i.year
*est store his
*gen gvkey_2 = gvkey
*qui  reg ln_energy_purch D_soc_ver1_ps5_t_1 A_soc_ver1_ps5_t_1 B_soc_ver1_ps5_t_1  l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_energy_purch     r_D_original_soc r_A_original_soc r_B_original_soc  i.gvkey_2 i.year if !missing(CO2_ABOVE_his_l_8_dum_t_1)
*est store soc
*suest his soc, cluster(gvkey) robust

*test _b[his_mean:CO2_ABOVE_his_l_8_dum_t_1] = _b[soc_mean:D_soc_ver1_ps5_t_1]
*           chi2(  1) =    0.14
*         Prob > chi2 =    0.7084

*test _b[his_mean:CO2_ABOVE_his_l_8_t_1] = _b[soc_mean:A_soc_ver1_ps5_t_1]
*           chi2(  1) =    0.03
*         Prob > chi2 =    0.8590

*test _b[his_mean:CO2_BELOW_his_l_8_t_1] = _b[soc_mean:B_soc_ver1_ps5_t_1]
*           chi2(  1) =    4.04
*         Prob > chi2 =    0.0443



****Reviewer 1 Comment #01

*DV = Energy Purchase | IDV = historical only , social only 
{
*creating duration variable
{
*CO2_ABOVE_his_l_8_dum_t_1 CO2_ABOVE_his_l_8_t_1   CO2_BELOW_his_l_8_t_1
*D_soc_ver1_ps5_t_1 A_soc_ver1_ps5_t_1 B_soc_ver1_ps5_t_1

	gen D_B_soc_ver1_ps5 = D_soc_ver1_ps5
	replace D_B_soc_ver1_ps5 = 1 if D_soc_ver1_ps5 == 0
	replace D_B_soc_ver1_ps5 = 0 if D_soc_ver1_ps5 == 1
	
	bysort gvkey (year) : gen A_dur_social = D_soc_ver1_ps5 == 1 & (_n == 1 | D_soc_ver1_ps5[_n-1] == 0)
	by gvkey: replace A_dur_social = A_dur_social[_n-1] + 1 if D_soc_ver1_ps5 == 1 & A_dur_social == 0
	
	bysort gvkey (year) : gen B_dur_social = D_B_soc_ver1_ps5 == 1 & (_n == 1 | D_B_soc_ver1_ps5[_n-1] == 0)
	by gvkey: replace B_dur_social = B_dur_social[_n-1] + 1 if D_B_soc_ver1_ps5 == 1 & B_dur_social == 0

	replace A_dur_social = . if missing(D_soc_ver1_ps5)
	replace B_dur_social = . if missing(D_B_soc_ver1_ps5)

	sort gvkey year

	by gvkey: gen A_dur_social_t_1 = A_dur_social[_n-1]
	by gvkey: gen B_dur_social_t_1 = B_dur_social[_n-1]
}


*duration: ABOVE_dur_his_l_8_t_1 BELOW_dur_his_l_8_t_1
*duration: A_dur_social_t_1 B_dur_social_t_1
	
**control: (duration)  ln_total_energy_use_t_1  
**C14_1_dum_En_En_ER_DP068_t_1 C14_2_dum_En_En_ER_DP097_dum_t_1
**C12_1_cate_t_1  incen_money_new_t_1 C1_2_dum_t_1 ENV_str_D_t_1 l_nbwc_to_Y02E_two_t_1
	
local historical "CO2_ABOVE_his_l_8_dum_t_1 CO2_ABOVE_his_l_8_t_1   CO2_BELOW_his_l_8_t_1"
local social "D_soc_ver1_ps5_t_1 A_soc_ver1_ps5_t_1 B_soc_ver1_ps5_t_1"

local his_IV "r_D_original_his r_A_original_his r_B_original_his"
local soc_IV "r_D_original_soc r_A_original_soc r_B_original_soc"

*****electricity purchase
*original model
eststo: qui   reg ln_elec_purch  `main_IDV'   l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_elec_purch    `main_IV' i.gvkey i.year, robust cluster(gvkey)
eststo: qui	  reg ln_elec_purch  `historical'  l_other_nbwc_two_t_1 `ctr'  lambda_hat_new_409_elec_purch     `his_IV' i.gvkey i.year, robust cluster(gvkey)
eststo: qui   reg ln_elec_purch `social'  l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_elec_purch  `soc_IV'    i.gvkey i.year if !missing(CO2_ABOVE_his_l_8_dum_t_1), robust cluster(gvkey)

*adding duration, C12_1_cate_t_1
eststo: qui   reg ln_elec_purch  `main_IDV'  A_dur_s1h9_t_1 B_dur_s1h9_t_1 C12_1_cate_t_1 l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_elec_purch    `main_IV' i.gvkey i.year, robust cluster(gvkey)
eststo: qui	  reg ln_elec_purch  `historical'  ABOVE_dur_his_l_8_t_1 BELOW_dur_his_l_8_t_1  C12_1_cate_t_1  l_other_nbwc_two_t_1 `ctr'  lambda_hat_new_409_elec_purch     `his_IV' i.gvkey i.year, robust cluster(gvkey)
eststo: qui   reg ln_elec_purch `social'  A_dur_social_t_1 B_dur_social_t_1  C12_1_cate_t_1 l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_elec_purch  `soc_IV'    i.gvkey i.year if !missing(CO2_ABOVE_his_l_8_dum_t_1), robust cluster(gvkey)


*adding duration, C12_1_cate_t_1, ln_total_energy_use_t_1
eststo: qui   reg ln_elec_purch  `main_IDV'  A_dur_s1h9_t_1 B_dur_s1h9_t_1  C12_1_cate_t_1  ln_total_energy_use_t_1 l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_elec_purch    `main_IV' i.gvkey i.year, robust cluster(gvkey)
eststo: qui	  reg ln_elec_purch  `historical'  ABOVE_dur_his_l_8_t_1 BELOW_dur_his_l_8_t_1 C12_1_cate_t_1  ln_total_energy_use_t_1  l_other_nbwc_two_t_1 `ctr'  lambda_hat_new_409_elec_purch     `his_IV' i.gvkey i.year, robust cluster(gvkey)
eststo: qui   reg ln_elec_purch `social'  A_dur_social_t_1 B_dur_social_t_1  C12_1_cate_t_1  ln_total_energy_use_t_1 l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_elec_purch  `soc_IV'    i.gvkey i.year if !missing(CO2_ABOVE_his_l_8_dum_t_1), robust cluster(gvkey)

*adding duration, C12_1_cate_t_1, ln_total_energy_use_t_1, ETS, Carbon Credit purchase
eststo: qui   reg ln_elec_purch  `main_IDV'  A_dur_s1h9_t_1 B_dur_s1h9_t_1  C12_1_cate_t_1  ln_total_energy_use_t_1 C14_1_dum_En_En_ER_DP068_t_1  C14_2_dum_En_En_ER_DP097_dum_t_1  l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_elec_purch    `main_IV' i.gvkey i.year, robust cluster(gvkey)
eststo: qui	  reg ln_elec_purch  `historical'  ABOVE_dur_his_l_8_t_1 BELOW_dur_his_l_8_t_1  C12_1_cate_t_1 ln_total_energy_use_t_1  C14_1_dum_En_En_ER_DP068_t_1  C14_2_dum_En_En_ER_DP097_dum_t_1   l_other_nbwc_two_t_1 `ctr'  lambda_hat_new_409_elec_purch     `his_IV' i.gvkey i.year, robust cluster(gvkey)
eststo: qui   reg ln_elec_purch `social'  A_dur_social_t_1 B_dur_social_t_1 C12_1_cate_t_1  ln_total_energy_use_t_1 C14_1_dum_En_En_ER_DP068_t_1 C14_2_dum_En_En_ER_DP097_dum_t_1  l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_elec_purch  `soc_IV'    i.gvkey i.year if !missing(CO2_ABOVE_his_l_8_dum_t_1), robust cluster(gvkey)

*adding duration, C12_1_cate_t_1, ln_total_energy_use_t_1, ETS, Carbon Credit purchase, incentive provision
eststo: qui reg ln_elec_purch  `main_IDV'  A_dur_s1h9_t_1 B_dur_s1h9_t_1  C12_1_cate_t_1  ln_total_energy_use_t_1 C14_1_dum_En_En_ER_DP068_t_1  C14_2_dum_En_En_ER_DP097_dum_t_1 C1_2_dum_t_1  l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_elec_purch    `main_IV' i.gvkey i.year, robust cluster(gvkey)
eststo: qui   reg ln_elec_purch  `historical'  ABOVE_dur_his_l_8_t_1 BELOW_dur_his_l_8_t_1 C12_1_cate_t_1  ln_total_energy_use_t_1  C14_1_dum_En_En_ER_DP068_t_1  C14_2_dum_En_En_ER_DP097_dum_t_1 C1_2_dum_t_1  l_other_nbwc_two_t_1 `ctr'  lambda_hat_new_409_elec_purch     `his_IV' i.gvkey i.year, robust cluster(gvkey)
eststo: qui reg ln_elec_purch `social'  A_dur_social_t_1 B_dur_social_t_1  C12_1_cate_t_1 ln_total_energy_use_t_1 C14_1_dum_En_En_ER_DP068_t_1 C14_2_dum_En_En_ER_DP097_dum_t_1 C1_2_dum_t_1  l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_elec_purch  `soc_IV'    i.gvkey i.year if !missing(CO2_ABOVE_his_l_8_dum_t_1), robust cluster(gvkey)






*****renew purchase
*original model
eststo: qui reg ln_renew_purch  `main_IDV'  l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_renew_purch   `main_IV' i.gvkey i.year, robust cluster(gvkey)  
eststo: qui reg ln_renew_purch `historical'   l_other_nbwc_two_t_1 `ctr'  lambda_hat_new_409_renew_purch   `his_IV'  i.gvkey i.year, robust cluster(gvkey)
eststo: qui reg ln_renew_purch `social'  l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_renew_purch   `soc_IV'   i.gvkey i.year if !missing(CO2_ABOVE_his_l_8_dum_t_1), robust cluster(gvkey)

*adding duration, C12_1_cate_t_1
eststo: qui reg ln_renew_purch  `main_IDV'  A_dur_s1h9_t_1 B_dur_s1h9_t_1  C12_1_cate_t_1   l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_renew_purch   `main_IV' i.gvkey i.year, robust cluster(gvkey)  
eststo: qui reg ln_renew_purch `historical'  ABOVE_dur_his_l_8_t_1 BELOW_dur_his_l_8_t_1 C12_1_cate_t_1  l_other_nbwc_two_t_1 `ctr'  lambda_hat_new_409_renew_purch   `his_IV'  i.gvkey i.year, robust cluster(gvkey)
eststo: qui reg ln_renew_purch `social'  A_dur_social_t_1 B_dur_social_t_1 C12_1_cate_t_1 l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_renew_purch   `soc_IV'   i.gvkey i.year if !missing(CO2_ABOVE_his_l_8_dum_t_1), robust cluster(gvkey)

*adding duration, C12_1_cate_t_1, ln_total_energy_use_t_1
eststo: qui reg ln_renew_purch  `main_IDV'  A_dur_s1h9_t_1 B_dur_s1h9_t_1  C12_1_cate_t_1 ln_total_energy_use_t_1  l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_renew_purch   `main_IV' i.gvkey i.year, robust cluster(gvkey)  
eststo: qui reg ln_renew_purch `historical'  ABOVE_dur_his_l_8_t_1 BELOW_dur_his_l_8_t_1  C12_1_cate_t_1 ln_total_energy_use_t_1  l_other_nbwc_two_t_1 `ctr'  lambda_hat_new_409_renew_purch   `his_IV'  i.gvkey i.year, robust cluster(gvkey)
eststo: qui reg ln_renew_purch `social'  A_dur_social_t_1 B_dur_social_t_1  C12_1_cate_t_1 ln_total_energy_use_t_1 l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_renew_purch   `soc_IV'   i.gvkey i.year if !missing(CO2_ABOVE_his_l_8_dum_t_1), robust cluster(gvkey)

*adding duration, C12_1_cate_t_1, ln_total_energy_use_t_1, ETS, Carbon Credit purchase
eststo: qui reg ln_renew_purch  `main_IDV'  A_dur_s1h9_t_1 B_dur_s1h9_t_1  C12_1_cate_t_1 ln_total_energy_use_t_1  C14_1_dum_En_En_ER_DP068_t_1 C14_2_dum_En_En_ER_DP097_dum_t_1  l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_renew_purch   `main_IV' i.gvkey i.year, robust cluster(gvkey)  
eststo: qui reg ln_renew_purch `historical'  ABOVE_dur_his_l_8_t_1 BELOW_dur_his_l_8_t_1  C12_1_cate_t_1 ln_total_energy_use_t_1  C14_1_dum_En_En_ER_DP068_t_1 C14_2_dum_En_En_ER_DP097_dum_t_1  l_other_nbwc_two_t_1 `ctr'  lambda_hat_new_409_renew_purch   `his_IV'  i.gvkey i.year, robust cluster(gvkey)
eststo: qui reg ln_renew_purch `social'  A_dur_social_t_1 B_dur_social_t_1  C12_1_cate_t_1 ln_total_energy_use_t_1  C14_1_dum_En_En_ER_DP068_t_1 C14_2_dum_En_En_ER_DP097_dum_t_1  l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_renew_purch   `soc_IV'   i.gvkey i.year if !missing(CO2_ABOVE_his_l_8_dum_t_1), robust cluster(gvkey)

*adding duration, C12_1_cate_t_1, ln_total_energy_use_t_1, ETS, Carbon Credit purchase, incentive provision
eststo: qui reg ln_renew_purch  `main_IDV'  A_dur_s1h9_t_1 B_dur_s1h9_t_1  C12_1_cate_t_1 ln_total_energy_use_t_1  C14_1_dum_En_En_ER_DP068_t_1 C14_2_dum_En_En_ER_DP097_dum_t_1 C1_2_dum_t_1   l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_renew_purch   `main_IV' i.gvkey i.year, robust cluster(gvkey)  
eststo: qui reg ln_renew_purch `historical'  ABOVE_dur_his_l_8_t_1 BELOW_dur_his_l_8_t_1  C12_1_cate_t_1 ln_total_energy_use_t_1  C14_1_dum_En_En_ER_DP068_t_1 C14_2_dum_En_En_ER_DP097_dum_t_1  C1_2_dum_t_1 l_other_nbwc_two_t_1 `ctr'  lambda_hat_new_409_renew_purch   `his_IV'  i.gvkey i.year, robust cluster(gvkey)
eststo: qui reg ln_renew_purch `social'  A_dur_social_t_1 B_dur_social_t_1  C12_1_cate_t_1 ln_total_energy_use_t_1  C14_1_dum_En_En_ER_DP068_t_1 C14_2_dum_En_En_ER_DP097_dum_t_1  C1_2_dum_t_1  l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_renew_purch   `soc_IV'   i.gvkey i.year if !missing(CO2_ABOVE_his_l_8_dum_t_1), robust cluster(gvkey)





*****energy purchase
*original model
eststo: qui  reg ln_energy_purch `main_IDV'  l_other_nbwc_two_t_1 `ctr'   lambda_hat_new_409_energy_purch  `main_IV' i.gvkey i.year, robust cluster(gvkey)
eststo: qui  reg ln_energy_purch `historical'   l_other_nbwc_two_t_1 `ctr'  lambda_hat_new_409_energy_purch    `his_IV'  i.gvkey i.year, robust cluster(gvkey)
eststo: qui	 reg ln_energy_purch `social'  l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_energy_purch     `soc_IV'   i.gvkey i.year if !missing(CO2_ABOVE_his_l_8_dum_t_1), robust cluster(gvkey)
	
*adding duration, C12_1_cate_t_1
eststo: qui  reg ln_energy_purch `main_IDV'  A_dur_s1h9_t_1 B_dur_s1h9_t_1  C12_1_cate_t_1  l_other_nbwc_two_t_1 `ctr'   lambda_hat_new_409_energy_purch  `main_IV' i.gvkey i.year, robust cluster(gvkey)
eststo: qui  reg ln_energy_purch `historical' ABOVE_dur_his_l_8_t_1 BELOW_dur_his_l_8_t_1  C12_1_cate_t_1   l_other_nbwc_two_t_1 `ctr'  lambda_hat_new_409_energy_purch    `his_IV'  i.gvkey i.year, robust cluster(gvkey)
eststo: qui	 reg ln_energy_purch `social'  A_dur_social_t_1 B_dur_social_t_1 C12_1_cate_t_1 l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_energy_purch     `soc_IV'   i.gvkey i.year if !missing(CO2_ABOVE_his_l_8_dum_t_1), robust cluster(gvkey)

*adding duration, C12_1_cate_t_1, ln_total_energy_use_t_1
eststo: qui  reg ln_energy_purch `main_IDV'  A_dur_s1h9_t_1 B_dur_s1h9_t_1 C12_1_cate_t_1   ln_total_energy_use_t_1  l_other_nbwc_two_t_1 `ctr'   lambda_hat_new_409_energy_purch  `main_IV' i.gvkey i.year, robust cluster(gvkey)
eststo: qui  reg ln_energy_purch `historical' ABOVE_dur_his_l_8_t_1 BELOW_dur_his_l_8_t_1 C12_1_cate_t_1  ln_total_energy_use_t_1  l_other_nbwc_two_t_1 `ctr'  lambda_hat_new_409_energy_purch    `his_IV'  i.gvkey i.year, robust cluster(gvkey)
eststo: qui	 reg ln_energy_purch `social'  A_dur_social_t_1 B_dur_social_t_1  C12_1_cate_t_1 ln_total_energy_use_t_1 l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_energy_purch     `soc_IV'   i.gvkey i.year if !missing(CO2_ABOVE_his_l_8_dum_t_1), robust cluster(gvkey)

*adding duration, C12_1_cate_t_1, ln_total_energy_use_t_1, ETS, Carbon Credit purchase
eststo: qui  reg ln_energy_purch `main_IDV'  A_dur_s1h9_t_1 B_dur_s1h9_t_1  C12_1_cate_t_1  ln_total_energy_use_t_1  C14_1_dum_En_En_ER_DP068_t_1 C14_2_dum_En_En_ER_DP097_dum_t_1  l_other_nbwc_two_t_1 `ctr'   lambda_hat_new_409_energy_purch  `main_IV' i.gvkey i.year, robust cluster(gvkey)
eststo: qui  reg ln_energy_purch `historical' ABOVE_dur_his_l_8_t_1 BELOW_dur_his_l_8_t_1  C12_1_cate_t_1  ln_total_energy_use_t_1  C14_1_dum_En_En_ER_DP068_t_1 C14_2_dum_En_En_ER_DP097_dum_t_1 l_other_nbwc_two_t_1 `ctr'  lambda_hat_new_409_energy_purch    `his_IV'  i.gvkey i.year, robust cluster(gvkey)
eststo: qui	 reg ln_energy_purch `social'  A_dur_social_t_1 B_dur_social_t_1  C12_1_cate_t_1 ln_total_energy_use_t_1  C14_1_dum_En_En_ER_DP068_t_1 C14_2_dum_En_En_ER_DP097_dum_t_1  l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_energy_purch     `soc_IV'   i.gvkey i.year if !missing(CO2_ABOVE_his_l_8_dum_t_1), robust cluster(gvkey)

*adding duration, C12_1_cate_t_1, ln_total_energy_use_t_1, ETS, Carbon Credit purchase, incentive provision
eststo: qui  reg ln_energy_purch `main_IDV'  A_dur_s1h9_t_1 B_dur_s1h9_t_1   C12_1_cate_t_1  ln_total_energy_use_t_1  C14_1_dum_En_En_ER_DP068_t_1 C14_2_dum_En_En_ER_DP097_dum_t_1 C1_2_dum_t_1   l_other_nbwc_two_t_1 `ctr'   lambda_hat_new_409_energy_purch  `main_IV' i.gvkey i.year, robust cluster(gvkey)
eststo: qui  reg ln_energy_purch `historical' ABOVE_dur_his_l_8_t_1 BELOW_dur_his_l_8_t_1  C12_1_cate_t_1  ln_total_energy_use_t_1  C14_1_dum_En_En_ER_DP068_t_1 C14_2_dum_En_En_ER_DP097_dum_t_1  C1_2_dum_t_1 l_other_nbwc_two_t_1 `ctr'  lambda_hat_new_409_energy_purch    `his_IV'  i.gvkey i.year, robust cluster(gvkey)
eststo: qui	 reg ln_energy_purch `social'  A_dur_social_t_1 B_dur_social_t_1  C12_1_cate_t_1   ln_total_energy_use_t_1  C14_1_dum_En_En_ER_DP068_t_1 C14_2_dum_En_En_ER_DP097_dum_t_1  C1_2_dum_t_1  l_other_nbwc_two_t_1  `ctr'  lambda_hat_new_409_energy_purch     `soc_IV'   i.gvkey i.year if !missing(CO2_ABOVE_his_l_8_dum_t_1), robust cluster(gvkey)
}


*DV = ETS_CC (1 if a firm participates ETS and/or Carbon credit transaction,  0 otherwise)
{
egen ETS_CC = rowtotal( C14_1_dum_En_En_ER_DP068 C14_2_dum_En_En_ER_DP097_dum )
replace ETS_CC = 1 if ETS_CC == 2

eststo: qui   xtprobit    ETS_CC  `main_IDV'    l_other_nbwc_two_t_1  `ctr' lambda_hat_new_409  `main_IV'  i.year if reg_362 == 1, re i(gvkey) difficult
eststo: qui   xtprobit    ETS_CC  `historical'   l_other_nbwc_two_t_1   `ctr' lambda_hat_new_409  r_D_original_his r_A_original_his r_B_original_his   i.year if reg_362 == 1, re i(gvkey) difficult
eststo: qui   xtprobit    ETS_CC  `social'   l_other_nbwc_two_t_1   `ctr' lambda_hat_new_409  r_D_original_soc r_A_original_soc r_B_original_soc  i.year if reg_362 == 1, re i(gvkey) difficult
	
*duration, C12_1_cate_t_1
eststo: qui   xtprobit    ETS_CC  `main_IDV'    A_dur_s1h9_t_1 B_dur_s1h9_t_1  C12_1_cate_t_1  l_other_nbwc_two_t_1  `ctr' lambda_hat_new_409  `main_IV'  i.year if reg_362 == 1, re i(gvkey) difficult
eststo: qui   xtprobit    ETS_CC  `historical'  ABOVE_dur_his_l_8_t_1 BELOW_dur_his_l_8_t_1 C12_1_cate_t_1  l_other_nbwc_two_t_1   `ctr' lambda_hat_new_409  r_D_original_his r_A_original_his r_B_original_his   i.year if reg_362 == 1, re i(gvkey) difficult
eststo: qui   xtprobit    ETS_CC   `social'   A_dur_social_t_1 B_dur_social_t_1  C12_1_cate_t_1  l_other_nbwc_two_t_1   `ctr' lambda_hat_new_409  r_D_original_soc r_A_original_soc r_B_original_soc  i.year if reg_362 == 1, re i(gvkey) difficult
	
*duration, C12_1_cate_t_1, ln_total_energy_use_t_1
eststo: qui   xtprobit    ETS_CC  `main_IDV'    A_dur_s1h9_t_1 B_dur_s1h9_t_1  C12_1_cate_t_1  ln_total_energy_use_t_1 l_other_nbwc_two_t_1  `ctr' lambda_hat_new_409  `main_IV'  i.year if reg_362 == 1, re i(gvkey) difficult
eststo: qui   xtprobit    ETS_CC  `historical'  ABOVE_dur_his_l_8_t_1 BELOW_dur_his_l_8_t_1 C12_1_cate_t_1  ln_total_energy_use_t_1 l_other_nbwc_two_t_1   `ctr' lambda_hat_new_409  r_D_original_his r_A_original_his r_B_original_his   i.year if reg_362 == 1, re i(gvkey) difficult
eststo: qui   xtprobit    ETS_CC   `social'   A_dur_social_t_1 B_dur_social_t_1  C12_1_cate_t_1  ln_total_energy_use_t_1 l_other_nbwc_two_t_1   `ctr' lambda_hat_new_409  r_D_original_soc r_A_original_soc r_B_original_soc  i.year if reg_362 == 1, re i(gvkey) difficult

*duration, C12_1_cate_t_1, ln_total_energy_use_t_1, carbon credit purchase, energy purchase, incentive provision
eststo: qui   xtprobit    ETS_CC  `main_IDV'    A_dur_s1h9_t_1 B_dur_s1h9_t_1  C12_1_cate_t_1  ln_total_energy_use_t_1      C1_2_dum_t_1  l_other_nbwc_two_t_1  `ctr' lambda_hat_new_409  `main_IV'  i.year if reg_362 == 1, re i(gvkey) difficult
eststo: qui   xtprobit    ETS_CC  `historical'  ABOVE_dur_his_l_8_t_1 BELOW_dur_his_l_8_t_1 C12_1_cate_t_1  ln_total_energy_use_t_1      C1_2_dum_t_1  l_other_nbwc_two_t_1   `ctr' lambda_hat_new_409  r_D_original_his r_A_original_his r_B_original_his   i.year if reg_362 == 1, re i(gvkey) difficult
eststo: qui   xtprobit    ETS_CC   `social'   A_dur_social_t_1 B_dur_social_t_1  C12_1_cate_t_1  ln_total_energy_use_t_1     C1_2_dum_t_1 l_other_nbwc_two_t_1   `ctr' lambda_hat_new_409  r_D_original_soc r_A_original_soc r_B_original_soc  i.year if reg_362 == 1, re i(gvkey) difficult


	
}




****Reviewer 1 Comment #02 
* Table A18: DV = Environmental Product Development

{
*En_En_PI_O01 (enviornmental products)
*(Does the company report on at least one product line or service that is designed to have positive effects on the environment or which is environmentally labeled and marketed?)

*En_En_PI_O13 (eco-design products)
*(Does the company report on specific products which are designed for reuse, recycling or the reduction of environmental impacts?)

*En_En_PI_O04 (environmental R&D)
*(Does the company invest in R&D on new environmentally friendly products or services that will limit the amount of emissions and resources needed during product use? (Inactive as of FY2017 updates)

*En_En_PI_DP024 (env R&D / dummy variable)
*(Does the company invest in R&D on new environmentally friendly products or services that will limit the amount of emissions and resources needed during product use? (Inactive as of FY2014 updates))

*InnovationScore (the extent of a firm's capacity to create new market opportunities through environmental technologies, processes, or products)

*(Original) Post-hoc Analysis (3) DV = Environmental Product Development
*Historical: + +* +*
*Social:     + +* +
eststo: qui 	reg  En_En_PI_O01 CO2_ABOVE_his_l_8_dum_t_1 CO2_ABOVE_his_l_8_t_1   CO2_BELOW_his_l_8_t_1   l_other_nbwc_two_t_1  `ctr'   lambda_hat_new_409_Env_Prod r_D_original_his r_A_original_his r_B_original_his  i.gvkey i.year if reg_362 == 1, cluster(gvkey) robust

eststo: qui 	reg  En_En_PI_O01 D_soc_ver1_ps5_t_1 A_soc_ver1_ps5_t_1 B_soc_ver1_ps5_t_1  l_other_nbwc_two_t_1 `ctr'   lambda_hat_new_409_Env_Prod r_D_original_soc r_A_original_soc r_B_original_soc   i.gvkey i.year if reg_362 == 1, cluster(gvkey) robust

*duration
eststo: qui 	reg  En_En_PI_O01 CO2_ABOVE_his_l_8_dum_t_1 CO2_ABOVE_his_l_8_t_1   CO2_BELOW_his_l_8_t_1 ABOVE_dur_his_l_8_t_1 BELOW_dur_his_l_8_t_1   l_other_nbwc_two_t_1  `ctr'   lambda_hat_new_409_Env_Prod r_D_original_his r_A_original_his r_B_original_his  i.gvkey i.year if reg_362 == 1, cluster(gvkey) robust

eststo: qui 	reg  En_En_PI_O01 D_soc_ver1_ps5_t_1 A_soc_ver1_ps5_t_1 B_soc_ver1_ps5_t_1  A_dur_social_t_1 B_dur_social_t_1  l_other_nbwc_two_t_1 `ctr'   lambda_hat_new_409_Env_Prod r_D_original_soc r_A_original_soc r_B_original_soc   i.gvkey i.year if reg_362 == 1, cluster(gvkey) robust

*duration, ETS, Carbon Credit Purchase
eststo: qui 	reg  En_En_PI_O01 CO2_ABOVE_his_l_8_dum_t_1 CO2_ABOVE_his_l_8_t_1   CO2_BELOW_his_l_8_t_1 ABOVE_dur_his_l_8_t_1 BELOW_dur_his_l_8_t_1 C14_1_dum_En_En_ER_DP068_t_1  C14_2_dum_En_En_ER_DP097_dum_t_1   l_other_nbwc_two_t_1  `ctr'   lambda_hat_new_409_Env_Prod r_D_original_his r_A_original_his r_B_original_his  i.gvkey i.year if reg_362 == 1, cluster(gvkey) robust

eststo: qui 	reg  En_En_PI_O01 D_soc_ver1_ps5_t_1 A_soc_ver1_ps5_t_1 B_soc_ver1_ps5_t_1  A_dur_social_t_1 B_dur_social_t_1  C14_1_dum_En_En_ER_DP068_t_1  C14_2_dum_En_En_ER_DP097_dum_t_1 l_other_nbwc_two_t_1 `ctr'   lambda_hat_new_409_Env_Prod r_D_original_soc r_A_original_soc r_B_original_soc   i.gvkey i.year if reg_362 == 1, cluster(gvkey) robust


*duration, ETS, Carbon Credit Purchase, En_En_PI_DP024 (env R&D)
eststo: qui 	reg  En_En_PI_O01 CO2_ABOVE_his_l_8_dum_t_1 CO2_ABOVE_his_l_8_t_1   CO2_BELOW_his_l_8_t_1 ABOVE_dur_his_l_8_t_1 BELOW_dur_his_l_8_t_1 C14_1_dum_En_En_ER_DP068_t_1  C14_2_dum_En_En_ER_DP097_dum_t_1  En_En_PI_DP024_t_1  l_other_nbwc_two_t_1  `ctr'   lambda_hat_new_409_Env_Prod r_D_original_his r_A_original_his r_B_original_his  i.gvkey i.year if reg_362 == 1, cluster(gvkey) robust

eststo: qui 	reg  En_En_PI_O01 D_soc_ver1_ps5_t_1 A_soc_ver1_ps5_t_1 B_soc_ver1_ps5_t_1  A_dur_social_t_1 B_dur_social_t_1  C14_1_dum_En_En_ER_DP068_t_1  C14_2_dum_En_En_ER_DP097_dum_t_1 En_En_PI_DP024_t_1 l_other_nbwc_two_t_1 `ctr'   lambda_hat_new_409_Env_Prod r_D_original_soc r_A_original_soc r_B_original_soc   i.gvkey i.year if reg_362 == 1, cluster(gvkey) robust

*adding duration,  ETS, Carbon Credit purchase, En_En_PI_DP024 (env R&D / dummy variable), InnovationScore_t_1
eststo: qui 	reg  En_En_PI_O01 CO2_ABOVE_his_l_8_dum_t_1 CO2_ABOVE_his_l_8_t_1   CO2_BELOW_his_l_8_t_1 ABOVE_dur_his_l_8_t_1 BELOW_dur_his_l_8_t_1 C14_1_dum_En_En_ER_DP068_t_1  C14_2_dum_En_En_ER_DP097_dum_t_1  En_En_PI_DP024_t_1 InnovationScore_t_1  l_other_nbwc_two_t_1  `ctr'   lambda_hat_new_409_Env_Prod r_D_original_his r_A_original_his r_B_original_his  i.gvkey i.year if reg_362 == 1, cluster(gvkey) robust

eststo: qui 	reg  En_En_PI_O01 D_soc_ver1_ps5_t_1 A_soc_ver1_ps5_t_1 B_soc_ver1_ps5_t_1  A_dur_social_t_1 B_dur_social_t_1  C14_1_dum_En_En_ER_DP068_t_1  C14_2_dum_En_En_ER_DP097_dum_t_1 En_En_PI_DP024_t_1  InnovationScore_t_1 l_other_nbwc_two_t_1 `ctr'   lambda_hat_new_409_Env_Prod r_D_original_soc r_A_original_soc r_B_original_soc   i.gvkey i.year if reg_362 == 1, cluster(gvkey) robust


*duration: ABOVE_dur_his_l_8_t_1 BELOW_dur_his_l_8_t_1
*duration: A_dur_social_t_1 B_dur_social_t_1
*C14_1_dum_En_En_ER_DP068_t_1  C14_2_dum_En_En_ER_DP097_dum_t_1



eststo: qui reg  En_En_PI_O13 CO2_ABOVE_his_l_8_dum_t_1 CO2_ABOVE_his_l_8_t_1   CO2_BELOW_his_l_8_t_1   l_other_nbwc_two_t_1  `ctr'   lambda_hat_new_409_Env_Prod r_D_original_his r_A_original_his r_B_original_his  i.gvkey i.year if reg_362 == 1, cluster(gvkey) robust

eststo: qui reg  En_En_PI_O13 D_soc_ver1_ps5_t_1 A_soc_ver1_ps5_t_1 B_soc_ver1_ps5_t_1  l_other_nbwc_two_t_1 `ctr'   lambda_hat_new_409_Env_Prod r_D_original_soc r_A_original_soc r_B_original_soc   i.gvkey i.year if reg_362 == 1, cluster(gvkey) robust

*adding duration
eststo: qui reg  En_En_PI_O13 CO2_ABOVE_his_l_8_dum_t_1 CO2_ABOVE_his_l_8_t_1   CO2_BELOW_his_l_8_t_1  ABOVE_dur_his_l_8_t_1 BELOW_dur_his_l_8_t_1   l_other_nbwc_two_t_1  `ctr'   lambda_hat_new_409_Env_Prod r_D_original_his r_A_original_his r_B_original_his  i.gvkey i.year if reg_362 == 1, cluster(gvkey) robust

eststo: qui reg  En_En_PI_O13 D_soc_ver1_ps5_t_1 A_soc_ver1_ps5_t_1 B_soc_ver1_ps5_t_1 A_dur_social_t_1 B_dur_social_t_1 l_other_nbwc_two_t_1 `ctr'   lambda_hat_new_409_Env_Prod r_D_original_soc r_A_original_soc r_B_original_soc   i.gvkey i.year if reg_362 == 1, cluster(gvkey) robust


*adding duration,  ETS, Carbon Credit purchase
eststo: qui reg  En_En_PI_O13 CO2_ABOVE_his_l_8_dum_t_1 CO2_ABOVE_his_l_8_t_1   CO2_BELOW_his_l_8_t_1  ABOVE_dur_his_l_8_t_1 BELOW_dur_his_l_8_t_1 C14_1_dum_En_En_ER_DP068_t_1  C14_2_dum_En_En_ER_DP097_dum_t_1  l_other_nbwc_two_t_1  `ctr'   lambda_hat_new_409_Env_Prod r_D_original_his r_A_original_his r_B_original_his  i.gvkey i.year if reg_362 == 1, cluster(gvkey) robust

eststo: qui reg  En_En_PI_O13 D_soc_ver1_ps5_t_1 A_soc_ver1_ps5_t_1 B_soc_ver1_ps5_t_1 A_dur_social_t_1 B_dur_social_t_1 C14_1_dum_En_En_ER_DP068_t_1  C14_2_dum_En_En_ER_DP097_dum_t_1 l_other_nbwc_two_t_1 `ctr'   lambda_hat_new_409_Env_Prod r_D_original_soc r_A_original_soc r_B_original_soc   i.gvkey i.year if reg_362 == 1, cluster(gvkey) robust


*adding duration,  ETS, Carbon Credit purchase, En_En_PI_DP024 (env R&D / dummy variable)
eststo: qui reg  En_En_PI_O13 CO2_ABOVE_his_l_8_dum_t_1 CO2_ABOVE_his_l_8_t_1   CO2_BELOW_his_l_8_t_1  ABOVE_dur_his_l_8_t_1 BELOW_dur_his_l_8_t_1 C14_1_dum_En_En_ER_DP068_t_1  C14_2_dum_En_En_ER_DP097_dum_t_1   En_En_PI_DP024_t_1 l_other_nbwc_two_t_1  `ctr'   lambda_hat_new_409_Env_Prod r_D_original_his r_A_original_his r_B_original_his  i.gvkey i.year if reg_362 == 1, cluster(gvkey) robust

eststo: qui reg  En_En_PI_O13 D_soc_ver1_ps5_t_1 A_soc_ver1_ps5_t_1 B_soc_ver1_ps5_t_1 A_dur_social_t_1 B_dur_social_t_1 C14_1_dum_En_En_ER_DP068_t_1  C14_2_dum_En_En_ER_DP097_dum_t_1   En_En_PI_DP024_t_1 l_other_nbwc_two_t_1 `ctr'   lambda_hat_new_409_Env_Prod r_D_original_soc r_A_original_soc r_B_original_soc   i.gvkey i.year if reg_362 == 1, cluster(gvkey) robust


*adding duration,  ETS, Carbon Credit purchase, En_En_PI_DP024 (env R&D / dummy variable), InnovationScore_t_1
eststo: qui reg  En_En_PI_O13 CO2_ABOVE_his_l_8_dum_t_1 CO2_ABOVE_his_l_8_t_1   CO2_BELOW_his_l_8_t_1  ABOVE_dur_his_l_8_t_1 BELOW_dur_his_l_8_t_1 C14_1_dum_En_En_ER_DP068_t_1  C14_2_dum_En_En_ER_DP097_dum_t_1   En_En_PI_DP024_t_1 InnovationScore_t_1  l_other_nbwc_two_t_1  `ctr'   lambda_hat_new_409_Env_Prod r_D_original_his r_A_original_his r_B_original_his  i.gvkey i.year if reg_362 == 1, cluster(gvkey) robust
eststo: qui reg  En_En_PI_O13 D_soc_ver1_ps5_t_1 A_soc_ver1_ps5_t_1 B_soc_ver1_ps5_t_1 A_dur_social_t_1 B_dur_social_t_1 C14_1_dum_En_En_ER_DP068_t_1  C14_2_dum_En_En_ER_DP097_dum_t_1   En_En_PI_DP024_t_1 InnovationScore_t_1 l_other_nbwc_two_t_1 `ctr'   lambda_hat_new_409_Env_Prod r_D_original_soc r_A_original_soc r_B_original_soc   i.gvkey i.year if reg_362 == 1, cluster(gvkey) robust
}


*internal carbon pricing
{
clear
use "E:\ECSR_3rd revision\CDP_preprocessing\Internal price of carbon_3.3c\Internal Price of Carbon_CDP_FY 2010 to 2018_with gvkey.dta"

tab year if internal_carbon_v3 == 1

       year |      Freq.     Percent        Cum.
------------+-----------------------------------
       2010 |         38        7.22        7.22
       2011 |         39        7.41       14.64
       2012 |         39        7.41       22.05
       2013 |         39        7.41       29.47
       2014 |         65       12.36       41.83
       2015 |         69       13.12       54.94
       2016 |         77       14.64       69.58
       2017 |         79       15.02       84.60
       2018 |         81       15.40      100.00
------------+-----------------------------------
      Total |        526      100.00

tab GICSSector if internal_carbon_v3 == 1

               GICS Sector |      Freq.     Percent        Cum.
---------------------------+-----------------------------------
    Consumer Discretionary |         30        5.70        5.70
          Consumer Staples |         61       11.60       17.30
                    Energy |         55       10.46       27.76
                Financials |         41        7.79       35.55
               Health Care |         14        2.66       38.21
               Industrials |         70       13.31       51.52
    Information Technology |         52        9.89       61.41
                 Materials |         51        9.70       71.10
                       N/A |          6        1.14       72.24
               Real Estate |          1        0.19       72.43
Telecommunication Services |          2        0.38       72.81
                 Utilities |        143       27.19      100.00
---------------------------+-----------------------------------
                     Total |        526      100.00


}


esttab using "E:\ECSR_3rd revision\SIC 2-digit\FINAL TABLE.csv" , cells(b(fmt(3) star) se(par)) stats(r2 ll N, labels(R-squared Log-likelihood N)   ) starlevels(* 0.1 ** 0.05 *** 0.01) varwidth(15)  postfoot( `"{hline @width}"' `"  * p<0.10    ** p<0.05    *** p<0.01  "'   `"  Robust standard errors in parentheses"')

esttab using "E:\ECSR_3rd revision\SIC 2-digit\FINAL TABLE_IRR.csv" , cells(b(fmt(3) star) se(par)) stats(r2 ll N, labels(R-squared Log-likelihood N)   ) starlevels(* 0.1 ** 0.05 *** 0.01) varwidth(15)  postfoot( `"{hline @width}"' `"  * p<0.10    ** p<0.05    *** p<0.01  "'   `"  Robust standard errors in parentheses"') eform


**efforts to finding regulation-based IVs
{
	*Table A26. Robustness of Main analysis (regulation-based IVs)
*Table A26a. Instrumental validity tests (regulation-based IVs)
*Table A26b. Endogeneity and control function approach - first stage results (regulation-based IVs)
**** Should find again
{
	/// Dummy good
E: quar_CO2_SIC_t_1
W: l_avg_injuries_indirect_t_1 l_avg_injuries_indirect_2_t_1
T: num_facility_each_state_v22_1 lavg_num_chemical_state_v22_1 (가끔)
S: ratio_subsidiary_t_1 (가끔)

/// ABOVE good
E: quar_CO2_SIC_t_1
W: l_avg_injuries_direct_t_1 l_avg_injuries_direct_2_t_1 l_avg_damage_crops_2_t_1 (가끔)
T: lavg_total_release_state_v22_1 lavg_off_release_state_v22_1 lavg_num_chemical_state_v22_1 lavg_num_chemical_state_v22_1 (가끔)
L: num_incen_regu_t_1 (가끔) num_regulation_t_1 (가끔)  cum_num_incen_t_1 (아주 가끔)
S: l_num_subsidiary_country_t_1

/// BELOW good
E: quar_CO2_SIC_t_1
S: ratio_subsidiary_t_1


r_D_EWM_46 r_A_EWM_46 r_B_EWM_46 = quar_CO2_SIC_t_1  l_avg_deaths_indirect_t_1  zev_program_t_1
-- 1st stage : Dummy (+*** + -) ABOVE (+*** + +**) BELOW (-* + -)
-- 2nd stage (obs:385. Converged) : Dummy (+) ABOVE (-*) BELOW (-*)


ivreg2 nbwc_to_Y02E_two l_other_nbwc_two_t_1  regulation_t_1 astspec_t_1  lnslack_avai_t_1 firmsize5_t_1 lnRnDinten_t_1  ROA_t_1 (D_comb_s1h9_t_1 A_comb_s1h9_t_1 B_comb_s1h9_t_1 = quar_CO2_SIC_t_1 ratio_subsidiary_t_1 num_regulation_t_1) lambda_hat_3rd_rev3  i.year i.gvkey, robust cluster(gvkey) first  partial(i.gvkey)

*반드시 넣어야 할 것: zev_program_t_1


C14_1_dum_En_En_ER_DP068_t_1
*> ETS participation : empirically related

C14_2_dum_En_En_ER_DP097_dum_t_1
*> carbon credit : theoretically related

internal_carbon_v3_t_1
*> internal price of carbon

zev_program_t_1 
*pwcorr nbwc_to_Y02E_two zev_program	if	reg_382	==	1,	sig
*nb~E_two zev_pr~m
*nbwc_t~E_two    1.0000 
*zev_program    0.1188   1.0000 
*			   (0.0202)


xtprobit D_comb_s1h9_t_1   quar_CO2_SIC_t_1    num_incen_regu_t_1 zev_program_t_1  l_other_nbwc_two_t_1   `ctr'   i.year if reg_382 ==1, re i(gvkey)  vce(robust) difficult
predict hat_original, xb
gen r_D_R2 = normalden(hat_original)/normal(hat_original)
drop hat_original 

reg A_comb_s1h9_t_1    quar_CO2_SIC_t_1   num_incen_regu_t_1 zev_program_t_1  l_other_nbwc_two_t_1     `ctr'    i.year i.gvkey if reg_382 ==1, robust cluster(gvkey)
predict r_A_R2, residual

reg B_comb_s1h9_t_1    quar_CO2_SIC_t_1   num_incen_regu_t_1 zev_program_t_1   l_other_nbwc_two_t_1     `ctr'    i.year i.gvkey if reg_382 ==1, robust cluster(gvkey)
predict r_B_R2, residual


 nbreg nbwc_to_Y02E_two  `main_IDV'    l_other_nbwc_two_t_1  `ctr' lambda_hat_new_409 r_D_R2 r_A_R2  r_B_R2 i.gvkey i.year if !missing(CO2_ABOVE_his_l_8_t_1), robust cluster(gvkey)
} 

fix?: quar_CO2_SIC_t_1  zev_program_t_1 internal_carbon_v3_t_1


CAT_CA_t_1
**# Bookmark #21

quar_CO2_SIC_t_1  internal_carbon_v3_t_1  


xtprobit D_comb_s1h9_t_1    quar_CO2_SIC_t_1  internal_carbon_v3_t_1     lavg_num_chemical_state_v22_1  l_other_nbwc_two_t_1   `ctr'   i.year if reg_382 == 1, re i(gvkey)  vce(robust) difficult
predict hat_original, xb
gen r_D_R2 = normalden(hat_original)/normal(hat_original)
drop hat_original 

reg A_comb_s1h9_t_1    quar_CO2_SIC_t_1  internal_carbon_v3_t_1     lavg_num_chemical_state_v22_1   l_other_nbwc_two_t_1     `ctr'    i.year i.gvkey if reg_382 == 1, robust cluster(gvkey)
predict r_A_R2, residual

reg B_comb_s1h9_t_1    quar_CO2_SIC_t_1  internal_carbon_v3_t_1     lavg_num_chemical_state_v22_1   l_other_nbwc_two_t_1     `ctr'    i.year i.gvkey if reg_382 == 1, robust cluster(gvkey)
predict r_B_R2, residual
>>>> 2nd stage bad (+ + +)

****
En_En_RR_O11 (ln_En_En_RR_O11_t_1)
(Does the company use environmental criteria (ISO 14000, energy consumption, etc.) in the selection process of its suppliers or sourcing partners? AND Does the company report or show to be ready to end a partnership with a sourcing partner, if environmental criteria are not met? (Inactive as of FY2017 updates)

En_En_RR_DP001_5 (En_En_RR_DP001_5_t_1) // BELOW p<0.1
(Does the company have a policy to lessen the environmental impact of its supply chain? (inactive as of FY2014 updates)


En_En_RR_DP058 (En_En_RR_DP058_t_1) // BELOW p<0.1
Does the company use environmental or sustainable criteria in the selection process of its suppliers or sourcing partners?

En_En_RR_DP059 (En_En_RR_DP059_t_1)
Does the company report or show to be ready to end a partnership with a sourcing partner, in the case of severe environmental negligence and failure to comply with environmental management standards?


 ln_En_En_PI_O20_t_1
Has the company received product awards with respect to environmental responsibility? OR Does the company use product labels (e.g., FSC, Energy Star, MSC) indicating the environmental responsibility of its products? (Inactive as of FY2017 updates)

ln_En_En_RR_t_1 (below p<0.1)
(The resource reduction category measures a company's management commitment and effectiveness towards achieving an efficient use of natural resources in the production process. It reflects a company's capacity to reduce the use of materials, energy or water, and to find more eco-efficient solutions by improving supply chain management. (Inactive as of FY2017 updates))




En_En_RR_DP001_5



}

/////
*Figure 1. Summary of theoretical model
*Figure 2. Annual Co2 emissions of Top five emitters
*Figure 3. Visualization of the effect of emissions vs. aspiration on search renewable
qui nbreg nbwc_to_Y02E_two `main_IDV'      l_other_nbwc_two_t_1  `ctr' lambda_hat_new_409  `main_IV' `tail'
qui margins, at(A_comb_s1h9_t_1 = (0(.05)1 )) atmeans post
est store ABOVE

qui nbreg nbwc_to_Y02E_two `main_IDV'      l_other_nbwc_two_t_1  `ctr' lambda_hat_new_409  `main_IV' `tail'
qui margins , at(B_comb_s1h9_t_1 =(0(.05)1)) atmeans post
est store BELOW
coefplot  ABOVE BELOW, at noci recast(line)

*Figure A1. Sample Construction Process
*Figure A2. Number of patents by ICT firms and patent class
*Figure A3. Risk perception on regulations by non-energy-intensive and energy-intensiv industry
*Figure A4. Patenting trend of non-energy-intensive and energy-intensive industry
*Figure A5. Graphical analysis of poisson & negaitve binomial model fit for DV (Search Renewable)




