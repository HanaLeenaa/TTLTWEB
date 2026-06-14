package com.example.web_console_handheld.dao;

import org.mindrot.jbcrypt.BCrypt;

public class TestBCrypt {
    public static void main(String[] args) {
        String codeXin = BCrypt.hashpw("staff", BCrypt.gensalt());
        System.out.println("\n================================================");
        System.out.println("CHUOI BAM XIN CUA BAN LA: " + codeXin);
        System.out.println("================================================\n");
    }
}