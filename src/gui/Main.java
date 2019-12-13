package gui;

import data.OracleConnection;
import java.io.IOException;
import java.net.URL;
import java.sql.SQLException;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.stage.Stage;

/**
 *
 * @author user
 */
public class Main extends Application {

    public static Stage primaryStage;

    public static void switchScene(URL fxmlLocation) throws IOException {
        Parent parent = FXMLLoader.load(fxmlLocation);
        primaryStage.setScene(new Scene(parent));
    }

    @Override
    public void start(Stage stage) throws IOException {
        try {
            OracleConnection.getConnection();
        } catch (SQLException ex) {
            Alert alert = new Alert(Alert.AlertType.ERROR, "Nelze se připojit k databázi");
            alert.showAndWait();
            return;
        } //Pravděpodobně bysme měli vyhazovat vyjímky při vytváření DAO, ale tam jsem nechal jen zalogování
        primaryStage = stage;
        Parent root = FXMLLoader.load(getClass().getResource("AdministrationPage.fxml"));
        Scene scene = new Scene(root);

        primaryStage.setTitle("Sociální síť");
        primaryStage.setScene(scene);
        primaryStage.show();

    }

    @Override
    public void stop() throws SQLException {
        OracleConnection.closeConnection(true);
        System.out.println("Stage is closing");
    }

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        launch(args);
    }

}
