* Encoding: UTF-8.
**decimal separator.
SET LOCALE = "en_US.windows-1252".
SHOW LOCALE.


dataset close all.

*specify folder here, e.g.

cd 'C:\yourfolder\data'.

get file='ETT_ESM_Study1.sav'.

**sample data.
frequ oneline.
value labels sex 0 'male' 1 'female'.

filter by oneline.
frequ sex.

descriptives age.

frequ country.

**number of signals.
descriptives nu_sig pct_tot.
mean pct_tot/cells=median.

frequ race.

frequ education.

frequ student.

frequ occu.

***analysis.
***1) Basic distributions. Basic Distribution of Thoughts in Time .

*Figure 1.
temporary.
select if (timespan lt 0).
frequ timespan.

temporary.
select if (timespan gt 0).
frequ timespan.


*Table 1. Frequency of When only one time zone was indicated, the present was by far the most popular (53.1%), although thinking purely about the future was also somewhat common (18.8%; see Table 1)..
temporary.
select if (onefactor ne 8).
frequ onefactor.

temporary.
select if (onefactor le 3).
frequ onefactor.

execute.

filter off.
frequ past present future notime notimeonly.
frequ onefactor.


*Thinking about the future became less common as the day wore on, Blog = -.0009, p < .001 (see Figure 2).

**compute a simple time variable starting at 9am (0).
compute time_c=(hour-9)*60+minutes.
frequ time_c.
graph/histo=time_c.

*controlling for DAY as effects coded dummy.
if (DAY=1) day_e1=1.
if (DAY=2) day_e1=0.
if (DAY=3) day_e1= -1.

if (DAY=1) day_e2=0.
if (DAY=2) day_e2=1.
if (DAY=3) day_e2= -1.

frequ day_e1 day_e2.

filter off.
sort cases by subject day sig.

**note final analysis done as logistic regression analysis.
save outfile="./hlm/time_course.sav"
/keep=subject day sig time_c past_d present_d future_d notime_d day_e1 day_e2 depletion.


*Thoughts in and out of Time. 
*Most responses indicated that participants’ thoughts were linked to past, present, and/or future, but a substantial minority (24.4%) indicated no link to any of those. 
*In this section we report the differences between thoughts that did vs. did not have a temporal aspect. 
***2) Table 2. Multilevel analyses comparing occasions with or without time aspect. .

output close all.

MIXED meaning by timeaspect /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT timeaspect /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED control by timeaspect /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT timeaspect /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED arousal by timeaspect /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT timeaspect /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED valence by timeaspect /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT timeaspect /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED angry by timeaspect /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT timeaspect /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED anxious by timeaspect /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT timeaspect /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED stress by timeaspect /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT timeaspect /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED depletion by timeaspect /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT timeaspect /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED involved by timeaspect /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT timeaspect /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED wanting by timeaspect /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT timeaspect /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED selfother by timeaspect /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT timeaspect /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED meaning by timeaspect /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT timeaspect /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED contentpn by timeaspect /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT timeaspect /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED satisfaction by timeaspect /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT timeaspect /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED disapp by timeaspect /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT timeaspect /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED surprise by timeaspect /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT timeaspect /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED alone by timeaspect /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT timeaspect /RANDOM = INTERCEPT | SUBJECT(subject).


***Alone or Together?.
*Alone or Together?
**alone versus others and timezone.The seven time-aspect categories were statistically associated with being in the presence of others, χ²(7) = 209.7, p < .001, Cramer’s V = .18.
if (alone=1) alone_d = 1.
if (alone ge 2) alone_d = 0.
value labels alone_d 0 'with others' 1 'alone'. 
frequ alone_d.

crosstabs /tables=onefactor by alone_d /cells=count rows expected /statistics=all/barchart.
crosstabs /tables=onefactor by alone_d /cells=rows /statistics=all.

