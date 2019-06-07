import numpy as np
import pandas as pd 
import xlrd
from pandas import ExcelWriter
from pandas import ExcelFile
import matplotlib as cm
import matplotlib.pyplot as plt
import plotly as py
import plotly
import cufflinks as cf
import plotly.tools as tls
%matplotlib inline
import plotly.graph_objs as go
from plotly.offline import download_plotlyjs, init_notebook_mode, plot, iplot
plotly.offline.init_notebook_mode() 

starts = pd.read_excel('batch_extra.xlsx',sheet_name='No_Startups',header=0,index_col=0)
shutdowns = pd.read_excel('batch_extra.xlsx',sheet_name='No_Shutdowns',header=0,index_col=0)
total_hr = pd.read_excel('batch_extra.xlsx',sheet_name='Total_hr_On',header=0,index_col=0)
hr_min = pd.read_excel('batch_extra.xlsx',sheet_name='No_hr_min',header=0,index_col=0)
hr_full = pd.read_excel('batch_extra.xlsx',sheet_name='No_hr_full',header=0,index_col=0)

cost = pd.read_excel('batch_Cost.xlsx',sheet_name='TotalSystemCost',header=2,index_col=0)
diff = pd.read_excel('batch_Cost.xlsx',sheet_name='Savings',header=2,index_col=0)
mgap = pd.read_excel('batch_Cost.xlsx',sheet_name='MIPGAP',header=2,index_col=0)
savings = pd.read_excel('batch_Cost.xlsx',sheet_name='Savings-MIPGAP',header=2,index_col=0)

iidx = ["Upgrade "+str(i)[:-5]for i in starts.index.values ]
idx[0] = 'Base'
for i in range(0,9):
# i =1
    fig = tls.make_subplots(rows=2, cols=1,subplot_titles=('Changes in Operations', 'Change in Net Revenue '))

    new = pd.DataFrame(columns=['full','mid','min'],index =total_hr.index )
    new.iloc[:,0] = hr_full.iloc[:,i].values
    new.iloc[:,1] = total_hr.iloc[:,i].values - hr_full.iloc[:,i].values - hr_min.iloc[:,i].values
    new.iloc[:,2] = hr_min.iloc[:,i].values
    trace = []
    trace.append(go.Bar(
        x=idx,
        y=new['full'].values,
        name='Full Load',

        marker=dict(
        color='rgba(219, 64, 82, 0.7)',
        line=dict(
            color='rgba(219, 64, 82, 0.7)',
            width=2,
        ))
    ))
    trace.append(go.Bar(
        x=idx,
        y=new['mid'].values,
        name='In Between',
        marker=dict(
            color='rgba(55, 128, 191, 0.7)',
            line=dict(
                color='rgba(55, 128, 191, 0.7)',
                width=2,
            ))

    ))
    trace.append(go.Bar(
        x=idx,
        y=new['min'].values,
        name='Minimum Load',
        marker=dict(
            color='rgba(50, 171, 96, 0.7)',
            line=dict(
                color='rgba(50, 171, 96, 1.0)',
                width=2,
            ))
    ))
    trace.append(go.Scatter(
            y=starts.iloc[:,i].values,
            x = idx,
            yaxis='y3',
            marker = dict(
                size = 20,
                color = 'rgba(244, 185, 66, .8)', 
                ),
            name='Starts'
    ))
    trace.append(go.Scatter(
    #         {type =
            y=shutdowns.iloc[:,i].values,
            x = idx,
            yaxis='y3',
            marker = dict(
                symbol ='triangle-up',
                size = 20,
                color = 'rgba(232, 64, 212, .8)', 
                ),
            name='Shutdowns',
    ))
    fig.append_trace(trace[0], 1, 1)
    fig.append_trace(trace[1], 1, 1)
    fig.append_trace(trace[2], 1, 1)
    fig.append_trace(trace[3], 1, 1)
    fig.append_trace(trace[4], 1, 1)
    sheet_names =['Forney1_IMR','Forney2_IMR','Lamar1_IMR','Lamar2_IMR','Rio_Nogales_IMR','Barney_IMR','Bastrop_IMR','Odessa1_IMR','Odessa2_IMR']
    imr = pd.read_excel('batch_IMR.xlsx',sheet_name=sheet_names[i],header=2,index_col=0,usecols = 'A:M')
    imr = imr.drop(index=imr.index[299:300])
    inc_imr = pd.read_excel('batch_IMR.xlsx',sheet_name=sheet_names[i],skiprows = 2,usecols = 'O:Z')
    inc_imr = inc_imr.drop([299,300])
    imr.iloc[:,:] = inc_imr.values

    trace1 = go.Bar(
        x=idx,
        y=imr.sum().values,
        name='Revenue',
        showlegend = False,
        marker=dict(
            color='rgba(50, 171, 96, 0.7)',
            line=dict(
                color='rgba(50, 171, 96, 1.0)',
                width=2,
            ))
    )
    fig.append_trace(trace1, 2, 1)

    fig['data'][3].update(yaxis='y3')
    fig['data'][4].update(yaxis='y3')
    # fig['data'][3].update(yaxis='y4')

    fig['layout'].update(
        height=1000, width=1600,
        legend=dict(x=1, y=0.5),
        barmode='stack',
        title = ' Visulizating Utilization and Revenue of %s'%(starts.columns.values[i]),
        xaxis1 =dict(title = 'Different Upgrade Cases'),
        xaxis2 =dict(title = 'Different Upgrade Cases'),
        yaxis1=dict(
            title='Total Operating Hours',
            mirror= True, 
            showline= True, 
            ticklen= 4, 
            zeroline= False
        ),
        yaxis2=dict(
    #         range= [-300000, 350000],
            title= 'Change in Revenue($)',
            mirror= True, 
            showline= True, 
            ticklen= 4, 
            zeroline= True
        ),
        yaxis3=dict(
            title='Number of Starts or Shutdowns',
    #             range= [0, max(max(starts.iloc[:,i-1]),max(shutdowns.iloc[:,i-1]))+30],
            overlaying='y1',
            side='right',
            showgrid= False, 
            ticklen= 4, 
            zeroline= False
        )
    )
    # fig = go.Figure(data=data, layout=layout)
    plot(fig, filename='Operation_analysis_%s.html'%(starts.columns.values[i]))
    # 

    
