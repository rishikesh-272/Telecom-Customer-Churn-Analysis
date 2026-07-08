# 📊 Telco Churn Analysis & Dashboard

**Interactive analysis of 7,043 telecom customers. Identified 5 churn drivers worth $1.6M+ annual retention impact.**

---

## 🎯 Quick Summary

| Metric | Value |
|--------|-------|
| **Customers Analyzed** | 7,043 |
| **Churn Rate** | 26.5% |
| **Retention Potential** | $1.6M+ annually |
| **Churn Drivers** | 5 identified |
| **Dashboard Pages** | 3 interactive |

---

## 🔥 Key Findings

### **1. Contract Type** (15x impact)
- Month-to-month: **42.7%** churn
- Two-year: **2.8%** churn
- **Action:** Contract upgrade incentives → **$447K retention**

### **2. Service Bundling** (7.8x impact)
- Internet only: **26.5%** churn
- 3+ services: **3.4%** churn
- **Action:** Bundle tech support + security → **$91K retention**

### **3. Onboarding Crisis** (10x impact)
- Months 0-6: **54.3%** churn
- Months 13+: **5%** churn
- **Action:** Proactive support @ weeks 2,4,6 → **$600K retention**

### **4. Fiber > DSL** (2.2x impact)
- Fiber: 11.6% churn | DSL: 25.8% churn
- **Action:** Fiber expansion → **$464K retention**

### **5. Payment Method** (3.5x impact)
- Checks: 45.3% churn | Autopay: 12.8% churn
- **Action:** Autopay incentive → **$218K retention**

---

## 📊 Dashboard Features

**3 Interactive Pages:**
- **Page 1:** KPI Summary (churn rate, revenue at risk, customer breakdown)
- **Page 2:** Churn Analysis (contract impact, service adoption, tenure cohorts)
- **Page 3:** Risk Segmentation (CRITICAL/HIGH/MEDIUM/LOW tiers with revenue impact)

**Interactivity:**
- Real-time filters (contract type, internet service, tenure range)
- Hover tooltips with exact values
- Mobile responsive
- Fully client-side (no backend needed)

---

## 🚀 Quick Start

### **View Dashboard** https://telecom-churn-analysis-dashboard.netlify.app/

---

## 🛠️ Technical Stack

- **SQL:** Advanced queries (CTEs, window functions, composite scoring)
- **Dashboard:** Claud AI + HTML5 + JavaScript + Chart.js + Tailwind CSS
- **Data:** 7,043 customers, 21 features
- **Performance:** Real-time filtering on 7K+ rows, zero lag

---

## 💡 Interview Talking Points

**"Walk me through your analysis:"**
> "Analyzed 7,043 telecom customers to identify churn drivers. Found 3 primary factors: contract flexibility (15x impact), service bundling (7.8x impact), and onboarding experience (new customers churn at 54% vs 5% after month 13). Built an interactive dashboard and quantified 5 retention levers totaling $1.6M+ annual impact. Would recommend A/B testing contract upgrade offers and proactive onboarding support."

**Key Numbers to Know:**
- Month-to-month churn: **42.7%** vs Two-year: **2.8%** (15x)
- 0 services churn: **26.5%** vs 3+ services: **3.4%** (7.8x)
- Early churn: **54.3%** (0-6 months) → Stabilizes at **5%** (month 13+)
- Revenue at risk: **$3.7M** annually from churned customers

---

## 📈 Skills Demonstrated

✅ Advanced SQL (window functions, CTEs, risk scoring)  
✅ Data analysis & cohort segmentation  
✅ Business impact quantification (ROI calculations)  
✅ Interactive dashboard design  
✅ Product thinking (retention strategy, risk targeting)  

---

## 🔗 Links

- **Dataset:** [Kaggle Telco Customer Churn](https://www.kaggle.com/blastchar/telco-customer-churn)
- **SQL Queries:** `analysis/telco_churn_advanced_analysis.sql` (40+ queries)
- **Detailed Findings:** `findings/INSIGHTS_AND_RECOMMENDATIONS.md`

---

## ✨ Next Steps

- [ ] View interactive dashboard
- [ ] Review SQL analysis queries
- [ ] Read detailed findings
- [ ] Try filtering by different segments

---

**Built for:** Data Analyst, BI Analyst, Product Analyst roles  
**Perfect for:** Flipkart, Swiggy, Zomato, Amazon, Microsoft  

Made with ❤️
