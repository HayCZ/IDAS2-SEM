package controller;

import com.sun.org.apache.xpath.internal.operations.Or;
import controller.enums.TRANSACTION_TYPE;
import data.*;
import gui.AlertDialog;
import javafx.application.Platform;
import javafx.collections.FXCollections;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.*;
import model.*;

import java.net.URL;
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.Calendar;
import java.util.Collection;
import java.util.ResourceBundle;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ISKAMUserPageController {

    private ProductDAO productDAO = new ProductDAOImpl();
    private FoodMenuDAO foodMenuDAO = new FoodMenuDAOImpl();
    private OrderDAO orderDAO = new OrderDAOImpl();

    private User loggedUser;

    public TextField txtCVV;
    public ListView<Order> lVFoodOrders;
    public TextField txtExpiration;
    public ListView<Order> lVTodayOrders;
    public TextField txtCardNumber;
    public TextField txtMoneyToDeposit;
    public Label lblBalance;
    public ListView<Product> lVFoodMenu;
    public DatePicker dPFoodDate;

    private void refreshData() throws SQLException {
        getBalance();
        dPFoodDate.setValue(LocalDate.now());
        dateSearchChanged(null);
        new Thread(() -> {
            try {
                Collection<Order> orders = orderDAO.getOrdersByUser(loggedUser);
                Collection<Order> todayOrders = orderDAO.getTodayOrderByUser(loggedUser, Date.valueOf(LocalDate.now()));
                Platform.runLater(() -> {
                    lVFoodOrders.setItems(FXCollections.observableArrayList(orders));
                    lVTodayOrders.setItems(FXCollections.observableArrayList(todayOrders));

                });
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }).start();
    } //Reload data from db

    private void getBalance() {
        new Thread(() -> {
            try {
                float balance = orderDAO.getAccountBalance(loggedUser);
                Platform.runLater(() -> lblBalance.setText(balance + ",-"));
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }).start();
    } //Get balance from db

    public void initData(User loggedUser) {
        this.loggedUser = loggedUser;
        try {
            refreshData();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    } //Set user and get data

    @FXML
    private void dateSearchChanged(ActionEvent event) throws SQLException {
        lVFoodMenu.setItems(null);
        FoodMenu fm = foodMenuDAO.getFoodMenuByDate(Date.valueOf(dPFoodDate.getValue()));
        if (fm != null) {
            new Thread(() -> {
                try {
                    Collection<Product> products = productDAO.getProductByFoodMenu(fm);
                    Platform.runLater(() -> lVFoodMenu.setItems(FXCollections.observableArrayList(products)));
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }).start();
        }
    } //Get food menu on day

    @FXML
    private void btnPayClicked(ActionEvent actionEvent) {
        try {
            if(txtCardNumber.getLength() > 8 && txtCVV.getLength()>2 && txtExpiration.getLength() > 4 && txtMoneyToDeposit.getLength() > 0){
                orderDAO.createOrder(new Order(-1, loggedUser, null, TRANSACTION_TYPE.IN, Float.parseFloat(txtMoneyToDeposit.getText()), Date.valueOf(LocalDate.now()),"Dobití kreditu z karty " + txtCardNumber.getText()));
                AlertDialog.show("Věříme, že zadané údaje jsou platné a připsali jsme Vám požadovaný kredit. Pokud se jedná o podvod, předáme podnět orgánům činným v trestním řízení.", Alert.AlertType.INFORMATION);
                refreshData();
            } else {
                AlertDialog.show("Vámi zadané údaje nejsou platné!", Alert.AlertType.ERROR);
            }
        } catch (SQLException e){
            AlertDialog.show(e.toString(), Alert.AlertType.ERROR);
        }
    } //Pay

    @FXML
    private void btnFoodOrderClicked(ActionEvent actionEvent) {
        try {
            Product product = lVFoodMenu.getSelectionModel().getSelectedItem();
            if(product != null)
            {
                float balance = (orderDAO.getAccountBalance(loggedUser));
                if((balance - product.getPrice()) > 0) {
                    orderDAO.createOrder(new Order(-1, loggedUser, product, TRANSACTION_TYPE.OUT, product.getPrice() * -1, Date.valueOf(dPFoodDate.getValue()), product.getName()));
                    AlertDialog.show("Jídlo bylo úspěšně objednáno", Alert.AlertType.INFORMATION);
                    refreshData();
                } else {
                    AlertDialog.show("Nedostatek finančních prostředků.", Alert.AlertType.WARNING);
                }
            }
        } catch (SQLException e){
            AlertDialog.show(e.toString(), Alert.AlertType.ERROR);
        }
    } //Order
}