*Within-Time Zone Analyses
***Thought content by time zone.
***the past: what describes thoughts?.
temporary.
select if (time_1=1).
frequ typepast_1 typepast_2 typepast_3 typepast_4 typepast_5 typepast_6 typepast_7 typepast_8 typepast_9 typepast_10 typepast_11 typepast_12 typepast_13 typepast_15 typepast_14 .

**the present.
temporary.
select if (time_2=1).
frequ typepresen_1 typepresen_2 typepresen_3 typepresen_4 typepresen_5 typepresen_6 typepresen_7 typepresen_9 typepresen_10
typepresen_11 typepresen_12 typepresen_13 typepresen_14 typepresen_15 typepresen_16 typepresen_18 typepresen_19 typepresen_17 .

***the future.
temporary.
select if (time_3=1).
frequ typefuture_1 typefuture_2 typefuture_3 typefuture_4 typefuture_5 typefuture_6 typefuture_7 typefuture_8 typefuture_9 typefuture_10 typefuture_11
typefuture_12 typefuture_13 typefuture_14 typefuture_15.

*planning.
*The category of planning dominated thoughts about the future. Three quarters (74.1%) of thoughts about the future included planning (see Figure 3, lower panel). 
*Given the particular importance of planning, we ran a series of analyses to compare planning against other responses that involved the future but did not include planning (see Table 3).
***planning versus no planning.

if (time_3=1 and typefuture_1=1) planning=1.
if (time_3=1 and sysmis(typefuture_1)=1) planning=0.
value lables planning 0 'no planning' 1 'planning'.
frequ planning.

**Table 3. Multilevel analyses comparing instances of planning (n = 1,446) versus no planning (n = 505) in future thought. 

output close all.
MIXED meaning by planning /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT planning /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED control by planning /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT planning /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED arousal by planning /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT planning /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED valence by planning /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT planning /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED angry by planning /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT planning /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED anxious by planning /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT planning /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED stress by planning /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT planning /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED depletion by planning /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT planning /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED involved by planning /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT planning /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED wanting by planning /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT planning /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED selfother by planning /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT planning /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED meaning by planning /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT planning /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED contentpn by planning /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT planning /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED satisfaction by planning /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT planning /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED disapp by planning /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT planning /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED surprise by planning /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT planning /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED alone by planning /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT planning /RANDOM = INTERCEPT | SUBJECT(subject).



***Death is a fixture of the future, and some have argued that thoughts about one’s future death are the foundation of much if not all human striving (e.g., Becker, 1973). 
*Participants were given the option of indicating that death was among their thoughts, but they checked it on only 37 out of 4,020 occasions, thus less than 1%. 

*death thoughts.
filter off.
frequ checklist1_33.

alter type random (F2.0).

*Answer If  random Is Less Than or Equal to  6
*checklist1 Check all that apply to the thoughts you were having just before the signal came. adjusting this to the proportion of events on which checklist was shown.

if (random le 6) checklistshown=1.
if (checklistshown=1 and checklist1_33 = 1) deaththoughts = 1.
if (checklistshown=1 and sysmis(checklist1_33) eq 1 ) deaththoughts=0.
frequ deaththoughts.

*about past.
temporary.
select if (deaththoughts=1).
frequ onefactor.

temporary.
select if (deaththoughts=1).
frequ past present future.

MIXED timespan by deaththoughts /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT deaththoughts /RANDOM = INTERCEPT | SUBJECT(subject).

*anxiety.
MIXED anxious by deaththoughts /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT deaththoughts /RANDOM = INTERCEPT | SUBJECT(subject).

