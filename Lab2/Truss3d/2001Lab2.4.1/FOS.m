P = 8.950000e-03 ;
Mf = 4.8;
Segmaf = .4;
x = icdf('normal',P,Mf,Segmaf );
n = (Mf - x)/Segmaf;
FactorOfSafety = Mf/(Mf-n*Segmaf)

