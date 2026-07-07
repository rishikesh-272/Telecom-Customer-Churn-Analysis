-- ============================================================================
-- TELCO CHURN: COMPREHENSIVE EDA + PRODUCT INSIGHTS ANALYSIS
-- ============================================================================
-- Project: Identify churn drivers and frame retention strategies
-- Author: [Your Name] | Dataset: Kaggle Telco Customer Churn
-- ============================================================================

-- ============================================================================
-- SECTION 1: BASELINE METRICS
-- ============================================================================

-- Total Customer Base
SELECT 
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS overall_churn_rate,
    ROUND(SUM(TotalCharges), 2) AS lifetime_value_all_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN TotalCharges ELSE 0 END), 2) AS revenue_lost_to_churn
FROM customers;

-- Churned vs Retained Comparison
SELECT 
    Churn,
    COUNT(*) AS customer_count,
    ROUND(AVG(tenure), 2) AS avg_tenure_months,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charge,
    ROUND(AVG(TotalCharges), 2) AS avg_lifetime_value
FROM customers
GROUP BY Churn;

-- ============================================================================
-- SECTION 2: PRIMARY CHURN DRIVER #1 - CONTRACT TYPE
-- ============================================================================
-- INSIGHT: Contract flexibility is the #1 churn driver
-- KEY QUESTION: Does tenure/lock-in reduce switching behavior?

SELECT 
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate,
    ROUND(AVG(tenure), 2) AS avg_tenure,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charge,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN TotalCharges ELSE 0 END), 2) AS revenue_lost
FROM customers
GROUP BY Contract
ORDER BY churn_rate DESC;

-- ============================================================================
-- SECTION 3: PRIMARY CHURN DRIVER #2 - PRICE SENSITIVITY
-- ============================================================================
-- INSIGHT: Price is sticky with contract type — high-price month-to-month churn most
-- KEY QUESTION: Can we offset churn through bundled value?

SELECT 
    CASE 
        WHEN MonthlyCharges < 25 THEN 'Budget (<$25)'
        WHEN MonthlyCharges < 50 THEN 'Low-Mid ($25-50)'
        WHEN MonthlyCharges < 75 THEN 'Mid-High ($50-75)'
        ELSE 'Premium (>$75)'
    END AS price_segment,
    COUNT(*) AS total,
    ROUND(AVG(MonthlyCharges), 2) AS avg_charge,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_pct
FROM customers
GROUP BY price_segment
ORDER BY CASE 
    WHEN MonthlyCharges < 25 THEN 1
    WHEN MonthlyCharges < 50 THEN 2
    WHEN MonthlyCharges < 75 THEN 3
    ELSE 4 END;

-- Contract + Price Interaction (CRITICAL COMBINATION)
SELECT 
    Contract,
    CASE 
        WHEN MonthlyCharges < 50 THEN 'Low (<$50)'
        WHEN MonthlyCharges < 75 THEN 'Mid ($50-75)'
        ELSE 'High (>$75)'
    END AS price_tier,
    COUNT(*) AS total_customers,
    ROUND(AVG(MonthlyCharges), 2) AS avg_charge,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_pct,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN TotalCharges ELSE 0 END), 2) AS revenue_lost
FROM customers
GROUP BY Contract, price_tier
ORDER BY Contract, churn_pct DESC;

-- ============================================================================
-- SECTION 4: PRIMARY CHURN DRIVER #3 - SERVICE ADOPTION & STICKINESS
-- ============================================================================
-- INSIGHT: Multi-product customers have lower churn (habit formation)
-- KEY QUESTION: Which add-ons drive stickiness most?

-- 4A: Service Adoption Index
SELECT 
    CASE 
        WHEN OnlineSecurity = 'Yes' AND TechSupport = 'Yes' AND OnlineBackup = 'Yes' THEN '3 Services'
        WHEN (OnlineSecurity = 'Yes' AND TechSupport = 'Yes') 
          OR (OnlineSecurity = 'Yes' AND OnlineBackup = 'Yes')
          OR (TechSupport = 'Yes' AND OnlineBackup = 'Yes') THEN '2 Services'
        WHEN OnlineSecurity = 'Yes' OR TechSupport = 'Yes' OR OnlineBackup = 'Yes' THEN '1 Service'
        ELSE '0 Services (Internet Only)'
    END AS service_adoption,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_pct,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charge