*Analyses for Supplementary Table 2.
output close all.
MIXED meaning by deaththoughts /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT deaththoughts /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED control by deaththoughts /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT deaththoughts /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED arousal by deaththoughts /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT deaththoughts /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED valence by deaththoughts /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT deaththoughts /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED angry by deaththoughts /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT deaththoughts /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED anxious by deaththoughts /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT deaththoughts /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED stress by deaththoughts /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT deaththoughts /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED depletion by deaththoughts /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT deaththoughts /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED involved by deaththoughts /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT deaththoughts /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED wanting by deaththoughts /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT deaththoughts /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED selfother by deaththoughts /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT deaththoughts /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED meaning by deaththoughts /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT deaththoughts /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED contentpn by deaththoughts /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT deaththoughts /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED satisfaction by deaththoughts /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT deaththoughts /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED disapp by deaththoughts /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT deaththoughts /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED surprise by deaththoughts /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT deaththoughts /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED alone by deaththoughts /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT deaththoughts /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED contentpn by deaththoughts /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT deaththoughts /RANDOM = INTERCEPT | SUBJECT(subject).


*Subjective Experience of Past, Present, and Future.

*Figure 4.
***only 3 levels (past, present, future) based on timespan variable.
***timefactor analyses.

delete variables timefactor.
execute.
delete variables  timefactor_r.
execute.

frequ timespan.

*excluding cases were past and future were mentioned simultaneously. mix of past and present is treated as past, and likewise for future and present.
if (onefactor=1 or onefactor=4) timefactor=1.
if (onefactor=2) timefactor=2.
if (onefactor=3 or onefactor=6) timefactor=3.


frequ timefactor.

*present as base.
recode timefactor (1=1) (2=3) (3=2) into timefactor_r.

frequ timefactor_r.

MIXED contentpn by timefactor
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timefactor
/RANDOM = INTERCEPT | SUBJECT(subject).

MIXED contentpn by timefactor_r
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timefactor_r
/RANDOM = INTERCEPT | SUBJECT(subject).

MIXED meaning by timefactor
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timefactor
/RANDOM = INTERCEPT | SUBJECT(subject).

MIXED meaning by timefactor_r
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timefactor_r
/RANDOM = INTERCEPT | SUBJECT(subject).

MIXED control by timefactor
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timefactor
/RANDOM = INTERCEPT | SUBJECT(subject).

MIXED control by timefactor_r
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timefactor_r
/RANDOM = INTERCEPT | SUBJECT(subject).

MIXED selfother by timefactor
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timefactor
/RANDOM = INTERCEPT | SUBJECT(subject).

MIXED selfother by timefactor_r
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timefactor_r
/RANDOM = INTERCEPT | SUBJECT(subject).

MIXED anxious by timefactor
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timefactor
/RANDOM = INTERCEPT | SUBJECT(subject).

MIXED anxious by timefactor_r
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timefactor_r
/RANDOM = INTERCEPT | SUBJECT(subject).

MIXED depletion by timefactor
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timefactor
/RANDOM = INTERCEPT | SUBJECT(subject).

MIXED depletion by timefactor_r
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timefactor_r
/RANDOM = INTERCEPT | SUBJECT(subject).

MIXED involved by timefactor
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timefactor
/RANDOM = INTERCEPT | SUBJECT(subject).

MIXED involved by timefactor_r
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timefactor_r
/RANDOM = INTERCEPT | SUBJECT(subject).

MIXED valence by timefactor
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timefactor
/RANDOM = INTERCEPT | SUBJECT(subject).

MIXED valence by timefactor_r
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timefactor_r
/RANDOM = INTERCEPT | SUBJECT(subject).

MIXED angry by timefactor
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timefactor
/RANDOM = INTERCEPT | SUBJECT(subject).

MIXED angry by timefactor_r
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timefactor_r
/RANDOM = INTERCEPT | SUBJECT(subject).

MIXED disapp by timefactor
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timefactor
/RANDOM = INTERCEPT | SUBJECT(subject).

MIXED disapp by timefactor_r
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timefactor_r
/RANDOM = INTERCEPT | SUBJECT(subject).