idx = ["Upgrade "+str(i)[:-5]for i in starts.index.values ]
idx[0] = 'Base'
for i in range(0,9):
    trace1 = []
    sheet_names =['Forney1_IMR','Forney2_IMR','Lamar1_IMR','Lamar2_IMR','Rio_Nogales_IMR','Barney_IMR','Bastrop_IMR','Odessa1_IMR','Odessa2_IMR']
    imr = pd.read_excel('batch_IMR.xlsx',sheet_name=sheet_names[i],header=2,index_col=0,usecols = 'A:M')
    imr = imr.drop(index=imr.index[299:300])
    inc_imr = pd.read_excel('batch_IMR.xlsx',sheet_name=sheet_names[i],skiprows = 2,usecols = 'O:Z')
    inc_imr = inc_imr.drop([299,300])
    imr.iloc[:,:] = inc_imr.values
    for j in range(0,11):
        trace1.append(go.Box(
            y = imr.iloc[:,j+1].values,
            name = idx[j+1],
            boxpoints = 'outliers',
            showlegend = False,
            marker = dict(
                color = 'rgb(7,40,89)'),
        #         width =10,
                line = dict(
                    color = 'rgb(7,40,89)')))

    layout = go.Layout(
        title = "Distribution of Change in IMR for %s"%(starts.columns.values[i]),
        height=600, width=1500,
        xaxis1 =dict(title = 'Different Upgrade Cases'),
        yaxis=dict(
            title='Change in Revenue ($)'
    #         range= [0, 160000]
        )
    )
    fig = go.Figure(data=trace1,layout=layout)
    plot(fig, filename='IMR_analysis_%s.html'%(starts.columns.values[i]))

trace3 = []
idx = ["Upgrade "+str(i)[:-5]for i in starts.index.values ]
idx[0] = 'Base'
for j in range(0,11):
    trace3.append(go.Box(
        y = -mgap.iloc[:,j].values,
        name = idx[j],
        boxpoints = 'outliers',
        showlegend = False,
        marker = dict(
            color = 'rgba(50, 171, 96, 0.7)'),
    #         width =10,
            line = dict(
                color = 'rgba(50, 171, 96, 1)')))
layout = go.Layout(
    title = "Distribution MIP Gap",
    height=600, width=1500,
    xaxis1 =dict(title = 'Different Upgrade Cases'),
    yaxis=dict(
        title='Error',
        range= [0, 50000]
    )
)
fig = go.Figure(data=trace3,layout=layout)
plot(fig, filename='MIPGAP_analysis.html')

trace = []
trace3 = []
idx = ["Upgrade "+str(i)[:-5]for i in starts.index.values]
idx[0] = 'Base'
fig = tls.make_subplots(rows=2, cols=1,subplot_titles=('Distribution of Daily Cost savings to ISO', 'Total Savings to the System over 300 days',))
for i in range(0,11):
    trace.append(go.Box(
        y = savings.iloc[:,i+1].values,
        name = idx[i+1],
        boxpoints = 'outliers',
        showlegend = False,
        marker = dict(
            color = 'rgb(107,174,214)'),
    #         width =10,
            line = dict(
                color = 'rgb(107,174,214)')))
    trace3.append(go.Box(
        y = -mgap.iloc[:,i+1].values,
        name = idx[i+1],
        boxpoints = 'outliers',
        marker = dict(
            color = 'rgb(107,174,214)'),
    #         width =10,
            line = dict(
                color = 'rgb(107,174,214)')))
    fig.append_trace(trace[i], 1, 1)
#     fig.append_trace(trace3[i], 3, 1)
# data = trace

trace2 = go.Bar(
    x=idx[1:],
    y=savings.sum().values[1:],
    name = "Total Savings",
    showlegend = False,
    marker=dict(
        color='rgba(50, 171, 96, 0.7)',
        line=dict(
            color='rgba(50, 171, 96, 1.0)',
            width=2,
        )
    )
)
# layout = go.Layout(
#     title = "Box Plot Styling Outliers",
#     height=600, width=1200,
#     yaxis=dict(
#         range= [0, 160000]
#     )
# )


fig.append_trace(trace2, 2, 1)
fig['layout'].update(
#     title = "Analysis of Cost Savings to",
    height=800, width=1500,
    yaxis=dict(
        showline= True,
        title='Average Cost Savings ($/Day)',
        range= [0, 160000]
    ),
    yaxis2=dict(
        showline= True,
        title='Annual Cost Savings ($)'
    )
)
# fig = go.Figure(data=data, layout=layout)
plot(fig, filename='Cost_Savings_analysis.html')


