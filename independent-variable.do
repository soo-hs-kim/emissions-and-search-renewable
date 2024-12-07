///////////// Historical Aspiration
/// this code is based on the panel data (firm-year level)
{
* (Step 1) generate lagged variables
{
	sort id_firm year
	by id_firm: gen performance_t_1 = performance[_n-1]
	by id_firm: gen performance_t_2 = performance[_n-2] 
}

* (Step 2) generate historical aspiration variables
foreach x of numlist 1/9 {
	
	local z = 0.1 * `x'
	local y = 1 - `z'
	gen step_his`x' = 0

	replace performance     = 0 if missing(performance)
	replace performance_t_1 = 0 if missing(performance_t_1)
	replace performance_t_2 = 0 if missing(performance_t_2)

	by id_firm: replace step_his`x' = performance if performance_t_1 * performance == 0 & performance != 0
	
	gen his`x' = step_his`x'[_n-1]
	gen for_his`x' = 0
	by id_firm: replace for_his`x' = 1 if ( performance != 0 | performance_t_1 != 0 | performance_t_2 != 0 ) & !missing(performance_t_2)
	by id_firm: replace his`x' = `z'* his`x'[_n-1] + `y'*performance_t_1 if for_his`x' == 1 & (his`x' == 0 & (his`x'[_n+1] == 0 | missing(his`x'[_n+1]))) & !missing(performance)
	
	drop step_his`x' for_his`x'
	replace his`x' = . if his`x' == 0
	replace performance = . if performance == 0
	replace performance_t_1 = . if performance_t_1 == 0
	replace performance_t_2 = . if performance_t_2 == 0

	gen dif_performance_`x' = performance - his`x' if !missing(performance)
	
	gen PERF_ABOVE_his`x'     = dif_performance_`x' if dif_performance_`x' > 0  & !missing(dif_performance_`x')
	replace PERF_ABOVE_his`x' = 0                   if dif_performance_`x' < 0  & !missing(dif_performance_`x')

	gen PERF_BELOW_his`x'     = abs(dif_performance_`x') if dif_performance_`x' < 0 & !missing(dif_performance_`x')
	replace PERF_BELOW_his`x' = 0                        if dif_performance_`x' > 0 & !missing(dif_performance_`x')
	replace PERF_BELOW_his`x' = .                        if missing(PERF_ABOVE_his`x')

	gen PERF_ABOVE_his`x'_d     = 1 if PERF_ABOVE_his`x' != 0 & !missing(PERF_ABOVE_his`x')
	replace PERF_ABOVE_his`x'_d = 0 if PERF_ABOVE_his`x' == 0 & !missing(PERF_ABOVE_his`x')
}

* (Step 3) label variables
foreach x of numlist 1/9{
	local z = 0.1 * `x'
	local y = 1 - `z'
	label variable his`x' "`z'*his.asp. + `y'*performance"
}
}


///////////// Social Aspiration
/// this code is based on the panel data (firm-year level)
/// yr_cnt_performance: number of firms who have performance information within each peer group
{
	gen denom_performance = (yr_cnt_performance - 1)                    if !missing(performance)
			
	bysort year peer_group: egen total_performance = total(performance) if !missing(performance)
	gen numer_performance = (total_performance - performance)           if !missing(performance)
			
	gen soc_performance = (numer_performance/denom_performance) if !missing(performance)
	gen dif_performance = (performance - soc_performance)       if !missing(performance)
		
	gen PERF_ABOVE_soc     = dif_performance if dif_performance > 0 & !missing(performance)
	replace PERF_ABOVE_soc = 0               if dif_performance < 0 & !missing(performance)
			
	gen PERF_BELOW_soc     = abs(dif_performance) if dif_performance < 0 & !missing(performance)
	replace PERF_BELOW_soc = 0                    if dif_performance > 0 & !missing(performance)	

	gen PERF_ABOVE_soc_d       = 1 if PERF_ABOVE_soc != 0 & !missing(PERF_ABOVE_soc)
	replace PERF_ABOVE_soc_d   = 0 if PERF_ABOVE_soc == 0 & !missing(PERF_ABOVE_soc)
}


