package com.tourismapp.utils;

import javax.swing.JOptionPane;

public class ErrDialog {

    public static void showError(String errorMessage) {
        String fileName = new Throwable().getStackTrace()[1].getFileName();
        JOptionPane.showMessageDialog(null, errorMessage, "ERROR: " + fileName, JOptionPane.ERROR_MESSAGE);
    }

}
