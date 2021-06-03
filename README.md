# Factors-affecting-Covid-19.

* The project aims to generalize the effects of Novel coronavirus across different counties in United States Of America and moreover discuss various different factors affecting the same. We have taken into account multiple age factors which are getting affected due to the virus and moreover takes into account different condition factors.
The project looks to find distinct and diverse factors in various age groups, i.e. how they are impacting Covid deaths and cases across various regions in United States. The domain of the datasets is related to health care as discussed above the project aims to identify the impact of Covid. The datasets have been selected to take into account all these factors so as to combine diverse factors to get a generalized sense from the available data. The data is obtained mainly from Centre for Disease Control and Prevention which is Federal organization collecting data on daily or random basis as per their availability, moreover as per their description states and local authorities reports the cases regularly to keep the data up to date.


* The project is related to healthcare domain and target the nature and cause of pandemic which has caused ravaged around the world. As of October of 2020 various adults aged between different age groups that re between 20 to 35 and ages 35 to 49 are the ones whose transmission rates have been more than one and this phenomenon is found consistently among such adults with varying age groups. as more and more age groups in Elder people the virus is showing a strong grip hold and thus states should aware in these section of age groups to take consistent precaution as the virus effects are endangering to mass population moreover taking into account the rate of infection rate to which the virus spreads, the project is motivated by the sheer amount of death rates and increasing number of cases as each day passes. Moreover as the study suggests that the age groups from 20 to 49 are seeing an increase in transmission rates daily, thus figure shows 72.2 percent of Covid-19 carriers are peoples in these age groups.
The project takes an distinctive approach to find out the patterns in Covid patients, as the project takes into account datasets from different domains such as the first dataset takes into account the newly positive covid-19 cases while the second dataset is used to get patterns among various probable, confirmed and new cases and deaths and lastly we take into account different age groups and along with diverse condition groups such as Respiratory Diseases, Circulatory Disease, Diabetes, Obesity and many others have a contribution in covid-19 deaths across different counties across the country.