MIXED surprise by timefactor
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timefactor
/RANDOM = INTERCEPT | SUBJECT(subject).

MIXED surprise by timefactor_r
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timefactor_r
/RANDOM = INTERCEPT | SUBJECT(subject).

MIXED wanting by timefactor
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timefactor
/RANDOM = INTERCEPT | SUBJECT(subject).

MIXED wanting by timefactor_r
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timefactor_r
/RANDOM = INTERCEPT | SUBJECT(subject).

MIXED arousal by timefactor
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timefactor
/RANDOM = INTERCEPT | SUBJECT(subject).

MIXED arousal by timefactor_r
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timefactor_r
/RANDOM = INTERCEPT | SUBJECT(subject).

MIXED stress by timefactor
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timefactor
/RANDOM = INTERCEPT | SUBJECT(subject).

MIXED stress by timefactor_r
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timefactor_r
/RANDOM = INTERCEPT | SUBJECT(subject).

**Supplementary Figure 2 and supplementary Table 3. Multilevel analyses of linear and quadratic trends of time frame on main dependent measures. .
***linear and quadratic time trend analyses.
**compute quadratic effects.
filter off.
compute timespan_q=timespan*timespan.

temporary.
select if ((onefactor le 4 or onefactor=6) and timespan lt 9).
MIXED valence with timespan timespan_q
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timespan timespan_q
/RANDOM = INTERCEPT | SUBJECT(subject).

temporary.
select if ((onefactor le 4 or onefactor=6) and timespan lt 9).
MIXED contentpn with timespan timespan_q
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timespan timespan_q
/RANDOM = INTERCEPT | SUBJECT(subject).

temporary.
select if ((onefactor le 4 or onefactor=6) and timespan lt 9).
MIXED selfother with timespan timespan_q
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timespan timespan_q
/RANDOM = INTERCEPT | SUBJECT(subject).

temporary.
select if ((onefactor le 4 or onefactor=6) and timespan lt 9).
MIXED meaning with timespan timespan_q
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timespan timespan_q
/RANDOM = INTERCEPT | SUBJECT(subject).

temporary.
select if ((onefactor le 4 or onefactor=6) and timespan lt 9).
MIXED control with timespan timespan_q
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timespan timespan_q
/RANDOM = INTERCEPT | SUBJECT(subject).

temporary.
select if ((onefactor le 4 or onefactor=6) and timespan lt 9).
MIXED involved with timespan timespan_q
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timespan timespan_q
/RANDOM = INTERCEPT | SUBJECT(subject).


temporary.
select if ((onefactor le 4 or onefactor=6) and timespan lt 9).
MIXED angry with timespan timespan_q
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timespan timespan_q
/RANDOM = INTERCEPT | SUBJECT(subject).


temporary.
select if ((onefactor le 4 or onefactor=6) and timespan lt 9).
MIXED anxious with timespan timespan_q
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timespan timespan_q
/RANDOM = INTERCEPT | SUBJECT(subject).

temporary.
select if ((onefactor le 4 or onefactor=6) and timespan lt 9).
MIXED satisfaction with timespan timespan_q
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timespan timespan_q
/RANDOM = INTERCEPT | SUBJECT(subject).

temporary.
select if ((onefactor le 4 or onefactor=6) and timespan lt 9).
MIXED arousal with timespan timespan_q
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timespan timespan_q
/RANDOM = INTERCEPT | SUBJECT(subject).

temporary.
select if ((onefactor le 4 or onefactor=6) and timespan lt 9).
MIXED stress with timespan timespan_q
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timespan timespan_q
/RANDOM = INTERCEPT | SUBJECT(subject).

temporary.
select if ((onefactor le 4 or onefactor=6) and timespan lt 9).
MIXED depletion with timespan timespan_q
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timespan timespan_q
/RANDOM = INTERCEPT | SUBJECT(subject).

