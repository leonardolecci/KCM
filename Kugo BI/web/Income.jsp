<%-- 
    Document   : Income
    Created on : 4-giu-2018, 9.20.41
    Author     : Leonardo
--%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.kugobi.database.DatabaseManager"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%@page import="com.google.gson.Gson"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:include page="WEB-INF/tpls/IncomeHeader.jsp" />
<%
    Gson gsonObj = new Gson();
    Map<Object, Object> map = null;
    List<Map<Object, Object>> list = new ArrayList<Map<Object, Object>>();
    DatabaseManager db = new DatabaseManager();
    String imponibile = null;
    String data = null;
    String dataPointsBar = null;
    String dataPointsMonth = null;
    String dataPointsYear = null;
    String dataPointsMonthCost = null;
    String dataPointsYearCost = null;
    String dataPointsMonthd = null;
    String MonthCD = null;
    String MonthCDD = null;

    try {
        //Controllo se esiste una sessione (utente loggato)
        if (session == null) {
            //Sessione non esistente, inoltro alla pagina di login
            response.sendRedirect("Login.jsp");
        } else {
            if (session.getAttribute("businessName") == null) {
                response.sendRedirect("Login.jsp");
            }
        }

//FATTURATO PER GIORNO
        int yearCD = Calendar.getInstance().get(Calendar.YEAR) -1;
        String YearCD = String.valueOf(yearCD);
        int monthCD = Calendar.getInstance().get(Calendar.MONTH);
        if (monthCD < 10) {
            MonthCD = "0" + String.valueOf(monthCD);
            if (monthCD < 9) {
                MonthCDD = "0" + String.valueOf(monthCD + 1);
            } else {
                MonthCDD = String.valueOf(monthCD + 1);
            }

        } else {
            MonthCD = String.valueOf(monthCD);
            MonthCDD = String.valueOf(monthCD + 1);
        }
        Connection con = DriverManager.getConnection(db.returnURL(), db.returnUser(), db.returnPassword());
        PreparedStatement st = con.prepareStatement("SELECT SUM(imponibile) as totImp, SUBSTRING( data , 1 ,2) as dataImp FROM fatture_vendita WHERE SUBSTRING( data , 7 ,4)>? AND SUBSTRING( data , 4 ,2)>? AND SUBSTRING( data , 4 ,2)<=? GROUP BY dataImp");
        st.setString(1, YearCD);
        st.setString(2, MonthCD);
        st.setString(3, MonthCDD);
        ResultSet resultSet = st.executeQuery();
        String a = "";
        double b = 0;
        boolean entro = false;
        String cambiodata = "";
        String cambiavalore = "";
        String va = "";
        String varImponibile = "";
        String varData = "";
        int i = 0;
        while (resultSet.next()) {
            varData = resultSet.getString("dataImp");
            va = resultSet.getString("totImp");
            b = Double.valueOf(va);
            map = new HashMap<Object, Object>();
            map.put("y", b);
            map.put("label", varData);
            list.add(map);
            dataPointsBar = gsonObj.toJson(list);
        }
        con.close();

// FATTURATO PER MESE
        int year = Calendar.getInstance().get(Calendar.YEAR) - 1;
        String yearString = String.valueOf(year);
        Connection conn = DriverManager.getConnection(db.returnURL(), db.returnUser(), db.returnPassword());
        PreparedStatement stt = conn.prepareStatement("SELECT SUM(imponibile) as totImp, SUBSTRING( data , 4 ,2) as dataImp FROM fatture_vendita WHERE SUBSTRING( data , 7 ,4)>? GROUP BY dataImp");
        stt.setString(1, yearString);
        ResultSet resultSett = stt.executeQuery();

        Gson gsonMonth = new Gson();
        Map<Object, Object> mapMonth = null;
        List<Map<Object, Object>> listMonth = new ArrayList<Map<Object, Object>>();
        String max = null;
        int maxint = 0;
        a = "";
        b = 0;
        entro = false;
        cambiodata = "";
        cambiavalore = "";
        va = "";
        varImponibile = "";
        varData = "";
        //mesi anno corrente
        while (resultSett.next()) {
            varImponibile = resultSett.getString("totImp");
            b = Double.valueOf(varImponibile);
            varData = resultSett.getString("dataImp");
            mapMonth = new HashMap<Object, Object>();
            mapMonth.put("y", b);
            mapMonth.put("label", varData);
            listMonth.add(mapMonth);
            dataPointsMonth = gsonMonth.toJson(listMonth);
            if (Integer.valueOf(varData) > maxint) {
                max = varData;
            }
        }
        //mesi anno precedente
        year--;
        int yearCurr = Calendar.getInstance().get(Calendar.YEAR);
        String yearStringCurr = String.valueOf(yearCurr);
        String yearStringPrec = String.valueOf(year);
        Connection connd = DriverManager.getConnection(db.returnURL(), db.returnUser(), db.returnPassword());
        Gson gsonMonthd = new Gson();
        Map<Object, Object> mapMonthd = null;
        List<Map<Object, Object>> listMonthd = new ArrayList<Map<Object, Object>>();
        PreparedStatement sttd = connd.prepareStatement("SELECT SUM(imponibile) as totImp, SUBSTRING( data , 4 ,2) as dataImp FROM fatture_vendita WHERE SUBSTRING( data , 7 ,4)>? AND SUBSTRING( data , 7 ,4)<? AND SUBSTRING( data , 4 ,2)<=?  GROUP BY dataImp");
        sttd.setString(1, yearStringPrec);
        sttd.setString(2, yearStringCurr);
        sttd.setString(3, max);
        ResultSet resultSettd = sttd.executeQuery();
        while (resultSettd.next()) {
            varImponibile = resultSettd.getString("totImp");
            b = Double.valueOf(varImponibile);
            varData = resultSettd.getString("dataImp");
            mapMonthd = new HashMap<Object, Object>();
            mapMonthd.put("y", b);
            mapMonthd.put("label", varData);
            listMonthd.add(mapMonthd);
            dataPointsMonthd = gsonMonthd.toJson(listMonthd);
        }
        connd.close();
        conn.close();

        // FATTURATO PER ANNO
        Connection conna = DriverManager.getConnection(db.returnURL(), db.returnUser(), db.returnPassword());
        PreparedStatement stta = conna.prepareStatement("SELECT SUM(imponibile) as totImp, SUBSTRING( data , 7 ,4) as dataImp FROM fatture_vendita GROUP BY dataImp");
        ResultSet resultSetta = stta.executeQuery();

        Gson gsonYear = new Gson();
        Map<Object, Object> mapYear = null;
        List<Map<Object, Object>> listYear = new ArrayList<Map<Object, Object>>();
        a = "";
        b = 0;
        entro = false;
        cambiodata = "";
        cambiavalore = "";
        va = "";
        varImponibile = "";
        varData = "";
        while (resultSetta.next()) {
            varImponibile = resultSetta.getString("totImp");
            b = Double.valueOf(varImponibile);
            varData = resultSetta.getString("dataImp");
            mapYear = new HashMap<Object, Object>();
            mapYear.put("y", b);
            mapYear.put("label", varData);
            listYear.add(mapYear);
            dataPointsYear = gsonYear.toJson(listYear);
        }
        conna.close();
    } catch (SQLException ex) {
    }

