package controller;

import data.UserDAO;
import data.UserDAOImpl;
import gui.Main;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import model.User;

import java.io.IOException;
import java.net.URL;
import java.sql.SQLException;
import java.util.ResourceBundle;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * FXML Controller class
 *
 * @author user
 */
public class LoginPageController implements Initializable {

    public TextField txtFieldUserName;
    public TextField txtFieldPassword;
    public Label lblError;

    /**
     * Initializes the controller class.
     */
    private UserDAO usersDao;

    @Override
    public void initialize(URL url, ResourceBundle rb) {
        usersDao = new UserDAOImpl();
    }

    @FXML
    private void btnLoginClicked(ActionEvent event) {
        User user = null;

        try {
            user = usersDao.getUserByLogin(
                    txtFieldUserName.getText(),
                    txtFieldPassword.getText());
        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (user == null) {
            lblError.setText("Neplatný email nebo heslo");
            return;
        }

        try {
            System.out.println("Uživatel přihlášen");
            user.setPassword(txtFieldPassword.getText());
            MainDashboardPageController.setLoggedUser(user); //Nechci vytvářet controller konstruktor, protože to dělá fxml, tudíž předávám přes statiku
            Main.switchScene(getClass().getResource("/gui/MainDashboardPage.fxml"));

        } catch (IOException ex) {
            Logger.getLogger(LoginPageController.class.getName()).log(Level.SEVERE, null, ex);
        }
    } //Try to get login

}