* VIM (Visualization and Imputation of Missing Values) package helps to visualize the missing data in a deep way and thus can help to apply specific mechanisms which can be helpful in analyzing the missing values and deciding whether to impute/replace or remove it, while Fig Shows the implementation of VIM package.


  ![image](https://user-images.githubusercontent.com/78203289/120350915-4f6a2880-c2f7-11eb-9c7a-cfcab6a63ac6.png)

* Regression Techniques Implemented:


1.	XGBoost
2.	Random Forest
3.	Multiple Linear Regression
4.	Decision Tree

* Classification Models Implemented:

1.	KNN(K-Nearest Neighbor)
2.	SVC(Support Vector Classification)

#####

## Dataset 1. Conditions contributing to Covid deaths by age groups across different counties in United States


### Models Buildup


1.	**XGBoost Model**:
In our model buildup XGBoost Cross validation is done using xgboost in-built method such as xgb.cv, which tweeks certain parameters and thus is helpful to get the evaluation log which contains the minimum and maximum tress which are built, using this data we can get the minimum number of trees which are required to predict the dependent variables in the dataset.

2.	**Random Forest Model**:
In our model we have used only 50 trees as increasing the number of trees is increasing computation to an indefinite time and thus is not able to give submissive results, thus the trees has been pruned down to avoid computational error within the model.

## United States COVID cases and deaths


### Models Buildup


1. **Multiple Regression Model**:
Multiple regression model takes into account multiple factors affecting the dependent variable in the dataset. Also it generates dummy variables, as the data contains many categorical variables which requires special needs as they cannot be entered into the regression model as it is, thus they are recoded into a series of variables.

2. **Decision Tree Model**:
Decision Tree works on the model of nodes and constructing a tree with a certain length, in some cases maximum depth variable can be used to much extent. Decision Tree works on the concept of splitting the nodes and thus we have to define the number of minimum splits while defining the decision tree model.We have used rpart library as part of decision tree in R to build and execute the model, moreover the model is also pruned to get the best possible decision tree with minimum number of splits and complexity parameter and as it is a regression model we have used method as anova.

####

### Evaluation of Regression Models:

####

1. **XGBoost**:
In our model we made use of eta which controls the learning curve and it ranges from 0.1 to 0.3 and defining the eta less though is good for the model but is a very slow process thus we need to tune this parameter so as to get the optimal value which can be used in the model. Apart from this nrounds is the parameter which defines the number of iteration which the xgboost model will use, and lastly gamma which incorporates L2 regularization and helps to avoid overfitting in the model.

- K-Fold CV:

Present in the caret package of R, the createFolds method helps to create the number of folds required in the model evaluation. 
In case of xgboost we use the inbuilt method which the modelling technique provides that is xgb.cv function which takes into account the Independent variables, Dependent variable, along with the nfold parameter which defines how many time the iteration would repeat, the booster is defined and as it is a regression technique we make use of gbtree.
Once the xgb.cv we can take the evaluation log and determine the minimum number of trees that can be used to build the tree, and can be used in prediction, so as to give optimal results.

- Evaluating RMSE,MAE:
To evaluate the model more and get the residual error, we made use of RMSE and MAE using the library Metrics in R. While RMSE is limited to outliers and MAE is not sensitive to outliers. We used RMSE and MAE as to get both the perspective of the error values obtained.
RMSE gives and error of 9.70 and MAE gives 2.62, the error obtained can be looked into as RMSE can highlight large errors and MAE can do the opposite. Getting a smaller RMSE and MAE shows that the model has a good accuracy.

2. **Random Forest**:
Random Forest make use of multiple decision trees and takes the average of different trees so as to get the results accumulated by different decision trees.

- Evaluating RMSE,MAE,sMAPE:
To evaluate the Random Forest model, we again made use of RMSE and MAE which in our case give us values of -1221.188 and -150. Moreover we also use Symmetric mean absolute percentage error, which calculates error based on forecasted and actual values.

3. **Multiple Linear Regression:**
Multiple Linear Regression takes multiple Independent variables to establish a relation with the dependent variable. In the model we applied in our analysis, we implemented backward elimination to exclude the variables which are not affecting the dependent variable.

- Adjusted R-squared:
Adjusted R-squared measure error not just taking the dependent variable into account but also the independent variables, thus making it more suitable to be included in the model evaluation.

- Evaluation using RMSE and MAE:
Root Mean Square Error and Mean absolute error is taken into account as both of them have their role in the evaluation of the model, while RMSE is used to show the effect of large errors, MAE gives the absolute error.

4. **Decision Tree:**
Decision Tree works by modelling data in the form of tree structure and splits the data into smaller subsets, with the resultant shown in the leaf nodes of the tree.
- Pruning the Decision Tree:
Once the decision tree is completed, the performance of the tree is elongated by pruning the tree that is removing the features which have less importance. Pruning is done by using prune method and defining the complexity parameter which had the minimal xerror value. Thus pruning increases the decision tree performance.

- Evaluating RMSE, MAE:
As stated in the previous section, various methods such as RMSE and MAE gives absolute and root mean square error.
In our model the optimal values of RMSE came to be 971 and MAE as 636, while the RMSE highlighted the large errors, the MAE is not much affected by outliers.
####

## United States Covid-19 cases and deaths over time


### Models Buildup:

####

1. **KNN (K-Nearest Neighbor)**:
KNN or K nearest Neighbor is a classification as well as Regression model, which takes into the Euclidean distance. KNN application is rather simple as compared to other Machine Learning methods, moreover the number of Hyper-parameters required in KNN is only defining the number of neighbors i.e. k.After this the KNN model is applied with the optimal parameters and accuracy is checked using different libraries such as confusionMtarix which gives a cumulative results on the accuracy of the data along with Kappa value and many other.

2.  **Support Vector Classification:**
SVC or Support Vector Classification like KNN algorithm make use of Euclidean distance. The motive for using SVC is that it can generalize for a large set of data as SVC uses epsilon hyperplane to get the model parameters in a high dimensional space. We made use of radial basis function while defining the kernel as with the help of kernel the model is able to visualize the parameters in a high dimensional space and can give the values necessary for the model, to build support vectors.

####

### Evaluation of Regression Models:

####

1. **KNN (K-Nearest Neighbor)**:
KNN or K nearest Neighbor is a classification as well as Regression model, which takes into the Euclidean distance. KNN application is rather simple as compared to other Machine Learning methods, moreover the number of Hyper-parameters required in KNN is only defining the number of neighbors i.e. k.After this the KNN model is applied with the optimal parameters and accuracy is checked using different libraries such as confusionMtarix which gives a cumulative results on the accuracy of the data along with Kappa value and many other.

2.  **Support Vector Classification:**
SVC or Support Vector Classification like KNN algorithm make use of Euclidean distance. The motive for using SVC is that it can generalize for a large set of data as SVC uses epsilon hyperplane to get the model parameters in a high dimensional space. We made use of radial basis function while defining the kernel as with the help of kernel the model is able to visualize the parameters in a high dimensional space and can give the values necessary for the model, to build support vectors.


####

# Findings:
* Some of the findings brought up are shown below:

-	Pie Chart showing that peopleof all ages are equally affected by Covid-19, with elderly peoples mostly affected as shown 85+ age groups accounts as the second highest, thus showing that elderly people should be more concerned for their health.

![](https://github.com/neil996/Factors-affecting-Covid-19./blob/main/Rplot.png)

-	Respiratory disease with 27.5 % shows that, covid-19 contracted more to the patients with respiratory disorders, while the circulatory disease as the second highest. 

![](https://github.com/neil996/Factors-affecting-Covid-19./blob/main/newplot.png)

- Map showing different counties with Total New Deaths

![](https://github.com/neil996/Factors-affecting-Covid-19./blob/main/Rplot01.png)

- Statewise Data Distribution of New Cases and Total Deaths

![](https://github.com/neil996/Factors-affecting-Covid-19./blob/main/Rplot02.png)


