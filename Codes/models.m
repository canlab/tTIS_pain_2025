load('T_All_data_post.mat')

registered_model= fitlme(T_All_data_post, 'Pain_post ~ 1 + Pain_pre + stim_order + Session +  (Run + Trial + Temp * Side) * (Sham + Twenty + Ten) + (1 +  Temp * (Sham + Twenty + Ten)  | Sub)', 'DummyVarCoding', 'reference');
anova_registered_model = anova(registered_model,'DFMethod', 'Satterthwaite')


complex_model= fitlme(T_All_data_post, 'Pain_post ~ 1 + Pain_pre + stim_order + Session +  (Run + Trial  +  age + gender  + Temp * Side ) * (Sham + Twenty + Ten) + (1 +  Session + (Run + Trial + Temp ) * (Sham + Twenty + Ten)  | Sub)', 'DummyVarCoding', 'reference');
anova_complex_model = anova(complex_model,'DFMethod', 'Satterthwaite');


%% Factor analysis on sensation induced by tTIS and use those factors in mixed-effect model

model_with_factor_analysis_on_sensation_induced_by_tTIS= fitlme(T_All_data_post, 'Pain_post ~ 1 + Pain_pre + stim_order + Session  + (Run + Trial + Temp * Side + factor1 + factor2) * (Sham + Twenty + Ten) + (1 +  Temp * (Sham + Twenty + Ten)  | Sub)', 'DummyVarCoding', 'reference');
anova_model_with_factor_analysis_on_sensation_induced_by_tTIS = anova(model_with_factor_analysis_on_sensation_induced_by_tTIS,'DFMethod', 'Satterthwaite')

