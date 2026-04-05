package com.example.web_console_handheld.controller;

import com.example.web_console_handheld.dao.AuthDao;
import com.example.web_console_handheld.model.User;
import com.example.web_console_handheld.utils.PasswordUtil;

public class AuthService {
    AuthDao authDao = new AuthDao();
    public User checkLogin(String username, String password) {
        User user = authDao.getUserByUserName(username);
        if (user == null) return null;
        //kiem tra voi password da hash
        if (PasswordUtil.verify(password, user.getPassword())){
            //tài khoản bị khóa thì không cho login
            if (!user.isActive()){
                return null;
            }
            user.setPassword("");
            return user;
        }
        return null;
    }

    public boolean isBlocked(String username, String password) {
        User user = authDao.getUserByUserName(username);
        if (user == null) return false;

        if (PasswordUtil.verify(password, user.getPassword())){
            return !user.isActive();
        }
        return false;
    }
}
