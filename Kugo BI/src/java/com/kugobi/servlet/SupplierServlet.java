/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.kugobi.servlet;

import com.kugobi.classes.Supplier;
import java.io.IOException;
import java.io.PrintWriter;
import static java.lang.System.out;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

/**
 *
 * @author Leonardo
 */
@WebServlet(name = "supplier", urlPatterns = {"/supplier"})
public class SupplierServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            
            String businessName = null;
            String p_iva = null;
            String cod_fisc = null;
            String email = null;
            PrintWriter out = resp.getWriter();
            //Controllo se esiste una sessione (utente loggato)
            HttpSession session = req.getSession(false);
            if (session == null) {
                //Sessione non esistente, inoltro alla pagina di login
                resp.sendRedirect("Login.jsp");
            }

            Class.forName("com.mysql.jdbc.Driver");
            Connection connection = null;
            try {
                connection = DriverManager.getConnection("jdbc:mysql://localhost/kugoinvoice", "root", "");
            } catch (SQLException ex) {
                Logger.getLogger(CustomerServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            Statement statement = null;
            try {
                statement = connection.createStatement();
            } catch (SQLException ex) {
                Logger.getLogger(CustomerServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            ResultSet resultSet = null;
            try {
                resultSet = statement.executeQuery("select * from fornitori");
            } catch (SQLException ex) {
                Logger.getLogger(CustomerServlet.class.getName()).log(Level.SEVERE, null, ex);
            }

            String cod_fornitore = "";
            String rag_soc_fornitore = "";
            String p_iva_fornitore = "";
            String cod_fisc_fornitore = "";
            String indirizzo = "";
            String citta = "";
            String cap = "";
            String prov = "";
            String nazione = "";
            String telefono = "";
            String fax = "";
            String sito_web = "";
            String email_fornitore = "";
            String agente = "";
            String data_aggiunta = "";
            String banca = "";
            String iban = "";
            String bic_swift = "";

            List<Supplier> SupplierList = new ArrayList();
            try {
                while (resultSet.next()) {
                    cod_fornitore = resultSet.getString("cod_fornitore");
                    rag_soc_fornitore = resultSet.getString("rag_soc");
                    p_iva_fornitore = resultSet.getString("p_iva");
                    cod_fisc_fornitore = resultSet.getString("cod_fisc");
                    indirizzo = resultSet.getString("indirizzo");
                    citta = resultSet.getString("citta");
                    cap = resultSet.getString("cap");
                    prov = resultSet.getString("prov");
                    nazione = resultSet.getString("nazione");
                    telefono = resultSet.getString("telefono");
                    fax = resultSet.getString("fax");
                    sito_web = resultSet.getString("sito_web");
                    email_fornitore = resultSet.getString("email");
                    agente = resultSet.getString("agente");
                    data_aggiunta = resultSet.getString("data_aggiunta");
                    banca = resultSet.getString("banca");
                    iban = resultSet.getString("iban");
                    bic_swift = resultSet.getString("bic_swift");
                    Supplier s = new Supplier(cod_fornitore, rag_soc_fornitore, p_iva_fornitore, cod_fisc_fornitore, indirizzo, citta, cap, prov, nazione, telefono, fax, sito_web, email_fornitore, agente, data_aggiunta, banca, iban, bic_swift);
                    SupplierList.add(s);

                }

                connection.close();
            } catch (SQLException e) {
                out.println("<div  style='width: 50%; margin-left: auto; margin-right: auto; margin-top: 200px;'>Could not connect to the database. Please check if you have mySQL Connector installed on the machine - if not, try installing the same.</div>");
            }
            req.setAttribute("SupplierList", SupplierList);
            req.getRequestDispatcher("Supplier.jsp").forward(req, resp);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(CustomerServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

}
