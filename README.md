# Hospital Readmissions Analysis, Predictor, and Visualization 🏥 

**Project objective**: To develop a robust machine learning predictor for readmission risk among hospital patients. The projects goal is to help hospitals identify high-risk patients and implement preventative care strategies that reduce readmission rates and promote long-term wellness.
**Key Findings**: 
* The random forest model out preformed the logistic regression model on prediction power of Readmission patients while maintain overall accuracy of 73%
* SerumSodium held importance in all model conducted
* Hemoglobin and CardiacTroponin also held importance, altering between 2nd and 3rd on logistic models
* BetaBlockers took 2nd in random forest importance

       
### Tech & Methods ⚙️

![SQLite](https://img.shields.io/badge/sqlite-%2307405e.svg?style=for-the-badge&logo=sqlite&logoColor=white) ![Static Badge](https://img.shields.io/badge/Python%20-%20blue?style=for-the-badge&logo=Python&color=gold) ![Power Bi](https://img.shields.io/badge/power_bi-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)  ![Static Badge](https://img.shields.io/badge/Machine%20Learning%20-%20blue?style=for-the-badge)
* Python/JuypterNotebook
* SQL/DB SQLite
* PowerBI

**Methodology**: I performed an iterative model selection process, comparing Multiple Logistic Regression,  and Random Forests, utilizing multiple dataset alterations. 

**Research Limitations & Omitted Variables**: With alteration in model types, accuracy remained at around 73% with no improvement. Improvements were conducted to primarily improve accuracy of classifying readmissions, yet each model had trade offs within precision. Additional medication types could be linked to illnesses not measured, while certain illnesses within patients could also constitute constant treatment. 

---
### Repository Information 📄
This repository includes 3 files: README.md, ReadmissionQuery.sql, and HospitalReadmissionPrediction.ipynb
* READ.md is what you are reading now and explains information associated with the project.
* HospitalReadmissionPrediction.ipynb includes the code associate with creator of 73% accurate readmission calculator and python analyis
* ReadmissionQuery.sql contains the sql querys ran to determine key insights

---
### Data 🗃️ 
Hospital readmission data from Kaggle, including 57 measures of health for 8481 observations/events. 

[Link to Data](https://www.kaggle.com/datasets/ahmedwadood/hospital-readmission/code)