///////////// Combined Aspiration
/// this code is based on the panel data (firm-year level)
/// his_8: historical aspiration (weight 0.8 for historical aspiration_t_1)
/// soc_performance: social aspiration
{
* (Step 1) Construct combined aspiration by blending social and historical aspiration
{
	gen soc_1_his_9 = 0.1*soc_performance + 0.9*his_8
	gen soc_2_his_8 = 0.2*soc_performance + 0.8*his_8
	gen soc_3_his_7 = 0.3*soc_performance + 0.7*his_8
	gen soc_4_his_6 = 0.4*soc_performance + 0.6*his_8
	gen soc_5_his_5 = 0.5*soc_performance + 0.5*his_8
	gen soc_6_his_4 = 0.6*soc_performance + 0.4*his_8
	gen soc_7_his_3 = 0.7*soc_performance + 0.3*his_8
	gen soc_8_his_2 = 0.8*soc_performance + 0.2*his_8
	gen soc_9_his_1 = 0.9*soc_performance + 0.1*his_8
}

* (Step 2) Construct variables
foreach x of numlist 1/9 {

	local y = 10 - `x'
	gen PERF_ABOVE_soc_`x'_his_`y'     = performance - soc_`x'_his_`y'      if (performance - soc_`x'_his_`y') > 0 & !missing(performance)
	replace PERF_ABOVE_soc_`x'_his_`y' = 0                                  if (performance - soc_`x'_his_`y') < 0 & !missing(performance)
	
	gen PERF_BELOW_soc_`x'_his_`y'     = abs(performance - soc_`x'_his_`y') if (performance - soc_`x'_his_`y') < 0 & !missing(performance)
	replace PERF_BELOW_soc_`x'_his_`y' = 0                                  if (performance - soc_`x'_his_`y') > 0 & !missing(performance)
	replace PERF_BELOW_soc_`x'_his_`y' = .                                  if missing(PERF_ABOVE_soc_`x'_his_`y')
	
	gen PERF_ABOVE_soc_`x'_his_`y'd     = 1                                 if PERF_ABOVE_soc_`x'_his_`y' != 0 & !missing(PERF_ABOVE_soc_`x'_his_`y')
	replace PERF_ABOVE_soc_`x'_his_`y'd = 0                                 if PERF_ABOVE_soc_`x'_his_`y' == 0 & !missing(PERF_ABOVE_soc_`x'_his_`y')
	
}
}


///////////// Social Aspiration (alternative way of defining peer firms)
*Reference: Kuusela P, Keil T, Maula M. 2017. Driven by aspirations, but in what direction? Performance shortfalls, slack resources, and resource‐consuming vs. resource‐freeing organizational change. Strategic Management Journal. 38(5): 1101-1120.
*This advanced method utilizes a matching approach to define peer firms that are most relevant to the focal firm in terms of revenue and total assets within each industry-year group (based on two-digit SIC codes). 
*As a first step of this advanced method, calculate the Mahalanobis distance between the focal firm and other firms within the same industry-year in terms of revenue and total assets. Then, identify the closest firms based on the Mahalanobis distance. After defining peer firms, calculate performance of peer firms and regard it as a social aspiration.
{
* (Step 1) From the main data, keep variables of interest
* at: total assets
* revt: revenue
* sic: industry group (you can use other industry group classifications such as NAICS)
{
	clear
	use "~\main_data.dta"
	keep id_firm year performance at revt sic 
	drop if missing(at) & missing(revt)
	save "~\for_Kuusela.dta"
}

* (Step 2) Construct the Mahalobian distance
{
clear 
use "~\for_Kuusela.dta"
program Kuuesla_revt_at
	mahascore revt at, gen(distance)  compute_invcovarmat refmeans
end
runby Kuuesla_revt_at, by(sic  year)
save "~\for_Kuusela.dta" replace
}

* (Step 3) Construct "anymatch" Program
{
	program Kuusela_peersize_3
		anymatch, id(tag) metric(distance) near(3) dist(maha_sic)
	end

	program Kuusela_peersize_4
		anymatch, id(tag) metric(distance) near(4) dist(maha_sic)
	end

	program Kuusela_peersize_5
		anymatch, id(tag) metric(distance) near(5) dist(maha_sic)
	end

	program Kuusela_peersize_6
		anymatch, id(tag) metric(distance) near(6) dist(maha_sic)
	end

	program Kuusela_peersize_7
		anymatch, id(tag) metric(distance) near(7) dist(maha_sic)
	end
}

* (Step 4) Construct peer firms 
foreach num of numlist 3 4 5 6 7 {
	clear 
	use  "~\for_Kuusela.dta"

	sort id_firm year
	gen tag = _n
	drop if missing(performance)
	
	runby Kuusela_peersize_`num', by(sic year)
	keep id_firm year performance tag - _tag`num'
	reshape long _tag, i(tag)
	drop _j
	save  "~\for_Kuusela_ps`num'.dta" 
}

* (Step 5) Construct Kuusela-based social aspiration measure
foreach num of numlist 3 4 5 6 7 {
	display "This is the start of loop of Kuusela of peersize `num'"
	clear
	use "~\for_Kuusela_ps`num'.dta" 
	drop _tag
	duplicates drop
	
	rename tag _tag
	rename id_firm _id_firm
	rename performance peer_performance
	
	merge 1:m _tag year using "~\for_Kuusela_ps`num'.dta" 
	order tag id_firm year performance _tag _id_firm peer_performance
	sort tag id_firm year _tag
	drop _merge
	drop if missing(id_firm)
	drop if missing(_id_firm)
	drop tag _tag _id_firm

	sort id_firm year
	by id_firm year: gen cnt = _N
	by id_firm year: egen total_ps`num' = total(peer_performance)
	
	gen avg_ps`num' = total_ps`num' / cnt
	label variable avg_ps`num' "Kuusela-based social asp. peersize`num'"
		
	gen diff_ps`num' = performance - avg_ps`num'
	drop peer_performance 
	duplicates drop
	duplicates report id_firm year
	save "~\for_Kuusela_ps`num'_firm lv.dta"

	display "This is the end of loop of Kuusela of peersize `num'"
}

* (Step 6) Merge the data from Step 5 with the main data and contruct variables using diff_ps`num' variables (`num': 3,4,5,6,7)
}

