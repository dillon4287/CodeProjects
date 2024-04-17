# %%
from get_data import SNP500, Connection
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.preprocessing import StandardScaler
from sqlalchemy import text
from datetime import datetime, timedelta
from sklearn.linear_model import LinearRegression
import pandas_market_calendars as mcal
from scipy.stats import norm
from StockSimulation import StockSimulation
import warnings
import yfinance
import matplotlib.pyplot as plt 
import seaborn as sns 
import requests 
from bs4 import BeautifulSoup as bs 
import yfinance

pd.options.mode.chained_assignment = None
sql7 = '''
        select p.*
        from 
            (
                select max(dt) dt, 
                    max(Sector) Sector
                from 
                    (select *,
                        row_number() over(partition by X.daynum, X.monthnum, X.yearnum) as dt_rank
                    from 
                        (SELECT p.*, 
                            s.Sector, 
                            s.Security, 
                            day(p.dt) daynum, 
                            month(p.dt) monthnum,
                            year(p.dt) yearnum
                        FROM Securities.stock_prices p
                        join snp500 as s 
                        on p.ticker=s.Symbol
                        where p.ticker='A') as X) as Y 
                group by Y.daynum, Y.monthnum, Y.yearnum
            ) as Z 
        join Securities.stock_prices p 
        on Z.dt=p.dt;
        '''

db_host = 'localhost'
db_user = 'dillon'
db_pass = 'Zelzah12'
db_name = 'Securities'
#%%

# def get_snp_companies():
#     link = 'http://en.wikipedia.org/wiki/List_of_S%26P_500_companies'
#     resp = requests.get(link).text
#     soup = bs(resp, 'html.parser')
#     table = soup.find('table')
#     tb = table.find('tbody')
#     tr = tb.find_all('tr')
#     rows = {}
#     i = 0
#     for r in tr:
#         col = []
#         data = r.find_all('td')
#         for ele in data:
#             if not isinstance(ele, str):
#                 e = ele.text.strip()
#                 col.append(e)
#             else:
#                 col.append(ele)
#             if len(col) == 8:
#                 rows[i] = col
#         i += 1
#     frame = pd.DataFrame.from_dict(rows, orient='index')
#     frame.columns = ['Symbol', 'Security', 'Sector', 'Sub-Industry',
#                         'Headquarters', 'DateAdded', 'CIK', 'Founded']
#     return frame 

# cos = get_snp_companies()
# stocks = yfinance.download(list(cos['Symbol']), interval='d')
        

    

#%%
c = Connection(db_host, db_user, db_pass, db_name)
daily_stock_data = pd.read_sql(text(sql7), c.conn)
test_dataset = daily_stock_data[daily_stock_data.ticker.isin(['A', 'AAPL', 'AAL', 'WBD', 'XRAY'])]

#%%
recent = daily_stock_data[daily_stock_data['dt'] > '2024-01-01']
stock_sim2 = StockSimulation(recent)
sims = stock_sim2.simulate_all_stock_price_states(5,5000)
chains = stock_sim2.create_chain(sims, 5, 5, .04)
stock_sim2.RankOptions(chains, '2024-04-19')
#%%
stock_sim2.best_calls[stock_sim2.best_calls.lastPrice < 2.5]
stock_sim2.best_puts[stock_sim2.best_puts.lastPrice < 2.5]

ax = sns.scatterplot(data=stock_sim2.best_puts[(stock_sim2.best_puts.value > .5) &
                                          (stock_sim2.best_puts.lastPrice < stock_sim2.best_puts.value)&
                                          (stock_sim2.best_puts.inTheMoney==True) &
                                          (stock_sim2.best_puts.lastPrice<1)], 
                x='lastPrice', y='value', hue='ticker')
sns.move_legend(ax, 'upper left', bbox_to_anchor=(1,1))
stock_sim2.best_calls[(stock_sim2.best_calls.value > .5) &
                                          (stock_sim2.best_calls.lastPrice < stock_sim2.best_calls.value)&
                                          (stock_sim2.best_calls.lastPrice<1)].head(50)

#%%

select_stocks_c = daily_stock_data[daily_stock_data.ticker.isin(['AFL', 'WMB','GNRC', 'BBWI'])]
select_stocks_p = daily_stock_data[daily_stock_data.ticker.isin(['ENPH', 'ALB','BIIB', 'FDX'])]

# %%
recent = daily_stock_data[daily_stock_data['dt'] > '2024-03-01']
test = StockSimulation(recent[recent['ticker']=='VLO'])
sims = test.simulate_all_stock_price_states(5,2500)
chains = test.create_chain(sims, 5,5,.04)
test.RankOptions(chains, '2024-04-12')
# %%