FROM customers
GROUP BY service_adoption
ORDER BY CASE 
    WHEN service_adoption = '0 Services (Internet Only)' THEN 1
    WHEN service_adoption = '1 Service' THEN 2
    WHEN service_adoption = '2 Services' THEN 3
    ELSE 4 END;

-- 4B: Individual Service Impact
SELECT 
    'Online Security' AS service_type,
    OnlineSecurity AS has_service,
    COUNT(*) AS total,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_pct
FROM customers
GROUP BY OnlineSecurity
UNION ALL
SELECT 
    'Tech Support' AS service_type,
    TechSupport AS has_service,
    COUNT(*) AS total,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_pct
FROM customers
GROUP BY TechSupport
UNION ALL
SELECT 
    'Online Backup' AS service_type,
    OnlineBackup AS has_service,
    COUNT(*) AS total,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_pct
FROM customers
GROUP BY OnlineBackup
ORDER BY service_type, has_service DESC;

-- ============================================================================
-- SECTION 5: EARLY-STAGE RISK (ONBOARDING & FIRST 6 MONTHS)
-- ============================================================================
-- INSIGHT: New customers are vulnerable; poor onboarding = churn spike
-- KEY QUESTION: Can we improve first-6-month experience?

SELECT 
    CASE 
        WHEN tenure <= 6 THEN '0–6 months'
        WHEN tenure <= 12 THEN '7–12 months'
        WHEN tenure <= 24 THEN '13–24 months'
        WHEN tenure <= 36 THEN '25–36 months'
        WHEN tenure <= 60 THEN '37–60 months'
        ELSE '60+ months'
    END AS tenure_cohort,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charge
FROM customers
GROUP BY 
    CASE 
        WHEN tenure <= 6 THEN '0–6 months'
        WHEN tenure <= 12 THEN '7–12 months'
        WHEN tenure <= 24 THEN '13–24 months'
        WHEN tenure <= 36 THEN '25–36 months'
        WHEN tenure <= 60 THEN '37–60 months'
        ELSE '60+ months'
    END
ORDER BY churn_rate DESC;

-- New Customer Acquisition Risk (Month-to-Month + Early Tenure)
SELECT 
    COUNT(*) AS new_mth_to_mth_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN TotalCharges ELSE 0 END), 2) AS revenue_at_risk
FROM customers
WHERE Contract = 'Month-to-month' AND tenure <= 6;

-- ============================================================================
-- SECTION 6: INTERNET SERVICE QUALITY (Infrastructure Matters)
-- ============================================================================
-- INSIGHT: Fiber customers are stickier than DSL (better product)
-- KEY QUESTION: Should we invest in fiber expansion? What's ROI?

SELECT 
    InternetService,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate,
    ROUND(AVG(tenure), 2) AS avg_tenure,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charge
FROM customers
GROUP BY InternetService
ORDER BY churn_rate DESC;

-- Internet Service + Contract Interaction
SELECT 
    InternetService,
    Contract,
    COUNT(*) AS total,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_pct
FROM customers
GROUP BY InternetService, Contract
ORDER BY InternetService, churn_pct DESC;

-- ============================================================================
-- SECTION 7: DEMOGRAPHICS (Senior Citizens + Potential Support Gaps)
-- ============================================================================
-- INSIGHT: Senior citizens may need more support; identify service/price sensitivity
-- KEY QUESTION: Do seniors churn for different reasons (support vs. price)?

SELECT 
    CASE WHEN SeniorCitizen = 1 THEN 'Senior (65+)' ELSE 'Non-Senior' END AS age_group,
    COUNT(*) AS total,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_pct,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charge
FROM customers
GROUP BY SeniorCitizen;

-- Senior Citizens by Service Type (Are we meeting their needs?)
SELECT 
    CASE WHEN SeniorCitizen = 1 THEN 'Senior' ELSE 'Non-Senior' END AS age_group,
    InternetService,
    COUNT(*) AS total,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_pct
FROM customers
GROUP BY SeniorCitizen, InternetService
ORDER BY age_group, churn_pct DESC;