temporary.
select if ((onefactor le 4 or onefactor=6) and timespan lt 9).
MIXED wanting with timespan timespan_q
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timespan timespan_q
/RANDOM = INTERCEPT | SUBJECT(subject).

temporary.
select if ((onefactor le 4 or onefactor=6) and timespan lt 9).
MIXED surprise with timespan timespan_q
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timespan timespan_q
/RANDOM = INTERCEPT | SUBJECT(subject).

temporary.
select if ((onefactor le 4 or onefactor=6) and timespan lt 9).
MIXED disapp with timespan timespan_q
/PRINT = SOLUTION TESTCOV corb
/METHOD = ML
/FIXED = INTERCEPT timespan timespan_q
/RANDOM = INTERCEPT | SUBJECT(subject).



*Subjective Experience of  Thoughts that Link Different Times.
*Table 4. Multilevel analyses comparing instances with a single temporal focus (past, present, future only) versus those with a combined focus.
*comp of signle versus multiple times; temporal integration.
 *The main analyses simply compared the three pure time zone responses against all possible combinations. (No-time thoughts were excluded from these analyses.) 
*temp integration.
if (onefactor le 3) temp_focus=0.
if (onefactor gt 3 and onefactor lt 8) temp_focus=1.
value labels temp_focus 0 'single focus' 1 'combined focus'.
frequ temp_focus.
frequ onefactor.

output close all.

MIXED meaning by temp_focus /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_focus /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED control by temp_focus /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_focus /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED arousal by temp_focus /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_focus /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED valence by temp_focus /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_focus /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED angry by temp_focus /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_focus /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED anxious by temp_focus /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_focus /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED stress by temp_focus /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_focus /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED depletion by temp_focus /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_focus /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED involved by temp_focus /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_focus /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED wanting by temp_focus /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_focus /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED selfother by temp_focus /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_focus /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED meaning by temp_focus /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_focus /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED contentpn by temp_focus /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_focus /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED satisfaction by temp_focus /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_focus /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED disapp by temp_focus /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_focus /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED surprise by temp_focus /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_focus /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED alone by temp_focus /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_focus /RANDOM = INTERCEPT | SUBJECT(subject).

*A secondary analysis strategy calculated an index of temporal integration based on how many different time zones were invoked for each thought, ranging from zero (no time zone) to three (past, present, and future). 
*The latter analysis strategy yielded largely comparable conclusions (see Supplementary Table S4).
*Supplementary Table 3. Multilevel regression of main outcomes on a continuous  temporal integration index ranging from 0 (no time zone) to three (past, present, and future combined).

*temp integratio nindex.
if (onefactor eq 8) temp_integration=0.
if (onefactor le 3) temp_integration=1.
if (onefactor = 4 or onefactor =5 or onefactor=6) temp_integration=2.
if (onefactor = 7) temp_integration=3.
frequ temp_integration.

MIXED meaning with temp_integration /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_integration /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED control with temp_integration /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_integration /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED arousal with temp_integration /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_integration /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED valence with temp_integration /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_integration /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED angry with temp_integration /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_integration /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED anxious with temp_integration /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_integration /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED stress with temp_integration /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_integration /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED depletion with temp_integration /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_integration /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED involved with temp_integration /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_integration /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED wanting with temp_integration /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_integration /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED selfother with temp_integration /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_integration /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED meaning with temp_integration /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_integration /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED contentpn with temp_integration /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_integration /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED satisfaction with temp_integration /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_integration /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED disapp with temp_integration /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_integration /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED surprise with temp_integration /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_integration /RANDOM = INTERCEPT | SUBJECT(subject).
MIXED alone with temp_integration /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_integration /RANDOM = INTERCEPT | SUBJECT(subject).


MIXED meaning by temp_integration /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_integration /RANDOM = INTERCEPT | SUBJECT(subject).

