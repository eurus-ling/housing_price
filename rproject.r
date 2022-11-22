{"metadata":{"kernelspec":{"name":"ir","display_name":"R","language":"R"},"language_info":{"name":"R","codemirror_mode":"r","pygments_lexer":"r","mimetype":"text/x-r-source","file_extension":".r","version":"4.0.5"}},"nbformat_minor":4,"nbformat":4,"cells":[{"cell_type":"code","source":"data <- read.csv('/kaggle/input/trytrytry/Before_R.csv')","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"install.packages('rsq')","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"### 数据处理\n\n#### 加入交叉项","metadata":{}},{"cell_type":"code","source":"data$TotBed <- data$TotRmsAbvGrd * data$BedroomAbvGr","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"data$X <- NULL\n\ntrain_data <- data[which(data$lable==1),]\ntest_data <- data[which(data$lable==0),]\n\n#重新导入数据的话记得删1st,2nd\n\nnum <- c('MSSubClass', 'LotFrontage', 'LotArea', 'OverallQual', 'OverallCond', 'MasVnrArea', 'stFlrSF',\n         'ndFlrSF', 'BedroomAbvGr', 'KitchenAbvGr', 'TotRmsAbvGrd', 'Fireplaces', 'GarageArea', 'WoodDeckSF', 'PoolArea', 'MiscVal', 'UnfinishedBsm_ratio', 'LowQuality_ratio', 'Bath_total', 'Porch','TotBed')\ntrain_data[,num] <- scale(train_data[,num], center = TRUE, scale = TRUE)\n#train_data <- as.data.frame(train_data)","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"### 模型初步建立","metadata":{}},{"cell_type":"code","source":"library(MASS)\n\nmodel <- lm(log(SalePrice) ~ .,data = train_data)\nstp <- stepAIC(model, direction='both', trace = F)","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"summary(stp)","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"stp2 <- stepAIC(model, direction='both', trace = F, k = log(dim(train_data)[1]))","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"summary(stp2)","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"#### 采用BIC的Model\n\n补齐分类变量（扔了saleType)","metadata":{}},{"cell_type":"code","source":"names <- c('SalePrice','MSSubClass','LotArea','OverallQual','OverallCond','stFlrSF','ndFlrSF',\n           'KitchenAbvGr', 'Fireplaces', 'GarageArea', 'WoodDeckSF', 'YearBuilt_Before1950','YearBuilt_After1980',\n    'UnfinishedBsm_ratio','Bath_total', 'Porch', 'MSZoning_FV', 'MSZoning_RH', 'MSZoning_RL', \n    'MSZoning_RM', 'LandContour_HLS','LandContour_Low','LandContour_Lvl','LotConfig_CulDSac',\n    'LotConfig_FR2','LotConfig_FR3','LotConfig_Inside','LandSlope_Sev','LandSlope_Mod',\n    'RoofMatl_CompShg','RoofMatl_Membran', 'RoofMatl_Metal', 'RoofMatl_Roll', \n    'RoofMatl_TarGrv', 'RoofMatl_WdShake', 'RoofMatl_WdShngl', 'ExterQual_Gd','ExterQual_Fa','ExterQual_TA', \n    'ExterCond_Gd','ExterCond_Fa','ExterCond_TA',\n    'Foundation_PConc','Foundation_CBlock','Foundation_Stone','Foundation_Wood','BsmtExposure_Gd','BsmtExposure_Mn','BsmtExposure_No',\n    'HeatingQC_Fa','HeatingQC_Gd','HeatingQC_Po','HeatingQC_TA','CentralAir_Y','KitchenQual_Gd','KitchenQual_Fa','KitchenQual_TA', \n    'Functional_Maj2','Functional_Min1','Functional_Min2','Functional_Mod','Functional_Typ','Functional_Sev',\n    'SaleCondition_Normal','SaleCondition_AdjLand','SaleCondition_Alloca','SaleCondition_Family','SaleCondition_Partial')","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"好像咱处理的进去了很多，✌！\n\n'ExterCond_Po'删了,只有一个1","metadata":{}},{"cell_type":"code","source":"model1 <- lm(log(SalePrice) ~ .,data = train_data[,names])","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"summary(model1)","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"### 诊断","metadata":{}},{"cell_type":"markdown","source":"#### 残差分析\n\n1. 对所有模型中的变量画图（主要参照了第三章Residual那部分）\n\n* 看起来都线性的不行\n\n* 方差看着也都是常数\n\n* 离群值有，但不多且不明显，除了lotArea怪怪的（参照python）\n","metadata":{}},{"cell_type":"code","source":"for (i in 1:dim(model1$model)[1])\n    plot(model1$model[1:300,i],model1$residuals[1:300], main = colnames(model1$model)[i])","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"* 方差看着也确实是正态的","metadata":{}},{"cell_type":"code","source":"plot(model1$fitted.values, model1$residuals,\n     xlab = 'SalePrice',ylab = 'residuals',\n     main = 'Residual Plot')\nqqnorm(model1$residuals)\nqqline(model1$residuals,col = 'red')","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"* 残差对所有被丢弃的变量画图\n\n结论是？？？扔得好？","metadata":{}},{"cell_type":"code","source":"for (i in 1:length(colnames(data))){\n    if (!(colnames(data)[i] %in% names))\n        plot(train_data[,i], model1$residuals, main = colnames(data)[i])\n}","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"2. 齐方差性考察\n\n单变量方法，不用：\n\n* B-F Test\n\n* B-P Test : 要求独立且正态，不选用\n\n**画图看**","metadata":{}},{"cell_type":"code","source":"plot(model1$fitted.values, model1$residuals,\n     xlab = 'SalePrice',ylab = 'residuals',\n    main = 'Residual Plot')","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"* 异方差性检验\n\nncvTest生成计分检验，原假设为误差方差不变，备择假设为误差方差随拟合值水平的变化而变化","metadata":{}},{"cell_type":"code","source":"library(lmtest)\nlibrary(car)\nncvTest(model1)","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"**！！！结论是H1，我们的方差不是常数，需要修正！！！**","metadata":{}},{"cell_type":"markdown","source":"* F-Test Lack of Fit\n\n找不到参照的模型，不用","metadata":{}},{"cell_type":"markdown","source":"#### 离群值 （第十章）\n\n* https://stats.stackexchange.com/questions/175/how-should-outliers-be-dealt-with-in-linear-regression-analysis 提到了一个方法：rlm\n\n1. Studentized Deleted Residuals ---> Y的离群值\n\n判断标准：是否大于3","metadata":{}},{"cell_type":"code","source":"sdr <- rstudent(model1)\ntrain_data[which(abs(sdr)>3),'SalePrice']","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"#好像是为了考查Y离群的原因是不是周围的样本点太少，似乎没得出结论\ntrain_data[which(abs(train_data[,'SalePrice'] - 60000) <= 5000),names]","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"hist(train_data[,'SalePrice'], nclass = 60)","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"2. Hat Matrix ---> X的离群值","metadata":{}},{"cell_type":"code","source":"H <- hatvalues(model1)\n#判断标准1\nh_mean <- 2*(dim(train_data)[2])/dim(train_data)[1]\nh1 <- as.data.frame(H[which(H > h_mean)])\nt(h1)","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"#判断标准2\nH[which(H > 0.5)]","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"3. DFFITS, Cook's Distance, DFBETAS ---> Influential Cases\n\n* DIFFITS:  X Outliers","metadata":{}},{"cell_type":"code","source":"DIFFITS <- dffits(model1)\nd <- 2*sqrt((dim(train_data)[2])/dim(train_data)[1])\nprint(d)\ndiff <- as.data.frame(DIFFITS[which(abs(DIFFITS) > d)])","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"x_out <- c()\nfor (i in 1:dim(diff)[1]){\n    if (rownames(diff)[i] %in% rownames(h1)){\n        x_out <- c(x_out, c(rownames(diff)[i]))\n    }\n}\nx_out","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"* Cook's Distance","metadata":{}},{"cell_type":"code","source":"COK <- cooks.distance(model1)\nCOK[which(abs(COK) >= 0.2)]","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"* DFBETAS : 对回归参数的影响\n\n  第i组数据对第k个系数的影响","metadata":{}},{"cell_type":"code","source":"# 用于细化显著\nDFBETAS <- dfbetas(model1)\ndf <- 2/sqrt(dim(train_data)[1])\nprint(df)\n#which(abs(DFBETAS) > df)\nDFBETAS[which(abs(DFBETAS) > df, arr.ind=TRUE)]","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"#### 多重共线性\n\nVIF","metadata":{}},{"cell_type":"code","source":"library(car)\nlibrary(carData)\nV <- vif(model1)\nsum(V)/length(V)","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"#### Added-Variable Plots 检查模型质量\n\n已经用了step-wise,暂时不用这个","metadata":{}},{"cell_type":"markdown","source":"### train_data 似乎应该再分成 train_data 和 dev_data, 最后再放到 test_data 里。","metadata":{}},{"cell_type":"markdown","source":"### 修复\n\n（第十一章）\n\n#### 1. 不具有齐方差性---> Weighted Least Squares","metadata":{}},{"cell_type":"code","source":"C <- t(cor(model1$residuals^2, model1$model))  #Residuals 和 X,Y的相关性矩阵\ne_model <- which(abs(C)>=0.05)\nwls_data <- model1$model[e_model]\nwls_data <- cbind(wls_data, as.data.frame(model1$residuals^2))","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"re_function <- lm(abs(model1$residuals) ~., data = wls_data)\nmodel2 <- lm(log(SalePrice) ~ .,data = train_data[,names], weights = 1/(re_function$fitted.values)^2)","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"a <- re_function$fitted.values\na[which(a<0)]\n###取了绝对值","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"plot(model2$fitted.values, model2$residuals,\n     xlab = 'SalePrice',ylab = 'residuals',\n    main = 'Residual Plot of WLS')","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"13以上的数据很少，拟合效果很不稳定","metadata":{}},{"cell_type":"code","source":"summary(model2)","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"ncvTest(model2)","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"#### 2.多重共线性---> Ridge Regression","metadata":{}},{"cell_type":"code","source":"V1 <- vif(model2)\nsum(V1)/length(V1)","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"try_ridge <- lm.ridge(log(SalePrice) ~ .,data = train_data[,names], weights = 1/(re_function$fitted.values)^2, lambda = seq(0,5,0.001))\nplot(try_ridge) ","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"select(lm.ridge(log(SalePrice) ~ .,data = train_data[,names], weights = 1/(re_function$fitted.values)^2, lambda = seq(0,100,0.001)))","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"model3 <- lm.ridge(log(SalePrice) ~ .,data = train_data[,names], weights = 1/(re_function$fitted.values)^2, lambda = 0.413)","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"#### 3.Influential Cases---> Robust Regression\n\n网上说如果有很多Outlier的化话用这个，同时不用R-square作为评价指标，但我们似乎没有很多？https://stackoverflow.com/questions/60073531/is-it-appropriate-to-calculate-r-squared-of-robust-regression-using-rlm","metadata":{}},{"cell_type":"code","source":"library(MASS)\nlibrary(rsq)\nrobust <- rlm(log(SalePrice) ~ .,data = train_data[,names], weights = 1/(re_function$fitted.values)^2)\nplot(robust$fitted.values, robust$residuals,\n     xlab = 'SalePrice',ylab = 'residuals',\n    main = 'Residual Plot of Robust Regression')\n#好像没啥区别啊 笑死 也许可以用划分后的data比较一下预测的效果","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"#### 4.Boostrap","metadata":{}},{"cell_type":"code","source":"","metadata":{},"execution_count":null,"outputs":[]}]}