%>
<nav class="navbar navbar-dark sticky-top bg-dark flex-md-nowrap p-0">
    <a class="navbar-brand col-sm-3 col-md-2 mr-0" href="#">Welcome, ${businessName}</a>

    <ul class="navbar-nav px-3">
        <li class="nav-item text-nowrap">
            <a class="nav-link" href="${pageContext.request.contextPath}/Logout">Sign out</a>
        </li>
    </ul>
</nav>

<div class="container-fluid">
    <div class="row">
        <nav class="col-md-2 d-none d-md-block bg-light sidebar">
            <div class="sidebar-sticky">
                <ul class="nav flex-column" >
                    <li class="nav-item">
                        <a class="nav-link " href="${pageContext.request.contextPath}/index">
                            <img src="${pageContext.request.contextPath}/img/config.png" style="width: 30px;height: 30px;"></img>
                            Home
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/Income.jsp">
                            <img src="${pageContext.request.contextPath}/img/arrow.png" style="width: 30px;height: 30px;"></img>
                            Income analytics
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/Cost.jsp">
                            <img src="${pageContext.request.contextPath}/img/arrow.png" style="width: 30px;height: 30px;"></img>
                            Cost analytics
                        </a>
                    </li>
                    <li class="nav-item" >
                        <a class="nav-link" href="${pageContext.request.contextPath}/PLDashboard.jsp">
                            <img src="${pageContext.request.contextPath}/img/arrow.png" style="width: 30px;height: 30px;"></img>
                            Profit and Loss 
                        </a>
                    </li>
                    <li class="nav-item ">
                        <a class="nav-link "  href="${pageContext.request.contextPath}/OpexToSales.jsp">
                            <img src="${pageContext.request.contextPath}/img/arrow.png" style="width: 30px;height: 30px;"></img>
                            Opex To Sales
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/PMA.jsp">
                            <img src="${pageContext.request.contextPath}/img/arrow.png" style="width: 30px;height: 30px;"></img>
                            Profit Margin
                        </a>
                    </li>
                    <li class="nav-item ">
                        <a class="nav-link " href="${pageContext.request.contextPath}/customer">
                            <img src="${pageContext.request.contextPath}/img/page.png" style="width: 30px;height: 30px;"></img>
                            Customers
                        </a>
                    </li>
                    <li class="nav-item ">
                        <a class="nav-link" href="${pageContext.request.contextPath}/supplier">
                            <img src="${pageContext.request.contextPath}/img/page.png" style="width: 30px;height: 30px;"></img>
                            Supplier
                        </a>
                    </li>
                    
                </ul>  
            </div>
        </nav>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 pt-3 px-4">
            <h1 style="text-align: center;">INCOME DASHBOARD</h1>
            <hr>
            <br>
            <div style="text-align: center;">
                <h4>
                    Una visuale migliore sulle entrate aziendali
                </h4>
                <p>
                    Nella Income Dashboard verranno visualizzati i guadagni aziendali per giorno, mese e per anno,
                    i grafici potranno essere stampati o salvati in diversi formati.<br>
                    Questa sezione è importante per visualizzare le entrate dell'azienda, ma è importante non dare troppo peso 
                    ai soli grafici di seguito rappresentati poiché essi non sono sufficienti per giudicare
                    la salute finanziaria di una azienda.<br>
                    Per avere una visione sui costi <a href="Cost.jsp"> clicca qui</a>
                </p>
                <h4 style="font-style: italic; color: #999;">
                    A better view on the company's income
                </h4>
                <p style="font-style: italic; color: #999;">
                    In the Income Dashboard graphics representing the company's income per days, months and years will be shown .<br>
                    This section is important to better understand the company's income, but it's fundamental not to give to much
                    importance to the following information as they are not enough to judge the comapny's health<br>
                    For a view on the company's cost please <a href="Cost.jsp"> click here</a>
                </p>
            </div>
            <br>
            <hr/>
            <br> 
            <div style="padding: 16px; height: 500px; width: 100%;text-align: center;">
                <h3>
                    Entrate per giorno
                </h3>
                
                <p>
                    Questo grafico rappresenta le entrate misurate su una frequenza giornaliera,
                    il grafico in questione rappresenta una visuale importante sull'andamento
                    delle entrate aziendali giornaliere del mese in corso.
                    <br>
                </p>
                <h4 style="font-style: italic; color: #999;">
                    Income per day
                </h4>
                <p style="font-style: italic; color: #999;">
                    This graphic represent the income on daily frequency,
                    the graphic also represent an important view on the company's income for each day of the current month.
                </p>
                <br>
                <div id="FatturatoPerGiorno" style="height: 370px; width: 100%; float: left;"></div>
                <script src="${pageContext.request.contextPath}/scripts/kbijs.min.js"></script>
            </div> 
            <hr/>
            <div style="padding: 16px; height: 500px; width: 100%;text-align: center;">
               <h3>
                    Entrate per mese
                </h3>
                
                <p>
                    Questo grafico rappresenta le entrate misurate su una frequenza mensile,
                    il grafico in questione rappresenta una visuale importante sull'andamento
                    delle entrate aziendali mensili del'anno in corso, comparandoli con i rispettivi mesi dell'anno precedente.
                    <br>
                </p>
                <h4 style="font-style: italic; color: #999;">
                    Income per month
                </h4>
                <p style="font-style: italic; color: #999;">
                    This graphic represent the income on monthly frequency, 
                    this is to have a wider but still specific ciew of the company's income, also comparing
                    each month of the current year with the corrseponding of the previous.
                </p>
                <br>
                <div id="FatturatoPerMese" style="height: 370px; width: 100%; float: left;"></div>
                <script src="${pageContext.request.contextPath}/scripts/kbijs.min.js"></script>
            </div>
            <hr/>
            <div style="padding: 16px; height: 500px; width: 100%;text-align: center;">
                <h3>
                    Entrate per anno
                </h3>
                
                <p>
                    Questo grafico rappresenta le entrate misurate su una frequenza annuale,
                    il grafico in questione rappresenta una visuale importante sull'andamento
                    delle entrate aziendali annuali degli ultimi anni.
                    <br>
                </p>
                <h4 style="font-style: italic; color: #999;">
                    Income per year
                </h4>
                <p style="font-style: italic; color: #999;">
                    This graphic represent the income on yearly frequency, 
                    this is an important view as compare income from different years,
                    giving the possibility to have a so much wider view on the company's invoice situation.
                </p>
                <br>
                <div id="FatturatoPerAnno" style="height: 370px; width: 100%; float: left;"></div>
                <script src="${pageContext.request.contextPath}/scripts/kbijs.min.js"></script>
            </div>
            <hr/>           

        </main>
    </div>
    <script type="text/javascript">
        window.onload = function () {
        <% if (dataPointsBar != null) { %>
            var chart = new CanvasJS.Chart("FatturatoPerGiorno", {
                animationEnabled: true,
                zoomEnabled: true,
                exportEnabled: true,
                title: {
                    text: "Income per day"
                },
                axisY: {
                    prefix: "€",
                    title: "INVOICE IN €"

                },

                data: [{
                        type: "spline", //change type to bar, line, area, pie, etc
                        dataPoints: <%out.print(dataPointsBar);%>
                    }]
            });
            chart.render();
        <% } else {
                out.print("no data was found!");
            }
        %>
        <% if (dataPointsMonth != null) { %>
            var chart = new CanvasJS.Chart("FatturatoPerMese", {
                animationEnabled: true,
                zoomEnabled: true,
                exportEnabled: true,
                title: {
                    text: "Income per month"
                },
                axisY: {
                    title: "Income in €",
                    prefix: "€"
                },
                toolTip: {
                    shared: true
                }, legend: {
                    cursor: "pointer",
                    itemclick: toggleDataSeries
                },
                toolTip: {
                    shared: true,
                    content: toolTipFormatter
                },
                data: [{
                        showInLegend: true,
                        color: "lightgreen",
                        type: "column",
                        name: "Invoice per month past year",
                        legendText: "Invoice per month past year",
                        dataPoints: <%out.print(dataPointsMonthd);%>
                    }
                    ,
                    {
                        type: "column",
                        color: "lightblue",
                        name: "Invoice per month current year",
                        legendText: "Invoice per month current year",
                        showInLegend: true,
                        dataPoints:<%out.print(dataPointsMonth);%>
                    }]
            });
            chart.render();
            function toolTipFormatter(e) {
                var str = "";
                var total = 0;
                var str3;
                var str2;
                for (var i = 0; i < e.entries.length; i++) {
                    var str1 = "<span style= \"color:" + e.entries[i].dataSeries.color + "\">" + e.entries[i].dataSeries.name + "</span>: <strong>" + e.entries[i].dataPoint.y + "</strong> <br/>";
                    total = e.entries[i].dataPoint.y + total;
                    str = str.concat(str1);
                }
                str2 = "<strong>" + e.entries[0].dataPoint.label + "</strong> <br/>";
                str3 = "";
                return (str2.concat(str)).concat(str3);
            }
            function toggleDataSeries(e) {
                if (typeof (e.dataSeries.visible) === "undefined" || e.dataSeries.visible) {
                    e.dataSeries.visible = false;
                } else {
                    e.dataSeries.visible = true;
                }
                chart.render();
            }

        <% } else {
                out.print("no data was found!");
            }
        %>
        <% if (dataPointsYear != null) { %>
            var chart = new CanvasJS.Chart("FatturatoPerAnno", {
                animationEnabled: true,
                zoomEnabled: true,
                exportEnabled: true,
                title: {
                    text: "Income per year"
                },
                axisY: {
                    prefix: "€",
                    title: "INVOICE IN €"
                },

                data: [{
                        type: "line", //change type to bar, line, area, pie, etc
                        dataPoints: <%out.print(dataPointsYear);%>
                    }]
            });
            chart.render();
        <% } else {
                out.print("no data was found!");
            }%>
        }
    </script>
    <jsp:include page="WEB-INF/tpls/IncomeFooter.jsp" />