recode temp_integration (0=0) (1=3) (2=2) (3=1) into temp_integration_r1.
MIXED meaning by temp_integration_r1 /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_integration_r1 /RANDOM = INTERCEPT | SUBJECT(subject).

recode temp_integration (0=0) (2=3) (1=1) (3=2) into temp_integration_r2.
MIXED meaning by temp_integration_r2 /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_integration_r2 /RANDOM = INTERCEPT | SUBJECT(subject).

recode temp_integration (0=3) (2=2) (1=1) (3=0) into temp_integration_r3.
MIXED meaning by temp_integration_r3 /PRINT = SOLUTION /METHOD = ML /FIXED = INTERCEPT temp_integration_r3 /RANDOM = INTERCEPT | SUBJECT(subject).



***Individual Difference Predictors of Time Focus.

*Supplementary Table S1.

filter by oneline.
descriptives variables  age sex religious E A C N O nfc tsc se narc rumination depression lot ls.

*Table S1. Intercorrelation of dispositional measures. 
corr sex age religious E A C N O nfc tsc se narc rumination depression lot ls.


**future, present, past frequencies.
*Table 5. Summary of poisson regression analyses estimating the association among past, present, and future thought frequency and dispositional measures. .

***poisson regressions.
filter by oneline.


filter by oneline.
frequ oneline.

*excel sheet: "fpast_poisson pers".
output close all.
GENLIN fpast WITH  age  /MODEL  age  DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpast WITH  religious_c  /MODEL  religious_c   DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpast WITH  sex  /MODEL  sex   DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpast WITH  tsc_c  /MODEL  tsc_c  DISTRIBUTION=POISSON   /PRINT SOLUTION.
GENLIN fpast WITH  se_c  /MODEL  se_c  DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpast WITH  ls_c  /MODEL  ls_c  DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpast WITH  nfc_c  /MODEL  nfc_c  DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpast WITH  rumination_c  /MODEL  rumination_c  DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpast WITH  depression_c  /MODEL  depression_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpast WITH  E_c  /MODEL  E_c  DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpast WITH  A_c  /MODEL  A_c  DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpast WITH  C_c  /MODEL  C_c  DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpast WITH  N_c  /MODEL  N_c  DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpast WITH  O_c  /MODEL  O_c  DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpast WITH  LOT_c  /MODEL  LOT_c  DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpast WITH  narc_c  /MODEL  narc_c  DISTRIBUTION=POISSON /PRINT SOLUTION.

*excel sheet: "fpres_poisson pers".
output close all.
filter by oneline.
GENLIN fpresent WITH  age  /MODEL  age  DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpresent WITH  religious_c  /MODEL  religious_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpresent WITH  sex  /MODEL  sex  DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpresent WITH  tsc_c  /MODEL  tsc_c  DISTRIBUTION=POISSON   /PRINT SOLUTION.
GENLIN fpresent WITH  se_c  /MODEL  se_c  DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpresent WITH  ls_c  /MODEL  ls_c  DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpresent WITH  nfc_c  /MODEL  nfc_c  DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpresent WITH  rumination_c  /MODEL  rumination_c  DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpresent WITH  depression_c  /MODEL  depression_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpresent WITH  E_c  /MODEL  E_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpresent WITH  A_c  /MODEL  A_c  DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpresent WITH  C_c  /MODEL  C_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpresent WITH  N_c  /MODEL  N_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpresent WITH  O_c  /MODEL  O_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpresent WITH  LOT_c  /MODEL  LOT_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpresent WITH  narc_c  /MODEL  narc_c DISTRIBUTION=POISSON /PRINT SOLUTION.

