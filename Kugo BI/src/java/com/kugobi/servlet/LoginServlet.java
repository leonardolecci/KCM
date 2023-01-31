package com.kugobi.servlet;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import com.kugobi.classes.User;
import com.kugobi.database.DatabaseManager;
import com.kugobi.service.CriptoService;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
@WebServlet(name = "login", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Resource(name = "java:app/jdbc/loginDatasource")
    private DataSource dataSource;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException, UnsupportedEncodingException {
        try {
            CriptoService cripto = new CriptoService();
            String paramName = req.getParameter("name");
            String paramPassword = req.getParameter("password");
            String email = null, p_iva = null, cod_fisc = null, businessName = null, pass = null, name = null;
            //System.out.println("Pass = " + paramPassword);

            //Connection connection = dataSource.getConnection();
            Class.forName("com.mysql.jdbc.Driver");
            DatabaseManager db = new DatabaseManager();
            Connection con = DriverManager.getConnection(db.returnURL(), db.returnUser(), db.returnPassword());
            PreparedStatement ps = con.prepareStatement("SELECT * FROM credenziali WHERE "
                    + "user = ?");
            ps.setString(1, paramName);
            ResultSet resultSet = ps.executeQuery();

            if (resultSet.next()) {
                //Email corretta
                //email = resultSet.getString("email");
                pass = resultSet.getString("password");
                // p_iva = resultSet.getString("p_iva");
                // cod_fisc = resultSet.getString("cod_fisc");
                name = resultSet.getString("user");
                //businessName = resultSet.getString("rag_soc");

            }
            if (paramName.equals(name)) {
                if (cripto.checkPassword(paramName, paramPassword)) {
                    //Email e password corrette

                    HttpSession oldSession = req.getSession(false);
                    if (oldSession != null) {
                        //Sessione già esistente
                        oldSession.invalidate();        //Invalido sessione esistente
                    }

                    HttpSession session = req.getSession(true);     //Creo nuova sessione
                    Connection conn = DriverManager.getConnection(db.returnURL(), db.returnUser(), db.returnPassword());

                    PreparedStatement pss = con.prepareStatement("SELECT email, p_iva, cod_fisc, rag_soc FROM azienda");

                    ResultSet resultSetPss = pss.executeQuery();
                    if (resultSetPss.next()) {
                        //Email corretta
                        email = resultSetPss.getString("email");
                        p_iva = resultSetPss.getString("p_iva");
                        cod_fisc = resultSetPss.getString("cod_fisc");
                        businessName = resultSetPss.getString("rag_soc");
                    }
                    User user = new User(email, pass, p_iva, cod_fisc, businessName);
                    session.setAttribute("email", user.getEmail());
                    session.setAttribute("password", user.getPassword());
                    session.setAttribute("p_iva", user.getP_iva());
                    session.setAttribute("cod_fisc", user.getCod_fisc());
                    session.setAttribute("businessName", user.getBusinessName());
                    session.setMaxInactiveInterval(120 * 60);

                    resp.sendRedirect("Index.jsp");

                } else {
                    //Email corretta ma password errata
                    req.setAttribute("message", "Password errata");
                    System.out.println("Password errata");
                    req.getRequestDispatcher("Login.jsp").forward(req, resp);
                }
            } else {
                //Email corretta ma password errata
                req.setAttribute("message", "nome errato");
                System.out.println("Password errata");
                req.getRequestDispatcher("Login.jsp").forward(req, resp);
            }

        } catch (SQLException | ClassNotFoundException ex) {
            Logger.getLogger(LoginServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        HttpSession oldSession = req.getSession(false);
        if (oldSession != null) {
            //Sessione già esistente
            oldSession.invalidate();        //Invalido sessione esistente
        }

        HttpSession session = req.getSession(true);

        resp.sendRedirect("Login.jsp");
    }

}
