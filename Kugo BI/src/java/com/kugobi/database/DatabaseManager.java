/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.kugobi.database;

/**
 *
 * @author Lecci Leonardo
 */
public class DatabaseManager {
    String URL="jdbc:mysql://localhost:3306/kugoinvoice";
    String user="root";
    String password="";
    
    public String returnURL(){
    return URL;
    }
    
    public String returnUser(){
    return user;
    }
    
    public String returnPassword(){
    return password;
    }
}
