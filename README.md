# Hospital Readmissions Analysis, Predictor, and Visualization 🏥 

**Project objective**: To develop a robust machine learning predictor for readmission risk among hospital patients. 

* Performance: Accuracy was limited to  70% with the current dataset
  
* Top predictors: Using P-value analysis (p<0.01) and feature importance, two variables were identified as primary drivers of risk:
    1. Age: How old a patient is
    2. ChronicDiseaseCount: The number of disease a patients have that are continous.
       
### Tech & Methods ⚙️:

![SQLite](https://img.shields.io/badge/sqlite-%2307405e.svg?style=for-the-badge&logo=sqlite&logoColor=white) ![Static Badge](https://img.shields.io/badge/Python%20-%20blue?style=for-the-badge&logo=Python&color=gold) ![Power Bi](https://img.shields.io/badge/power_bi-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)  ![Static Badge](https://img.shields.io/badge/Machine%20Learning%20-%20blue?style=for-the-badge)
* Python/JuypterNotebook
* SQL/DB SQLite
* PowerBI

**Methology**: I preformed an interative model selection process, comparing Multiple Logistic Regression, Random Forests, and GXBoosting utilizing multiple dataset alterations. 

---
### Repository Information 📄:
This repository includes 3 files: README.md, Hospital Readmissions.ipynb, and HospitalReadmissions.sql
* READ.md is what you are reading now and explains information associated with the project.
* Hospital Readmissions.ipynb includes the code associate with creator of 70% accurate readmission calculator and python analyis
* HospitalReadmissions.sql contains the sql querys ran to determine key insights

---
Research Limitations & Omitted Variables: As the data seemed to be inconsistent patient to patient, a value of 0 for categories such as HeartRateMean often indicated a lack of record for said patients. Causing issues not only in the training of a model, but also in the test of said model to determine accuracy. When corrected the data lacked the ability to be significant in number of observations, hence the analysis and prediction was still run with the transparency with inconsistency. 

### Data: 
Hospital readmission data from Kaggle, including 57 measures of health for 8481 patients. 
[Link to Data](https://www.kaggle.com/datasets/ahmedwadood/hospital-readmission/code)

