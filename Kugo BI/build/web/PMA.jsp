<%-- 
    Document   : PMA
    Created on : 15-mag-2018, 20.01.43
    Author     : Leonardo
--%>
<%@page import="com.kugobi.service.GeneralService"%>
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
<jsp:include page="WEB-INF/tpls/PMAHeader.jsp" />
<%

    if (session == null) {
        //Sessione non esistente, inoltro alla pagina di login
        response.sendRedirect("Login.jsp");
    } else {
        if (session.getAttribute("businessName") == null) {
            response.sendRedirect("Login.jsp");
        }
    }
    GeneralService GS = new GeneralService();
    DatabaseManager db = new DatabaseManager();
    String varImponibileTotString = null;
    Double varImponibileTot = 0.0;
    String imponibile = null;
    String a = "";
    double b = 0;
    boolean entro = false;
    Double netIncome = 0.0;
    Double revenue = 0.0;
    Double NetPM = 0.0;
    ArrayList<String> dateA = new ArrayList<String>();
//tot income
    Connection conn = DriverManager.getConnection(db.returnURL(), db.returnUser(), db.returnPassword());
    PreparedStatement stt = conn.prepareStatement("SELECT SUM(fatture_vendita.imponibile) as totImponibile FROM fatture_vendita");
    ResultSet resultSett = stt.executeQuery();
    if (resultSett.next()) {
        varImponibileTotString = resultSett.getString("totImponibile");
        varImponibileTot = Double.valueOf(varImponibileTotString);
    }
    conn.close();
    //tot expenses
    Connection conc = DriverManager.getConnection(db.returnURL(), db.returnUser(), db.returnPassword());
    PreparedStatement stc = conc.prepareStatement("SELECT SUM(tab.spese) as speseTot FROM (SELECT SUBSTRING(fatture_vendita.data , 4 ,2) as dataImp, righe_fattura_vendita.codice as codiceProd, SUM(prodotti.prezzo_acquisto*righe_fattura_vendita.qta) as spese  FROM righe_fattura_vendita, prodotti, fatture_vendita WHERE righe_fattura_vendita.codice_ft=fatture_vendita.codice AND righe_fattura_vendita.codice=prodotti.codice  GROUP BY fatture_vendita.data ORDER BY dataImp) as tab");
    ResultSet resultSetc = stc.executeQuery();
    Gson gsonYearCost = new Gson();
    Map<Object, Object> mapYearCost = null;
    List<Map<Object, Object>> listYearCost = new ArrayList<Map<Object, Object>>();
    a = "";
    b = 0;
    entro = false;
    String varImponibile = "";
    String rounded = "";
    String prodotto = "";
    String qta = "";
    String prezzo = "";
    double totExpenses = 0.0;
    double q = 0.0;
    int i = 0;
    if (resultSetc.next()) {
        totExpenses = Double.valueOf(resultSetc.getString("speseTot"));
    }
    conc.close();

    String varRevenue = null;

    //tot revenue
    Connection connr = DriverManager.getConnection(db.returnURL(), db.returnUser(), db.returnPassword());
    PreparedStatement sttr = connr.prepareStatement("SELECT SUM(fatture_vendita.imponibile) as totImponibile FROM fatture_vendita");
    ResultSet resultSettr = sttr.executeQuery();
    if (resultSettr.next()) {
        varRevenue = resultSettr.getString("totImponibile");
        revenue = Double.valueOf(varRevenue);
    }
    connr.close();
    netIncome = varImponibileTot - totExpenses;
    NetPM = GS.Rounded((netIncome / revenue) * 100);

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
                        <a class="nav-link" href="${pageContext.request.contextPath}/Income.jsp">
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/PMA.jsp">
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
            <h1 style="text-align: center;">NET PROFIT MARGIN</h1>
            <hr/>
            <br>
            <div style="text-align: center;">
                <h3>
                    Cosa significa 'Net Profit Margin Ratio'
                </h3>
                <p>
                    Il margine di profitto netto (Net Profit Margin), o margine netto, è uguale all'utile netto diviso per
                    il totale delle entrate e rappresenta quanto profitto genera ogni euro di vendite.
                    Il Net Profit Margin è il rapporto tra l'utile netto (il reddito netto) per i ricavi,
                    il segmento di attività o il prodotto di un'azienda. <br>
                    Il Net Profit Margin è il rapporto tra utile netto per i ricavi di un'azienda.<br>
                </p>
                <h3 style="font-style: italic; color: #999;">
                    What is the 'Net Profit Margin Ratio'
                </h3>
                <p style="font-style: italic; color: #999;">
                    The net profit margin, or net margin, is equal to the net profit divided by total revenue and represents
                    how much profit each sales dollar generates. <br>
                    The net profit margin is the ratio between net profit or net income for a company's revenues,
                    business segment or product.<br>
                    The net profit margin illustrates the amount of every dollar raised by a company as revenue translates
                    into profit. 
                </p>
            </div>
            <hr/> 
            <div style="text-align: center;">
                <h3> Net Profit Margin generale  </h3>
                <p>
                    Questo indice è calcolato sullo storico completo dell'azienda.

                </p>
                <h3 style="font-style: italic; color: #999;"> Total Net Profit Margin ratio </h3>
                <p style="font-style: italic; color: #999;">
                    This ratio is calculated on a total view of the company, from the first invoice to the latest. 

                </p>
            </div>
            <div class="w3-row-padding w3-margin-bottom" style="padding-left: 33.3%">
                <div class="w3-IBAN ">
                    <div class="w3-container w3-blue w3-padding-16">
                        <div class="w3-center"></div>
                        <div class="w3-center">
                            <h3><%out.print(NetPM);%> %</h3>
                        </div>
                        <div class=" w3-center"><h4>NET PROFIT MARGIN RATIO (%)</h4></div>                        
                    </div>
                </div>
            </div>
            <br>
            <hr/>
            <br> 
        </main>
    </div>
</div>

<!-- Bootstrap core JavaScript
================================================== -->
<!-- Placed at the end of the document so the pages load faster -->
<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
<script>window.jQuery || document.write('<script src="../../assets/js/vendor/jquery-slim.min.js"><\/script>')</script>
<script src="../../assets/js/vendor/popper.min.js"></script>
<script src="../../dist/js/bootstrap.min.js"></script>

<!-- Icons -->
<script src="https://unpkg.com/feather-icons/dist/feather.min.js"></script>
<script>
    feather.replace()
</script>
<jsp:include page="WEB-INF/tpls/PMAHeader.jsp" />