*excel sheet: "ffuture_poisson pers".
output close all.
filter by oneline.
GENLIN ffuture WITH  age  /MODEL  age DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN ffuture WITH  religious_c  /MODEL  religious_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN ffuture WITH  sex  /MODEL  sex DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN ffuture WITH  tsc_c  /MODEL  tsc_c DISTRIBUTION=POISSON   /PRINT SOLUTION.
GENLIN ffuture WITH  se_c  /MODEL  se_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN ffuture WITH  ls_c  /MODEL  ls_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN ffuture WITH  nfc_c  /MODEL  nfc_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN ffuture WITH  rumination_c  /MODEL  rumination_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN ffuture WITH  depression_c  /MODEL  depression_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN ffuture WITH  E_c  /MODEL  E_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN ffuture WITH  A_c  /MODEL  A_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN ffuture WITH  C_c  /MODEL  C_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN ffuture WITH  N_c  /MODEL  N_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN ffuture WITH  O_c  /MODEL  O_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN ffuture WITH  LOT_c  /MODEL  LOT_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN ffuture WITH  narc_c  /MODEL  narc_c DISTRIBUTION=POISSON /PRINT SOLUTION.


*more distant future or past.
dataset close all.

get file='ETT_ESM_Study1.sav'.

delete variables fpast fpresent ffuture fnotime fnotimeonly.
execute.

frequ timespan.
**********************************************************************************************************************
*for more distant future or past.
select if (timespan ge 4 or timespan le -4).
execute.
********************************************************************************************

filter off.
frequ timespan.

aggregate outfile=* Mode =addvariables overwrite=yes
/break=subject
/fpast=sum(past)
/fpresent=sum(present)
/ffuture=sum(future)
/fnotime=sum(notime)
/n_resp=sum(index)
/fnotimeonly=sum(notimeonly).
execute.

*rerun analyses for excel sheet: "fdistant past_poisson pers".
output close all.
filter by oneline.
GENLIN fpast WITH  age  /MODEL  age  DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpast WITH  religious_c  /MODEL  religious_c   DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpast WITH  sex  /MODEL  sex   DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpast WITH  tsc_c  /MODEL  tsc_c  DISTRIBUTION=POISSON   /PRINT SOLUTION.
GENLIN fpast WITH  se_c  /MODEL  se_c  DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpast WITH  ls_c  /MODEL  ls_c  DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpast WITH  nfc_c  /MODEL  nfc_c  DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpast WITH  rumination_c  /MODEL  rumination_c  DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpast WITH  depression_c  /MODEL  depression_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpast WITH  E_c  /MODEL  E_c  DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpast WITH  A_c  /MODEL  A_c  DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpast WITH  C_c  /MODEL  C_c  DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpast WITH  N_c  /MODEL  N_c  DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpast WITH  O_c  /MODEL  O_c  DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpast WITH  LOT_c  /MODEL  LOT_c  DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN fpast WITH  narc_c  /MODEL  narc_c  DISTRIBUTION=POISSON /PRINT SOLUTION.

*excel sheet: "f distant future_poisson pers".
output close all.
filter by oneline.
GENLIN ffuture WITH  age  /MODEL  age DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN ffuture WITH  religious_c  /MODEL  religious_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN ffuture WITH  sex  /MODEL  sex DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN ffuture WITH  tsc_c  /MODEL  tsc_c DISTRIBUTION=POISSON   /PRINT SOLUTION.
GENLIN ffuture WITH  se_c  /MODEL  se_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN ffuture WITH  ls_c  /MODEL  ls_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN ffuture WITH  nfc_c  /MODEL  nfc_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN ffuture WITH  rumination_c  /MODEL  rumination_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN ffuture WITH  depression_c  /MODEL  depression_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN ffuture WITH  E_c  /MODEL  E_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN ffuture WITH  A_c  /MODEL  A_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN ffuture WITH  C_c  /MODEL  C_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN ffuture WITH  N_c  /MODEL  N_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN ffuture WITH  O_c  /MODEL  O_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN ffuture WITH  LOT_c  /MODEL  LOT_c DISTRIBUTION=POISSON /PRINT SOLUTION.
GENLIN ffuture WITH  narc_c  /MODEL  narc_c DISTRIBUTION=POISSON /PRINT SOLUTION.



COMMENT BOOKMARK;LINE_NUM=52;ID=8.
