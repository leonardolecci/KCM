/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.kugobi.service;

import com.kugobi.database.DatabaseManager;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import org.apache.commons.codec.binary.Base64;
import org.springframework.security.crypto.bcrypt.BCrypt;
import sun.security.util.Password;

/**
 *
 * @author Daniele
 */
public class CriptoService {

    DatabaseManager db = new DatabaseManager();
    //https://docs.spring.io/spring-security/site/docs/5.0.0.M4/api/org/springframework/security/crypto/bcrypt/BCrypt.html
    BCrypt BCrypt = new BCrypt();

    public CriptoService() {
    }

    /**
     * Setta nuova password amministratore
     *
     * @throws SQLException se si verificano errori durante la connessione al db
     */
    public void createHash() throws SQLException {
        // questo metodo è utilizzato solo per settare la nuova password amministratore, non viene richiamato da alcuna altra classe
        String plain_password = "password";
        String pw_hash = BCrypt.hashpw(plain_password, BCrypt.gensalt());

        Connection con = DriverManager.getConnection(db.returnURL(), db.returnUser(), db.returnPassword());
        PreparedStatement st = con.prepareStatement("UPDATE credenziali SET password=? WHERE user='admin'");
        st.setString(1, pw_hash);
        st.executeUpdate();
        con.close();
    }

    /**
     * Return the hash stored in db
     *
     * @param user typed user
     * @return users' stored hash
     * @throws SQLException any sql exception
     */
    public String returnStoredHash(String user) throws SQLException, ClassNotFoundException {
        String stored_hash = "";
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection(db.returnURL(), db.returnUser(), db.returnPassword());
        PreparedStatement st = con.prepareStatement("SELECT password FROM credenziali WHERE user=?");
        st.setString(1, user);
        ResultSet resultSet = st.executeQuery();
        while (resultSet.next()) {
            stored_hash = resultSet.getString("password");
        }
        con.close();

        return stored_hash;
    }

    /**
     * Check that a plaintext password matches a previously hashed one
     *
     * @param user user
     * @param candidate_password typed password
     * @return true if password is correct or false if it is incorrect
     * @throws SQLException any sql exception
     */
    public boolean checkPassword(String user, String candidate_password) throws SQLException, ClassNotFoundException {
        boolean correct = false;

        String stored_hash = returnStoredHash(user);
        if (BCrypt.checkpw(candidate_password, stored_hash)) {
            correct = true;
        } else {
            correct = false;
        }

        return correct;
    }

    //AES methods
    private final String initVector = "encryptionIntVec";

    /**
     * Ritorna la chiave segreta dell'algoritmo AES
     *
     * @return chiave segreta
     * @throws IOException se si verificano errori durante la connessione al
     * database
     */
    public String getAESSecretKey() throws IOException {
        FileReader file = new FileReader("passphrase.txt");
        BufferedReader reader = new BufferedReader(file);
        String output = "";
        String s1 = reader.readLine();
        while (s1 != null) {
            output = s1;
            s1 = reader.readLine();
        }
        return output;
    }

    /**
     * Cripta una stringa
     *
     * @param value testo da criptare
     * @return testo criptato
     */
    public String EncryptAES(String value) {
        try {
            String secretKey = getAESSecretKey();
            IvParameterSpec iv = new IvParameterSpec(initVector.getBytes("UTF-8"));
            SecretKeySpec skeySpec = new SecretKeySpec(secretKey.getBytes("UTF-8"), "AES");

            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5PADDING");
            cipher.init(Cipher.ENCRYPT_MODE, skeySpec, iv);

            byte[] encrypted = cipher.doFinal(value.getBytes());
            return Base64.encodeBase64String(encrypted);

        } catch (Exception ex) {
            JFrame frame = new JFrame();
            JOptionPane.showMessageDialog(frame, ex, "Errore", JOptionPane.ERROR_MESSAGE);
        }
        return null;
    }

    /**
     * Decripta cipher text
     *
     * @param encrypted cipher text
     * @return plain text
     */
    public String DecryptAES(String encrypted) {
        try {
            String secretKey = getAESSecretKey();
            IvParameterSpec iv = new IvParameterSpec(initVector.getBytes("UTF-8"));
            SecretKeySpec skeySpec = new SecretKeySpec(secretKey.getBytes("UTF-8"), "AES");

            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5PADDING");
            cipher.init(Cipher.DECRYPT_MODE, skeySpec, iv);
            byte[] original = cipher.doFinal(Base64.decodeBase64(encrypted));

            return new String(original);
        } catch (Exception ex) {
            JFrame frame = new JFrame();
            JOptionPane.showMessageDialog(frame, ex, "Errore", JOptionPane.ERROR_MESSAGE);
        }

        return null;
    }

}
