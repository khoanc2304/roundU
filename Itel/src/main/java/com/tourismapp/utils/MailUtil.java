//package com.tourismapp.utils;
//
//import jakarta.mail.Authenticator;
//import jakarta.mail.Message;
//import jakarta.mail.MessagingException;
//import jakarta.mail.PasswordAuthentication;
//import jakarta.mail.Session;
//import jakarta.mail.Transport;
//import jakarta.mail.internet.InternetAddress;
//import jakarta.mail.internet.MimeMessage;
//import java.util.Properties;
//
//public class MailUtil {
//    // Thay đổi các thông tin này theo tài khoản thực tế
//    private static final String SMTP_HOST = "smtp.gmail.com";
//    private static final String SMTP_PORT = "587";
//    private static final String USERNAME = "your_email@gmail.com"; // Email gửi đi
//    private static final String PASSWORD = "your_app_password"; // App password hoặc mật khẩu ứng dụng
//
//    public static void sendMail(String to, String subject, String content) throws MessagingException, java.io.UnsupportedEncodingException {
//        Properties props = new Properties();
//        props.put("mail.smtp.auth", "true");
//        props.put("mail.smtp.starttls.enable", "true");
//        props.put("mail.smtp.host", SMTP_HOST);
//        props.put("mail.smtp.port", SMTP_PORT);
//
//        Session session = Session.getInstance(props, new Authenticator() {
//            @Override
//            protected PasswordAuthentication getPasswordAuthentication() {
//                return new PasswordAuthentication(USERNAME, PASSWORD);
//            }
//        });
//
//        Message message = new MimeMessage(session);
//        message.setFrom(new InternetAddress(USERNAME, "Itel Shop"));
//        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
//        message.setSubject(subject);
//        message.setContent(content, "text/html; charset=UTF-8");
//
//        Transport.send(message);
//    }
//} 