-- ============================================================================
-- SECTION 8: PAYMENT METHOD ANALYSIS (Friction in Billing?)
-- ============================================================================
-- INSIGHT: Manual payments (checks, bank transfer) may indicate disengagement
-- KEY QUESTION: Does autopay indicate higher engagement/lower churn?

SELECT 
    PaymentMethod,
    COUNT(*) AS total,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_pct
FROM customers
GROUP BY PaymentMethod
ORDER BY churn_pct DESC;

-- Payment Method + Contract (Early indicator of engagement)
SELECT 
    Contract,
    PaymentMethod,
    COUNT(*) AS total,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_pct
FROM customers
GROUP BY Contract, PaymentMethod
ORDER BY Contract, churn_pct DESC;

-- ============================================================================
-- SECTION 9: HIGH-RISK SEGMENT SCORING (ACTIONABLE TARGETING)
-- ============================================================================
-- INSIGHT: Combine risk factors to identify customers for proactive retention
-- KEY QUESTION: Who are our "save at any cost" customers?

-- 9A: Risk Segment Summary
SELECT 
    CASE 
        WHEN Contract = 'Month-to-month' AND tenure < 12 AND MonthlyCharges > 65 THEN 'CRITICAL'
        WHEN Contract = 'Month-to-month' AND tenure <= 6 THEN 'HIGH'
        WHEN Contract = 'Month-to-month' AND tenure <= 12 THEN 'MEDIUM-HIGH'
        WHEN tenure <= 6 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS risk_tier,
    COUNT(*) AS segment_size,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate,
    ROUND(SUM(CASE WHEN Churn = 'No' THEN MonthlyCharges ELSE 0 END), 2) AS retained_revenue,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN MonthlyCharges ELSE 0 END), 2) AS lost_revenue
FROM customers
GROUP BY risk_tier
ORDER BY CASE 
    WHEN risk_tier = 'CRITICAL' THEN 1
    WHEN risk_tier = 'HIGH' THEN 2
    WHEN risk_tier = 'MEDIUM-HIGH' THEN 3
    WHEN risk_tier = 'MEDIUM' THEN 4
    ELSE 5 END;

-- 9B: Revenue Impact by Risk Tier
SELECT 
    CASE 
        WHEN Contract = 'Month-to-month' AND tenure < 12 AND MonthlyCharges > 65 THEN 'CRITICAL'
        WHEN Contract = 'Month-to-month' AND tenure <= 6 THEN 'HIGH'
        WHEN Contract = 'Month-to-month' AND tenure <= 12 THEN 'MEDIUM-HIGH'
        WHEN tenure <= 6 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS risk_tier,
    ROUND(SUM(MonthlyCharges), 2) AS total_monthly_value_at_risk,
    ROUND(SUM(TotalCharges), 2) AS total_lifetime_value_at_risk,
    ROUND(SUM(MonthlyCharges) * 12, 2) AS annual_revenue_at_risk
FROM customers
WHERE Churn = 'Yes'
GROUP BY risk_tier
ORDER BY total_monthly_value_at_risk DESC;

-- ============================================================================
-- SECTION 10: ADVANCED - WINDOW FUNCTIONS (SQL DEPTH)
-- ============================================================================
-- These queries demonstrate advanced SQL skills for interviews

-- 10A: Rank customers by churn risk within contract type
SELECT 
    customerID,
    Contract,
    tenure,
    MonthlyCharges,
    OnlineSecurity,
    TechSupport,
    Churn,
    ROW_NUMBER() OVER (PARTITION BY Contract ORDER BY MonthlyCharges DESC, tenure ASC) AS risk_rank_in_contract,
    ROUND(MonthlyCharges / AVG(MonthlyCharges) OVER (PARTITION BY Contract), 2) AS price_premium_vs_contract_avg
FROM customers
WHERE Churn = 'Yes'
LIMIT 15;

-- 10B: Cumulative churn rate by tenure (Shows early-life churn acceleration)
SELECT 
    tenure,
    COUNT(*) AS customers_at_tenure,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_at_tenure,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_at_tenure,
    SUM(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)) OVER 
        (ORDER BY tenure) AS cumulative_churned,
    SUM(COUNT(*)) OVER 
        (ORDER BY tenure) AS cumulative_customers
