package com.example.web_console_handheld.model;

import org.mindrot.jbcrypt.BCrypt;

import java.util.Scanner;

public class AdminHashPass {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        System.out.print("Nhập username admin: ");
        String username = sc.nextLine();

        System.out.print("Nhập password admin: ");
        String password = sc.nextLine();

        System.out.print("Nhập fullname admin: ");
        String fullname = sc.nextLine();

        // Hash passwork admin
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

        System.out.println("\n====== COPY SQL NÀY ĐỂ INSERT VÀO DB======");
        System.out.println(
                "INSERT INTO admin(username, password, fullname) VALUES (" +
                        "'" + username + "', " +
                        "'" + hashedPassword + "', " +
                        "N'" + fullname + "');"
        );

    }
}
