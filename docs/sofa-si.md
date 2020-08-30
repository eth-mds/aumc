## SOFA

- Mechanical ventilation
  - itemid 9328 in _processitems_ table
  - `start` and `stop` columns give the exact times of the ventilation start and end
- Vasopressors
  - using the respective items in the dictionary
  - there is a `doserateperkg` column indicator, but it is FALSE for almost all vasopressors
  - `start` and `stop` columns give the exact time of start and end
  - the amount should be extracted from the `administered` column (it is in mg most of the time)
  - it has to be
  1. converted to mcg
  2. divided by the total infusion time (stop - start)
  3. normalized by patient weight
- Urine
  - _numericitems_ table, itemid 8794 contains point urine outputs in mililiters

## Suspected infection

### Antibiotics
```
 [,1]                                           
 [1,] "Amikacine (Amukin)"                           
 [2,] "Amoxicilline/Clavulaanzuur (Augmentin)"       
 [3,] "Amoxicilline (Clamoxyl/Flemoxin)"             
 [4,] "Amoxicilline/Clavulaanzuur (Augmentin)"       
 [5,] "Moxifloxacin (Avelox)"                        
 [6,] "Aztreonam (Azactam)"                          
 [7,] "Aztreonam (Azactam)"                          
 [8,] "Co-Trimoxazol (Bactrimel)"                    
 [9,] "Co-trimoxazol forte (Bactrimel)"              
[10,] "Cefazoline (Kefzol)"                          
[11,] "Ciprofloxacine (Ciproxin)"                    
[12,] "Ciprofloxacine (Ciproxin)"                    
[13,] "Cefotaxim (Claforan)"                         
[14,] "Clindamycine (Dalacin)"                       
[15,] "Daptomycine (Cubicin)"                        
[16,] "Doxycycline (Vibramycine)"                    
[17,] "Erythromycine (Erythrocine)"                  
[18,] "Erythromycine (Erythrocine)"                  
[19,] "Metronidazol (Flagyl)"                        
[20,] "Metronidazol-Flagyl"                          
[21,] "Gentamicine (Garamycin)"                      
[22,] "Gentamicine (Garamycin)"                      
[23,] "Dexamethason/gentamicine oogzalf (Dexamytrex)"
[24,] "Levofloxacine (Tavanic)"                      
[25,] "Moxifloxacin (Avelox)"                        
[26,] "Norfloxacine (Noroxin)"                       
[27,] "Ciprofloxacine (Ciproxin)"                    
[28,] "Levofloxacine (Tavanic)"                      
[29,] "Ofloxacine (Trafloxal) oogdruppels"           
[30,] "Flucloxacilline (Stafoxil/Floxapen)"          
[31,] "Benzylpenicilline (Penicilline)"              
[32,] "Piperacilline (Pipcil)"                       
[33,] "Rifampicine (Rifadin)"                        
[34,] "Ceftriaxon (Rocephin)"                        
[35,] "Zilversulfadiazine (Flammazine)"              
[36,] "Tetracycline"                                 
[37,] "Tobramycine (Obracin)"                        
[38,] "Tobramycine oogzalf (Tobrex)"                 
[39,] "Vancomycine"                                  
[40,] "Doxycycline (Vibramycine)"                    
[41,] "Cefuroxim (Zinacef)"                          
[42,] "Azitromycine (Zithromax)"                     
[43,] "Linezolid (Zyvoxid)"   
```
which correspond to the following set of IDs
```
c(6834L, 103L, 9029L, 12389L, 6847L, 12262L, 9029L,
12389L, 12956L, 59L, 9030L, 2L, 9030L, 2L, 8394L, 8064L,
9052L, 1199L, 9152L, 24241L, 6948L, 15591L, 6948L, 15591L,
6919L, 29321L, 6958L, 3237L, 19773L, 19L, 7185L, 247L, 7208L,
23166L, 7208L, 23166L, 7187L, 27617L, 8942L, 24L, 7235L,
1300L, 7235L, 1300L, 13102L, 240L, 12398L, 3741L, 12956L,
59L, 9117L, 13L, 6948L, 15591L, 12398L, 3741L, 12997L, 1133L,
7227L, 18860L, 6871L, 2834L, 9128L, 5576L, 6953L, 1371L,
9133L, 20563L, 9070L, 333L, 9142L, 29L, 7044L, 2284L, 13094L,
28L, 7064L, 25776L, 7185L, 247L, 9151L, 1795L, 13057L, 82L,
19137L, 57L)
```  
which can be matched to the `drugitems` table.
