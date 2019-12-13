package controller;

import controller.enums.IMPORT_OPTION;
import data.FieldOfStudyDAO;
import data.FieldOfStudyDAOImpl;
import data.SubjectDAO;
import data.SubjectDAOImpl;
import javafx.application.Platform;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.collections.FXCollections;
import javafx.event.ActionEvent;
import javafx.fxml.Initializable;
import javafx.scene.control.*;
import model.Field;
import model.Subject;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.sql.SQLException;
import java.util.*;

public class ImportPageController implements Initializable {
    public TextArea txtAreaLog;
    public TextField txtFieldImport;
    public ComboBox<IMPORT_OPTION> comboBoxImport;
    public Label lblError;

    Set<Subject> dataSubjects = new HashSet<>();
    Set<Field> dataFields = new HashSet<>();

    private final SubjectDAO subjectDAO = new SubjectDAOImpl();
    private final FieldOfStudyDAO fieldOfStudyDAO = new FieldOfStudyDAOImpl();


    @Override
    public void initialize(URL location, ResourceBundle resources) {
        initComboBox();
    }

    private void initComboBox() {
        comboBoxImport.setItems(FXCollections.observableArrayList(IMPORT_OPTION.values()));

        comboBoxImport.getSelectionModel().selectedItemProperty().addListener((observableValue, oldValue, newValue) -> {
            switch (newValue) {
                case SUBJECTS:
                    txtFieldImport.setText("https://stag-ws.upce.cz/ws/services/rest2/predmety/getPredmetyByFakultaFullInfo?fakulta=FEI");
                    break;
                case FIELDS:
                    txtFieldImport.setText("https://stag-ws.upce.cz/ws/services/rest2/programy/getStudijniProgramy");
                    break;
                default:
                    break;
            }
        });
        comboBoxImport.getSelectionModel().select(0);
    }

    private JSONObject getJsonFromWebPage(String url) {
        try {
            URL oracle = new URL(url);
            HttpURLConnection conn = (HttpURLConnection) oracle.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Accept", "application/json");

            Reader in = new InputStreamReader(conn.getInputStream());

            return (JSONObject) JSONValue.parse(in);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void btnImportClicked(ActionEvent actionEvent) {
        txtAreaLog.clear();
        dataSubjects.clear();
        dataFields.clear();

        JSONObject json = getJsonFromWebPage(txtFieldImport.getText());

        if (comboBoxImport.getValue() == IMPORT_OPTION.SUBJECTS)
            importSubjects(json);
        else
            importFields(json);
    }


    private void importFields(JSONObject json) {
        JSONArray jArray = (JSONArray) json.get("programInfo");
        for (Object o : jArray) {
            JSONObject object = (JSONObject) o;
            Field newField = new Field(object.get("nazev").toString(), object.get("typ").toString());
            Platform.runLater(() -> txtAreaLog.appendText("Nalezen nový Obor: " + newField.toString() + "\n"));
            dataFields.add(newField);
        }
    }

    private void importSubjects(JSONObject json) {
        JSONArray jArray = (JSONArray) json.get("predmetInfo");
        for (Object o : jArray) {
            JSONObject object = (JSONObject) o;
            Subject newSubject = new Subject(object.get("nazev").toString(), object.get("nazevDlouhy").toString());
            Platform.runLater(() -> txtAreaLog.appendText("Nalezen nový předmět: " + newSubject.toString() + "\n"));
            dataSubjects.add(newSubject);
        }
    }

    public void btnClickConfirmInport(ActionEvent actionEvent) {
        lblError.setText("Přidávám...");
        Thread t = null;
        switch (comboBoxImport.getValue()) {
            case SUBJECTS:
                t = new Thread(() -> {
                    dataSubjects.forEach(x -> {
                        try {
                            subjectDAO.insertSubject(x);
                        } catch (SQLException e) {
                            System.out.println(e.getMessage());
                        }
                    });
                    Platform.runLater(() -> lblError.setText("Data přidána"));
                });
                break;
            case FIELDS:
                t = new Thread(() -> {
                    dataFields.forEach(x -> {
                        try {
                            fieldOfStudyDAO.insertField(x);
                        } catch (SQLException e) {
                            System.out.println(e.getMessage());
                        }
                    });
                    Platform.runLater(() -> lblError.setText("Data přidána"));
                });
                break;
            default:
                break;
        }

        t.start();
    }
}
