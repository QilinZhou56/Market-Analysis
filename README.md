# Quantitative Market Analysis
  
## Project 1: Stock Price Movement Prediction with Monte Carlo Method and Random Forests

### Overview

This project features specialized code designed for predicting the stock price movement of the S&P 500 index, employing both Monte Carlo simulations and Random Forest algorithms. It also offers an introductory guide to web scraping, aimed at gathering essential qualitative market data such as financial news.

### Prediction Results

After running the Monte Carlo simulations and Random Forest model, the following predictions were obtained:

- Predicted Closing Price after 256 simulations: $5006.23
- Predicted Percent Increase after 1 Year: 9.6%
- Probability of Stock Price Increasing after 1 Year: 64.45%

### Project Structure
- **`Stock Market Prediction.ipynb`**: Jupyter Notebook containing code for stock price prediction using Monte Carlo simulations and Random Forests, integrating rolling averages and backtesting (Guide)
- **`app.py `**: GUI initiator
- **`display.py`**: Display Stock News through PySimpleGUI
- **`scraper.py`**: Scrape Stock News from https://finviz.com/
- **`time_series.py`**: Integrated Lagged Predictors and Oscillators (with Macro factors such as interest rate and exchange rate) to Random Forest Model

## Project 2: Customers and Products Analysis Using SQL

### Project Overview
This project contains SQL analysis of multiple markets. Using scale model car analytics as an example, we aim to analyze sales data from a scale model cars database to inform decision-making processes. The data encompasses various aspects of the business, including customer behavior, product performance, and sales trends. The ultimate goal is to optimize ordering strategies, tailor marketing efforts, and determine budget allocation for customer acquisition. 

### Database Schema
The database contains eight tables:
- `Customers`: Contains customer data.
- `Employees`: Information about all employees.
- `Offices`: Details of sales office locations.
- `Orders`: Records of customers' sales orders.
- `OrderDetails`: Line items for each sales order.
- `Payments`: Records of customers' payment history.
- `Products`: A list of scale model cars available.
- `ProductLines`: Categories of product lines.

### Key Questions
1. **Which Products Should We Order More Of Or Less Of?**
   - Analyze low stock levels and product performance to identify priority products for restocking.
2. **How Should We Tailor Marketing and Communication Strategies to Customer Behaviors?**
   - Identify VIP and less-engaged customers to customize marketing strategies accordingly.
3. **How Much Can We Spend on Acquiring New Customers?**
   - Determine the Customer Lifetime Value (LTV) to guide budget allocation for new customer acquisition.

### Analysis and Findings

### Problem 1: Product Ordering Strategy
- Found that Motorcycles and Vintage cars are the priority for restocking. They sell frequently, 
and they are the highest-performance products.

### Problem 2: Tailoring Marketing Strategies
- Identified VIP customers and less-engaged customers, suggesting targeted events and campaigns to boost loyalty and engagement, respectively.

### Problem 3: Customer Acquisition Budget
- Observed a decrease in new customers over time.
- Suggested budget: Approximately $1951.95 per new customer on marketing, based on the calculated LTV.
