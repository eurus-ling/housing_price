{"metadata":{"kernelspec":{"name":"ir","display_name":"R","language":"R"},"language_info":{"name":"R","codemirror_mode":"r","pygments_lexer":"r","mimetype":"text/x-r-source","file_extension":".r","version":"4.0.5"}},"nbformat_minor":4,"nbformat":4,"cells":[{"cell_type":"code","source":"data <- read.csv('/kaggle/input/kaggledata/Before_R.csv')\ndata2 <- read.csv('/kaggle/input/kaggledata2/Before_R_defore_dummy.csv')","metadata":{"execution":{"iopub.status.busy":"2022-11-26T07:50:41.053082Z","iopub.execute_input":"2022-11-26T07:50:41.054557Z","iopub.status.idle":"2022-11-26T07:50:41.162223Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"install.packages('rsq')","metadata":{"execution":{"iopub.status.busy":"2022-11-26T07:50:43.654510Z","iopub.execute_input":"2022-11-26T07:50:43.655762Z","iopub.status.idle":"2022-11-26T07:50:55.345490Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"### 数据处理\n\n#### 加入交叉项","metadata":{}},{"cell_type":"code","source":"data$Com8 <- data$TotRmsAbvGrd * data$BedroomAbvGr #0.66\ndata$Com1 <- data$TotRmsAbvGrd * data$ndFlrSF \ndata$Com2 <- data$BedroomAbvGr * data$ndFlrSF\ndata$Com3 <- data$GarageArea * data$Bath_total\ndata$Com4 <- data$LotArea * data$LotFrontage\ndata$Com5 <- data$OverallQual * data$Bath_total\ndata$Com6 <- data$TotRmsAbvGrd * data$Bath_total\ndata$Com7 <- data$MSSubClass * data$ndFlrSF","metadata":{"execution":{"iopub.status.busy":"2022-11-26T07:50:59.325193Z","iopub.execute_input":"2022-11-26T07:50:59.326594Z","iopub.status.idle":"2022-11-26T07:50:59.347558Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"data$X <- NULL\n\ntrain <- data[which(data$lable==1),]\n\nlibrary(caTools)\nlibrary(matrixStats)\n\ntrain_data <- data[which(data$lable==1),]\ntest_data <- data[which(data$lable==0),]\ntrain_data <- train_data[, -which(colnames(train_data)=='lable')]\ntest_data <- test_data[, -which(colnames(train_data)=='lable')]\n\n#重新导入数据的话记得删1st,2nd\n\nnum <- c('MSSubClass', 'LotFrontage', 'LotArea', 'OverallQual', 'OverallCond', 'MasVnrArea', 'stFlrSF',\n         'ndFlrSF', 'BedroomAbvGr', 'KitchenAbvGr', 'TotRmsAbvGrd', 'Fireplaces', 'GarageArea', 'WoodDeckSF', 'PoolArea', 'MiscVal', 'UnfinishedBsm_ratio', 'LowQuality_ratio', 'Bath_total', 'Porch', 'Com1', 'Com2', 'Com3', 'Com4', 'Com5', 'Com6', 'Com7', 'Com8')\n# 标准化\ntrain_data[,num] <- scale(train_data[, num], center = TRUE, scale = TRUE)\n#train_data <- as.data.frame(train_data)","metadata":{"execution":{"iopub.status.busy":"2022-11-26T07:51:04.362605Z","iopub.execute_input":"2022-11-26T07:51:04.363948Z","iopub.status.idle":"2022-11-26T07:51:04.403629Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"train_data2 <- data2[which(data2$lable==1),]\ntest_data2 <- data2[which(data2$lable==0),]\ntrain_data2 <- train_data2[, -which(colnames(train_data2)=='lable')]\ntest_data2 <- test_data2[, -which(colnames(train_data2)=='lable')]","metadata":{"execution":{"iopub.status.busy":"2022-11-26T08:01:55.437319Z","iopub.execute_input":"2022-11-26T08:01:55.439500Z","iopub.status.idle":"2022-11-26T08:01:55.468992Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"qqnorm(train_data[,'SalePrice'])\nqqline(train_data[,'SalePrice'], col = 'red')","metadata":{"execution":{"iopub.status.busy":"2022-11-26T07:51:07.534696Z","iopub.execute_input":"2022-11-26T07:51:07.536203Z","iopub.status.idle":"2022-11-26T07:51:07.658708Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"qqnorm(log(train_data[,'SalePrice']))\nqqline(log(train_data[,'SalePrice']), col = 'red')","metadata":{"execution":{"iopub.status.busy":"2022-11-26T07:51:11.354971Z","iopub.execute_input":"2022-11-26T07:51:11.356345Z","iopub.status.idle":"2022-11-26T07:51:11.483116Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"### 模型初步建立","metadata":{}},{"cell_type":"code","source":"library(MASS)\n\nmodel <- lm(log(SalePrice) ~ .,data = train_data)\nstp <- stepAIC(model, direction='both', trace = F)","metadata":{"execution":{"iopub.status.busy":"2022-11-26T07:51:14.796941Z","iopub.execute_input":"2022-11-26T07:51:14.798305Z","iopub.status.idle":"2022-11-26T07:51:55.968606Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"print('AIC of Base Modle:')\nAIC(model)\nprint('BIC of Base Modle:')\nBIC(model)","metadata":{"execution":{"iopub.status.busy":"2022-11-26T07:52:43.358431Z","iopub.execute_input":"2022-11-26T07:52:43.359895Z","iopub.status.idle":"2022-11-26T07:52:43.385740Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"summary(model)","metadata":{"execution":{"iopub.status.busy":"2022-11-26T07:52:49.843068Z","iopub.execute_input":"2022-11-26T07:52:49.844388Z","iopub.status.idle":"2022-11-26T07:52:49.869459Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"summary(stp)","metadata":{"execution":{"iopub.status.busy":"2022-11-26T07:53:08.059026Z","iopub.execute_input":"2022-11-26T07:53:08.060502Z","iopub.status.idle":"2022-11-26T07:53:08.087794Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"print('AIC of model1:')\nAIC(stp)\nprint('BIC of model1:')\nBIC(stp)","metadata":{"execution":{"iopub.status.busy":"2022-11-26T07:53:12.265059Z","iopub.execute_input":"2022-11-26T07:53:12.267307Z","iopub.status.idle":"2022-11-26T07:53:12.293626Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"stp2 <- stepAIC(model, direction='both', trace = F, k = log(dim(train_data)[1]))","metadata":{"execution":{"iopub.status.busy":"2022-11-26T07:53:16.006302Z","iopub.execute_input":"2022-11-26T07:53:16.007733Z","iopub.status.idle":"2022-11-26T07:54:09.122501Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"summary(stp2)","metadata":{"execution":{"iopub.status.busy":"2022-11-26T07:54:24.329524Z","iopub.execute_input":"2022-11-26T07:54:24.330840Z","iopub.status.idle":"2022-11-26T07:54:24.350382Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"print('AIC of model2:')\nAIC(stp2)\nprint('BIC of model2:')\nBIC(stp2)","metadata":{"execution":{"iopub.status.busy":"2022-11-26T07:54:36.854119Z","iopub.execute_input":"2022-11-26T07:54:36.856076Z","iopub.status.idle":"2022-11-26T07:54:36.889744Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"names <- c('SalePrice', 'MSSubClass', 'LotArea',  'OverallQual', \n    'OverallCond', 'stFlrSF', 'ndFlrSF', 'BedroomAbvGr', 'TotRmsAbvGrd',\n    'Fireplaces' , 'WoodDeckSF' , 'YearBuilt_Before1950' , 'YearBuilt_After1980' ,\n    'UnfinishedBsm_ratio', 'Bath_total', 'Porch' ,'MSZoning_FV', 'MSZoning_RH', 'MSZoning_RL', \n    'MSZoning_RM', 'LotConfig_CulDSac', 'MasVnrType_Stone', 'MasVnrType_BrkFace', 'MasVnrType_None',\n    'LotConfig_FR2','LotConfig_FR3','LotConfig_Inside','LandSlope_Sev','LandSlope_Mod',\n    'RoofMatl_CompShg','RoofMatl_Membran', 'RoofMatl_Metal', 'RoofMatl_Roll', \n    'RoofMatl_TarGrv', 'RoofMatl_WdShake', 'RoofMatl_WdShngl',\n    'ExterCond_Gd','ExterCond_Fa','ExterCond_TA',\n    'Foundation_PConc','Foundation_CBlock','Foundation_Stone','Foundation_Wood','BsmtExposure_Gd',\n    'BsmtExposure_Mn','BsmtExposure_No', 'PavedDrive_Y', 'PavedDrive_P',\n    'HeatingQC_Fa','HeatingQC_Gd','HeatingQC_Po','HeatingQC_TA','CentralAir_Y','KitchenQual_Gd','KitchenQual_Fa','KitchenQual_TA', \n    'Functional_Maj2','Functional_Min1','Functional_Min2','Functional_Mod','Functional_Typ','Functional_Sev',\n    'SaleCondition_Normal','SaleCondition_AdjLand','SaleCondition_Alloca','SaleCondition_Family','SaleCondition_Partial', \n    'Com2', 'Com3', 'Com6', 'Com7')","metadata":{"execution":{"iopub.status.busy":"2022-11-26T07:54:40.241050Z","iopub.execute_input":"2022-11-26T07:54:40.242348Z","iopub.status.idle":"2022-11-26T07:54:40.253665Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"好像咱处理的进去了很多，✌！\n\n'ExterCond_Po'删了,只有一个1","metadata":{}},{"cell_type":"code","source":"model1 <- lm(log(SalePrice) ~ .,data = train_data[,names])","metadata":{"execution":{"iopub.status.busy":"2022-11-26T07:55:09.031391Z","iopub.execute_input":"2022-11-26T07:55:09.032785Z","iopub.status.idle":"2022-11-26T07:55:09.060006Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"summary(model1)","metadata":{"execution":{"iopub.status.busy":"2022-11-26T07:55:11.803402Z","iopub.execute_input":"2022-11-26T07:55:11.804786Z","iopub.status.idle":"2022-11-26T07:55:11.830348Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"print('AIC of model1:')\nAIC(model1)\nprint('BIC of model1:')\nBIC(model1)","metadata":{"execution":{"iopub.status.busy":"2022-11-26T07:55:16.067663Z","iopub.execute_input":"2022-11-26T07:55:16.069071Z","iopub.status.idle":"2022-11-26T07:55:16.094118Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"### 诊断","metadata":{}},{"cell_type":"markdown","source":"#### 残差分析\n\n1. 对所有模型中的变量画图（主要参照了第三章Residual那部分）\n\n* 看起来都线性的不行\n\n* 方差看着也都是常数\n\n* 离群值有，但不多且不明显，除了lotArea怪怪的（参照python）\n","metadata":{}},{"cell_type":"code","source":"for (i in 1:dim(model1$model)[1])\n    plot(model1$model[1:300,i],model1$residuals[1:300], main = colnames(model1$model)[i])","metadata":{"execution":{"iopub.status.busy":"2022-11-26T06:50:01.036912Z","iopub.execute_input":"2022-11-26T06:50:01.038688Z","iopub.status.idle":"2022-11-26T06:50:06.045025Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"* 方差看着也确实是正态的","metadata":{}},{"cell_type":"code","source":"plot(model1$fitted.values, model1$residuals,\n     xlab = 'SalePrice',ylab = 'residuals',\n     main = 'Residual Plot')\nqqnorm(model1$residuals)\nqqline(model1$residuals,col = 'red')","metadata":{"execution":{"iopub.status.busy":"2022-11-26T07:04:15.360320Z","iopub.execute_input":"2022-11-26T07:04:15.361710Z","iopub.status.idle":"2022-11-26T07:04:15.605147Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"* 残差对所有被丢弃的变量画图\n\n结论是？？？扔得好？","metadata":{}},{"cell_type":"code","source":"for (i in 1:length(colnames(data))){\n    if (!(colnames(data)[i] %in% names))\n        plot(train_data[,i], model1$residuals, main = colnames(data)[i])\n}","metadata":{"execution":{"iopub.status.busy":"2022-11-26T07:04:26.159552Z","iopub.execute_input":"2022-11-26T07:04:26.161020Z","iopub.status.idle":"2022-11-26T07:04:32.330872Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"使用未dummy的数据对分类变量进行整合画图","metadata":{}},{"cell_type":"code","source":"library(lattice)","metadata":{},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"temp = cbind(as.data.frame(model1$residual),as.data.frame(train_data2$Functional))\ncolnames(temp) <- c('residual','Functional')\ntemp$Functional <- factor(temp$Functional)\nxyplot(residual~Functional,data=temp,col=\"black\",jitter.x = T,abline = 0,xlab = '',main='Functional')","metadata":{"execution":{"iopub.status.busy":"2022-11-26T08:29:52.008851Z","iopub.execute_input":"2022-11-26T08:29:52.010890Z","iopub.status.idle":"2022-11-26T08:29:52.179766Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"2. 齐方差性考察\n\n单变量方法，不用：\n\n* B-F Test\n\n* B-P Test : 要求独立且正态，不选用\n\n**画图看**","metadata":{}},{"cell_type":"code","source":"plot(model1$fitted.values, model1$residuals,\n     xlab = 'SalePrice',ylab = 'residuals',\n    main = 'Residual Plot')","metadata":{"execution":{"iopub.status.busy":"2022-11-26T08:35:59.792129Z","iopub.execute_input":"2022-11-26T08:35:59.793660Z","iopub.status.idle":"2022-11-26T08:35:59.910742Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"* 异方差性检验\n\nncvTest生成计分检验，原假设为误差方差不变，备择假设为误差方差随拟合值水平的变化而变化","metadata":{}},{"cell_type":"code","source":"library(lmtest)\nlibrary(car)\nncvTest(model1)","metadata":{"execution":{"iopub.status.busy":"2022-11-26T08:36:05.328667Z","iopub.execute_input":"2022-11-26T08:36:05.330260Z","iopub.status.idle":"2022-11-26T08:36:05.380416Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"**！！！结论是H1，我们的方差不是常数，需要修正！！！**","metadata":{}},{"cell_type":"markdown","source":"* F-Test Lack of Fit\n\n找不到参照的模型，不用","metadata":{}},{"cell_type":"markdown","source":"#### 离群值 （第十章）\n\n* https://stats.stackexchange.com/questions/175/how-should-outliers-be-dealt-with-in-linear-regression-analysis 提到了一个方法：rlm\n\n1. Studentized Deleted Residuals ---> Y的离群值\n\n判断标准：是否大于3","metadata":{}},{"cell_type":"code","source":"sdr <- rstudent(model1)\ntrain_data[which(abs(sdr)>3),'SalePrice']","metadata":{"execution":{"iopub.status.busy":"2022-11-26T07:22:05.231045Z","iopub.execute_input":"2022-11-26T07:22:05.232470Z","iopub.status.idle":"2022-11-26T07:22:05.260346Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"#好像是为了考查Y离群的原因是不是周围的样本点太少，似乎没得出结论\ntrain_data[which(abs(train_data[,'SalePrice'] - 60000) <= 5000),names]","metadata":{"execution":{"iopub.status.busy":"2022-11-26T07:22:12.877314Z","iopub.execute_input":"2022-11-26T07:22:12.878636Z","iopub.status.idle":"2022-11-26T07:22:12.908618Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"hist(train_data[,'SalePrice'], nclass = 60)","metadata":{"execution":{"iopub.status.busy":"2022-11-26T07:22:17.917539Z","iopub.execute_input":"2022-11-26T07:22:17.918972Z","iopub.status.idle":"2022-11-26T07:22:17.986392Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"2. Hat Matrix ---> X的离群值","metadata":{}},{"cell_type":"code","source":"H <- hatvalues(model1)\n#判断标准1\nh_mean <- 2*(dim(train_data)[2])/dim(train_data)[1]\nh1 <- as.data.frame(H[which(H > h_mean)])\nx_h <- rownames(h1)","metadata":{"execution":{"iopub.status.busy":"2022-11-26T07:26:03.405079Z","iopub.execute_input":"2022-11-26T07:26:03.406990Z","iopub.status.idle":"2022-11-26T07:26:03.428639Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"#判断标准2\nH[which(H > 0.5)]","metadata":{"execution":{"iopub.status.busy":"2022-11-26T07:26:05.438216Z","iopub.execute_input":"2022-11-26T07:26:05.439477Z","iopub.status.idle":"2022-11-26T07:26:05.452678Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"3. DFFITS, Cook's Distance, DFBETAS ---> Influential Cases\n\n* DIFFITS:  X Outliers","metadata":{}},{"cell_type":"code","source":"DIFFITS <- dffits(model1)\nd <- 2*sqrt((dim(train_data)[2])/dim(train_data)[1])\nprint(d)\ndiff <- as.data.frame(DIFFITS[which(abs(DIFFITS) > d)])","metadata":{"execution":{"iopub.status.busy":"2022-11-26T07:26:07.028120Z","iopub.execute_input":"2022-11-26T07:26:07.029442Z","iopub.status.idle":"2022-11-26T07:26:07.049726Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"x_out <- c()\nfor (i in 1:dim(diff)[1]){\n    if (rownames(diff)[i] %in% rownames(h1)){\n        x_out <- c(x_out, c(rownames(diff)[i]))\n    }\n}\nx_out","metadata":{"execution":{"iopub.status.busy":"2022-11-26T07:26:13.434270Z","iopub.execute_input":"2022-11-26T07:26:13.435772Z","iopub.status.idle":"2022-11-26T07:26:13.462112Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"* Cook's Distance","metadata":{}},{"cell_type":"code","source":"COK <- cooks.distance(model1)\nCOK[which(abs(COK) >= 0.2)]\n#大于0.5的才严重","metadata":{"execution":{"iopub.status.busy":"2022-11-26T07:26:16.011338Z","iopub.execute_input":"2022-11-26T07:26:16.012775Z","iopub.status.idle":"2022-11-26T07:26:16.036707Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"* DFBETAS : 对回归参数的影响\n\n  第i组数据对第k个系数的影响","metadata":{}},{"cell_type":"code","source":"# 用于细化显著\nDFBETAS <- dfbetas(model1)\ndf <- 2/sqrt(dim(train_data)[1])\nprint(df)\n#which(abs(DFBETAS) > df)\nx_df <- DFBETAS[x_h, ]\nwhere <- which(abs(x_df) > df, arr.ind = TRUE)\nfor (i in 1:dim(where)[1]){\n    print(rownames(where)[i])\n    print(colnames(train_data)[where[i,2]])\n}\n","metadata":{"execution":{"iopub.status.busy":"2022-11-26T07:26:19.031295Z","iopub.execute_input":"2022-11-26T07:26:19.033507Z","iopub.status.idle":"2022-11-26T07:26:19.136805Z"},"collapsed":true,"jupyter":{"outputs_hidden":true},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"#### 多重共线性\n\nVIF","metadata":{}},{"cell_type":"code","source":"library(car)\nlibrary(carData)\nV <- vif(model1)\nsum(V)/length(V)","metadata":{"execution":{"iopub.status.busy":"2022-11-26T07:26:29.904894Z","iopub.execute_input":"2022-11-26T07:26:29.906191Z","iopub.status.idle":"2022-11-26T07:26:29.951344Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"#### Added-Variable Plots 检查模型质量\n\n已经用了step-wise,暂时不用这个","metadata":{}},{"cell_type":"markdown","source":"### 修复\n\n（第十一章）\n\n#### 1. 不具有齐方差性---> Weighted Least Squares","metadata":{}},{"cell_type":"code","source":"C <- t(cor(model1$residuals^2, model1$model))  #Residuals 和 X,Y的相关性矩阵\ne_model <- which(abs(C)>=0.05)\nwls_data <- model1$model[e_model]\nwls_data <- cbind(wls_data, as.data.frame(model1$residuals^2))","metadata":{"execution":{"iopub.status.busy":"2022-11-26T08:40:03.511672Z","iopub.execute_input":"2022-11-26T08:40:03.513653Z","iopub.status.idle":"2022-11-26T08:40:03.538675Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"re_function <- lm(abs(model1$residuals) ~., data = wls_data)\nmodel2 <- lm(log(SalePrice) ~ .,data = train_data[,names], weights = 1/(re_function$fitted.values)^2)","metadata":{"execution":{"iopub.status.busy":"2022-11-26T08:40:09.325027Z","iopub.execute_input":"2022-11-26T08:40:09.327149Z","iopub.status.idle":"2022-11-26T08:40:09.368783Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"a <- re_function$fitted.values\na[which(a<0)]\n###取了绝对值","metadata":{"execution":{"iopub.status.busy":"2022-11-26T08:40:12.182541Z","iopub.execute_input":"2022-11-26T08:40:12.185068Z","iopub.status.idle":"2022-11-26T08:40:12.207769Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"plot(model2$fitted.values, model2$residuals,\n     xlab = 'SalePrice',ylab = 'residuals',\n    main = 'Residual Plot of WLS')","metadata":{"execution":{"iopub.status.busy":"2022-11-26T08:40:14.566712Z","iopub.execute_input":"2022-11-26T08:40:14.568474Z","iopub.status.idle":"2022-11-26T08:40:14.691372Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"13以上的数据很少，拟合效果很不稳定","metadata":{}},{"cell_type":"code","source":"summary(model2)","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"ncvTest(model2)","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"#### 2.多重共线性---> Ridge Regression","metadata":{}},{"cell_type":"code","source":"library(glmnet)","metadata":{"execution":{"iopub.status.busy":"2022-11-26T08:53:38.100204Z","iopub.execute_input":"2022-11-26T08:53:38.102386Z","iopub.status.idle":"2022-11-26T08:53:38.120080Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"install.packages('glmnet')","metadata":{"execution":{"iopub.status.busy":"2022-11-26T08:51:11.218122Z","iopub.execute_input":"2022-11-26T08:51:11.219710Z","iopub.status.idle":"2022-11-26T08:53:14.982515Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"x <- train_data[,names]\ny <- train_data[,'SalePrice']\nx$SalePrice <- NULL\nfit <- glmnet(x,y,weights = 1/(re_function$fitted.values)^2)","metadata":{"execution":{"iopub.status.busy":"2022-11-26T08:53:40.801896Z","iopub.execute_input":"2022-11-26T08:53:40.804420Z","iopub.status.idle":"2022-11-26T08:53:40.875097Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"print(fit)","metadata":{"execution":{"iopub.status.busy":"2022-11-26T08:53:58.008667Z","iopub.execute_input":"2022-11-26T08:53:58.010938Z","iopub.status.idle":"2022-11-26T08:53:58.032483Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"V1 <- vif(model2)\nsum(V1)/length(V1)","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"try_ridge <- lm.ridge(log(SalePrice) ~ .,data = train_data[,names], weights = 1/(re_function$fitted.values)^2, lambda = seq(0,5,0.001))\nplot(try_ridge) ","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"select(lm.ridge(log(SalePrice) ~ .,data = train_data[,names], weights = 1/(re_function$fitted.values)^2, lambda = seq(0,100,0.001)))","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"model3 <- lm.ridge(log(SalePrice) ~ .,data = train_data[,names], weights = 1/(re_function$fitted.values)^2, lambda = 0.413)","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"#截距：9.108208476\nx_names <- names[-which(names=='SalePrice')]\nCoef <- as.matrix(model3$coef)\ny_hat_log <- as.matrix(train_data[, x_names]) %*% Coef + 9.108208476\ne <- log(train_data[, 'SalePrice']) - y_hat_log\nSSE <- sum(e**2)\nSSTO <- sum((log(train_data[, 'SalePrice']) - mean(log(train_data[, 'SalePrice'])))**2)\n1 - SSE/SSTO ","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"#### 3.Influential Cases---> Robust Regression\n\n网上说如果有很多Outlier的化话用这个，同时不用R-square作为评价指标，但我们似乎没有很多？https://stackoverflow.com/questions/60073531/is-it-appropriate-to-calculate-r-squared-of-robust-regression-using-rlm","metadata":{}},{"cell_type":"code","source":"library(MASS)\nlibrary(rsq)\nrobust <- rlm(log(SalePrice) ~ .,data = train_data[,names], weights = 1/(re_function$fitted.values)^2)\nplot(robust$fitted.values, robust$residuals,\n     xlab = 'SalePrice',ylab = 'residuals',\n    main = 'Residual Plot of Robust Regression')\n#好像没啥区别啊 笑死 也许可以用划分后的data比较一下预测的效果","metadata":{"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"","metadata":{},"execution_count":null,"outputs":[]}]}