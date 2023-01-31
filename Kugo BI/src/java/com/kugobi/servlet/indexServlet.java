/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.kugobi.servlet;

import com.kugobi.classes.Customer;
import java.io.IOException;
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
@WebServlet(name = "index", urlPatterns = {"/index"})
public class indexServlet extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String businessName = null;
        String p_iva = null;
        String cod_fisc = null;
        String email = null;
        //Controllo se esiste una sessione (utente loggato)
        HttpSession session = request.getSession(false);
        if (session == null) {
            //Sessione non esistente, inoltro alla pagina di login
            response.sendRedirect("Login.jsp");
        } else {
            if (session.getAttribute("businessName") == null) {
                response.sendRedirect("Login.jsp");
            } else {
                request.getRequestDispatcher("Index.jsp").forward(request, response);
            }
        }
    }
}