FROM customers
GROUP BY tenure
ORDER BY tenure;

-- 10C: Percentile ranking of monthly charges within service adoption groups
SELECT 
    CASE 
        WHEN OnlineSecurity = 'Yes' AND TechSupport = 'Yes' AND OnlineBackup = 'Yes' THEN '3 Services'
        WHEN (OnlineSecurity = 'Yes' AND TechSupport = 'Yes') 
          OR (OnlineSecurity = 'Yes' AND OnlineBackup = 'Yes')
          OR (TechSupport = 'Yes' AND OnlineBackup = 'Yes') THEN '2 Services'
        WHEN OnlineSecurity = 'Yes' OR TechSupport = 'Yes' OR OnlineBackup = 'Yes' THEN '1 Service'
        ELSE '0 Services'
    END AS service_group,
    MonthlyCharges,
    PERCENT_RANK() OVER (PARTITION BY 
        CASE 
            WHEN OnlineSecurity = 'Yes' AND TechSupport = 'Yes' AND OnlineBackup = 'Yes' THEN '3 Services'
            WHEN (OnlineSecurity = 'Yes' AND TechSupport = 'Yes') 
              OR (OnlineSecurity = 'Yes' AND OnlineBackup = 'Yes')
              OR (TechSupport = 'Yes' AND OnlineBackup = 'Yes') THEN '2 Services'
            WHEN OnlineSecurity = 'Yes' OR TechSupport = 'Yes' OR OnlineBackup = 'Yes' THEN '1 Service'
            ELSE '0 Services'
        END 
        ORDER BY MonthlyCharges) AS price_percentile,
    Churn
FROM customers
LIMIT 20;

-- ============================================================================
-- SECTION 11: COMPOSITE INSIGHTS (MULTI-FACTOR ANALYSIS)
-- ============================================================================
-- Identify the "perfect storm" combination of churn factors

-- 11A: Worst-Case Scenario (All negatives)
SELECT 
    COUNT(*) AS worst_case_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate,
    ROUND(SUM(MonthlyCharges), 2) AS revenue_exposure
FROM customers
WHERE Contract = 'Month-to-month' 
  AND tenure <= 12 
  AND OnlineSecurity = 'No'
  AND TechSupport = 'No'
  AND MonthlyCharges > 50;

-- 11B: Best-Case Scenario (All positives)
SELECT 
    COUNT(*) AS best_case_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate,
    ROUND(AVG(tenure), 2) AS avg_tenure
FROM customers
WHERE Contract IN ('One year', 'Two year')
  AND OnlineSecurity = 'Yes'
  AND TechSupport = 'Yes'
  AND OnlineBackup = 'Yes';

-- ============================================================================
-- SECTION 12: ACTIONABLE METRICS FOR STRATEGY
-- ============================================================================
-- Answers: "What levers do we pull?"

-- 12A: Upgrade Opportunity (Month-to-Month → Longer Contract)
SELECT 
    COUNT(*) AS mth_to_mth_customers,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_revenue_per_customer,
    ROUND(SUM(MonthlyCharges), 2) AS total_monthly_revenue_at_risk,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS current_churn_rate,
    '-> Potential 1-Year Contract Upgrade' AS retention_lever
FROM customers
WHERE Contract = 'Month-to-month' AND Churn = 'No';

-- 12B: Service Bundle Opportunity (Low service adoption)
SELECT 
    COUNT(*) AS low_adoption_customers,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charge,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate,
    '-> Cross-sell Tech Support + Security' AS bundling_opportunity
FROM customers
WHERE (OnlineSecurity = 'No' OR TechSupport = 'No') 
  AND MonthlyCharges > 50
  AND Churn = 'No';

-- 12C: Fiber Expansion ROI (DSL → Fiber Migration)
SELECT 
    'DSL' AS current_service,
    COUNT(*) AS dsl_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS current_churn_rate,
    (SELECT ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) 
     FROM customers WHERE InternetService = 'Fiber optic') AS fiber_churn_rate,
    ROUND(SUM(MonthlyCharges), 2) AS revenue_from_dsl
FROM customers
WHERE InternetService = 'DSL' AND Churn = 'No';

-- ============================================================================
-- END OF ANALYSIS
-- ============================================================================
