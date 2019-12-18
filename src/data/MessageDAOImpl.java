package data;

import model.Group;
import model.Message;
import model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.Collection;
import java.util.logging.Level;
import java.util.logging.Logger;


public class MessageDAOImpl implements MessageDAO {

    private Connection conn;
    private UserDAO userDAO = new UserDAOImpl();
    private GroupDAO groupDAO = new GroupDAOImpl();
    private FileDAO fileDAO = new FileDAOImpl();

    public MessageDAOImpl() {
        try {
            conn = OracleConnection.getConnection();
        } catch (SQLException ex) {
            Logger.getLogger(MessageDAOImpl.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public Message getMessageById(int id) throws SQLException {
        PreparedStatement preparedStatement = conn.prepareStatement(
                "SELECT * FROM ZPRAVY WHERE ID_ZPRAVA= ?"
        );
        preparedStatement.setInt(1, id);

        ResultSet rs = preparedStatement.executeQuery();
        Message message = null;
        if (rs.next())
            message = getMessage(rs);

        preparedStatement.close();
        conn.commit();
        System.out.println("GetMessageById");
        return message;

    }

    @Override
    public Message getMessage(ResultSet rs) throws SQLException {
        Message newMessage = new Message(
                rs.getInt("id_zprava"),
                rs.getString("nazev"),
                rs.getString("telo"),
                userDAO.getUserById(rs.getInt("id_uzivatel_odesilatel")),
                userDAO.getUserById(rs.getInt("id_uzivatel_prijemce")),
                groupDAO.getGroupById(rs.getInt("id_skupina_prijemce")),
                rs.getDate("datum_vytvoreni"),
                rs.getInt("id_rodic"),
                fileDAO.getFileById(rs.getInt("id_souboru"))
        );
        return newMessage;
    } //Parser method return message

    @Override
    public Message getMessageWithLevel(ResultSet rs) throws SQLException {
        Message newMessage = new Message(
                rs.getInt("id_zprava"),
                rs.getString("nazev"),
                rs.getString("telo"),
                userDAO.getUserById(rs.getInt("id_uzivatel_odesilatel")),
                null,
                groupDAO.getGroupById(rs.getInt("id_skupina_prijemce")),
                rs.getDate("datum_vytvoreni"),
                rs.getInt("id_rodic"),
                fileDAO.getFileById(rs.getInt("id_souboru")),
                rs.getInt("Uroven")
        );
        return newMessage;
    } //Parser method return message with level

    @Override
    public Collection<Message> getAllMessages() throws SQLException {
        Collection<Message> collection = new ArrayList<>();

        Statement statement = conn.createStatement();
        ResultSet rs = statement.executeQuery(
                "SELECT * FROM ZPRAVY");

        while (rs.next()) {
            collection.add(getMessage(rs));
        }

        statement.close();
        System.out.println("GetAllMessages");
        return collection;
    }

    @Override
    public void insertMessage(Message message) throws SQLException {
        PreparedStatement preparedStatement = conn.prepareStatement(
                "INSERT INTO ZPRAVY(nazev, telo, datum_vytvoreni, "
                        + "id_uzivatel_odesilatel, id_skupina_prijemce, id_uzivatel_prijemce, ID_RODIC, ID_SOUBORU) "
                        + "VALUES (?,?,?,?,?,?,?,?)");
        preparedStatement.setString(1, message.getName());
        preparedStatement.setString(2, message.getContent());
        preparedStatement.setDate(3, message.getDate_created());
        preparedStatement.setInt(4, message.getSender().getId());

        if (message.getUser_receiver() != null) {
            preparedStatement.setNull(5, Types.INTEGER);
            preparedStatement.setInt(6, message.getUser_receiver().getId());
        } else {
            preparedStatement.setInt(5, message.getGroup_receiver().getId());
            preparedStatement.setNull(6, Types.INTEGER);
        } //Load receiver group or receiver user
        if (message.getParent() != 0) {
            preparedStatement.setInt(7, message.getParent());
        } else {
            preparedStatement.setNull(7, Types.INTEGER);
        } //If message has parent
        if (message.getAttached_file() != null) {
            preparedStatement.setInt(8, message.getAttached_file().getId());
        } else {
            preparedStatement.setNull(8, Types.INTEGER);
        } //if is attached file


        preparedStatement.executeUpdate();
        conn.commit();
        System.out.println("InsertMessage");
        preparedStatement.close();
    }

    @Override
    public void createMessage(Message message) throws SQLException {
        PreparedStatement preparedStatement = conn.prepareStatement(
                "INSERT INTO ZPRAVY(nazev, telo, datum_vytvoreni, "
                        + "id_uzivatel_odesilatel, id_skupina_prijemce, id_uzivatel_prijemce, ID_RODIC, ID_SOUBORU) "
                        + "VALUES (?,?,?,?,?,?,?,?)");
        preparedStatement.setString(1, message.getName());
        preparedStatement.setString(2, message.getContent());
        preparedStatement.setDate(3, message.getDate_created());
        preparedStatement.setInt(4, message.getSender().getId());

        if (message.getUser_receiver() != null) {
            preparedStatement.setNull(5, Types.INTEGER);
            preparedStatement.setInt(6, message.getUser_receiver().getId());
        } else {
            preparedStatement.setInt(5, message.getGroup_receiver().getId());
            preparedStatement.setNull(6, Types.INTEGER);
        } //Load receiver group or receiver user

        if (message.getParent() == 0) {
            preparedStatement.setNull(7, Types.INTEGER);
        } else {
            preparedStatement.setInt(7, message.getParent());
        } //If message has parent

        if (message.getAttached_file() == null) {
            preparedStatement.setNull(8, Types.INTEGER);
        } else {
            preparedStatement.setInt(8, message.getAttached_file().getId());
        } //if is attached file

        preparedStatement.executeUpdate();
        conn.commit();
        System.out.println("Message created");
        preparedStatement.close();
    }

    @Override
    public Collection<Message> getMessagesForChatBetween(User user1, User user2) throws SQLException {
        Collection<Message> collection = new ArrayList<>();

        PreparedStatement preparedStatement = conn.prepareStatement(
                "SELECT * FROM ZPRAVY z WHERE (z.id_uzivatel_odesilatel = ? OR z.id_uzivatel_PRIJEMCE = ?)\n"
                        + "AND (z.id_uzivatel_odesilatel = ? OR z.id_uzivatel_prijemce = ?) "
                        + "ORDER BY z.datum_vytvoreni");
        preparedStatement.setInt(1, user1.getId());
        preparedStatement.setInt(2, user1.getId());
        preparedStatement.setInt(3, user2.getId());
        preparedStatement.setInt(4, user2.getId());

        ResultSet rs = preparedStatement.executeQuery();
        //Načte zprávy kde je příjemce buď uživatel1 nebo 2 nebo je odesílatel uživatel1 nebo 2
        while (rs.next()) {
            Message zprava;
            if (rs.getInt("id_uzivatel_odesilatel") == user1.getId()) {
                zprava = new Message(
                        rs.getString("nazev"),
                        rs.getString("telo"),
                        user1,
                        user2,
                        null,
                        rs.getDate("datum_vytvoreni")
                ); //pokud je uživatel1 odesilatel, vytvoř tuto zprávu
            } else {
                zprava = new Message(
                        rs.getString("nazev"),
                        rs.getString("telo"),
                        user2,
                        user1,
                        null,
                        rs.getDate("datum_vytvoreni")
                );
            } //Pokud je uživatel1 příjemce, vytvoř tuto
            collection.add(zprava);
        } //Načte zprávy mezi dvouma uživatelama

        preparedStatement.close();
        System.out.println("GetMessagesForChatBetween");
        return collection;
    }

    @Override
    public Collection<Message> getMessagesForGroupChat(Group group) throws SQLException {
        Collection<Message> collection = new ArrayList<>();

        PreparedStatement preparedStatement = conn.prepareStatement(
                "SELECT * FROM ZPRAVY z\n" +
                        "join (select * from GETUZIVATELE) on ID_UZIVATEL = ID_UZIVATEL_ODESILATEL\n" +
                        "where ID_SKUPINA_PRIJEMCE = ?\n" +
                        "order by z.DATUM_VYTVORENI"
        );
        preparedStatement.setInt(1, group.getId());

        ResultSet rs = preparedStatement.executeQuery();
        while (rs.next()) {
            Message zprava = new Message(
                    rs.getInt("id_zprava"),
                    rs.getString("nazev"),
                    rs.getString("telo"),
                    userDAO.getUser(rs),
                    null,
                    group,
                    rs.getDate("datum_vytvoreni")
            );
            collection.add(zprava);
        }
        preparedStatement.close();
        System.out.println("getMessagesForGroupChat");
        return collection;
    }

    @Override
    public Collection<Message> getMessagesForGroupChatWithLevel(Group group) throws SQLException {
        Collection<Message> collection = new ArrayList<>();

        PreparedStatement preparedStatement = conn.prepareStatement(
                "SELECT * FROM GETZPRAVYHIERARCHICKY z\n" +
                        "where ID_SKUPINA_PRIJEMCE = ?"
        );
        preparedStatement.setInt(1, group.getId());

        ResultSet rs = preparedStatement.executeQuery();
        while (rs.next()) {
            collection.add(getMessageWithLevel(rs));
        }

        preparedStatement.close();
        System.out.println("getMessagesForGroupChatWithLevel");
        return collection;
    }

    @Override
    public Collection<Message> getMessagesForChatBetweenWithLevel(User user1, User user2) throws SQLException {
        Collection<Message> collection = new ArrayList<>();

        PreparedStatement preparedStatement = conn.prepareStatement(
                "SELECT * FROM GETZPRAVYHIERARCHICKY z\n" +
                        "WHERE (id_uzivatel_odesilatel = ? OR id_uzivatel_PRIJEMCE = ?)\n"
                        + "AND (id_uzivatel_odesilatel = ? OR id_uzivatel_prijemce = ?)"
        );
        preparedStatement.setInt(1, user1.getId());
        preparedStatement.setInt(2, user1.getId());
        preparedStatement.setInt(3, user2.getId());
        preparedStatement.setInt(4, user2.getId());

        ResultSet rs = preparedStatement.executeQuery();
        while (rs.next()) {
            collection.add(getMessageWithLevel(rs));
        }
        preparedStatement.close();
        System.out.println("getMessagesForChatBetweenWithLevel");
        return collection;
    }

    @Override
    public void updateMessage(Message message) throws SQLException {
        CallableStatement callableStatement = conn.prepareCall(
                "call update_zprava(?,?,?,?,?,?,?,?,?)"
        );
        callableStatement.setInt(1, message.getId());
        callableStatement.setString(2, message.getName());
        callableStatement.setString(3, message.getContent());
        callableStatement.setDate(4, message.getDate_created());
        callableStatement.setInt(5, message.getSender().getId());

        if (message.getUser_receiver() != null) {
            callableStatement.setInt(6, message.getUser_receiver().getId());
        } else {
            callableStatement.setNull(6, Types.INTEGER);
        }
        if (message.getGroup_receiver() != null) {
            callableStatement.setInt(7, message.getGroup_receiver().getId());
        } else {
            callableStatement.setNull(7, Types.INTEGER);
        } //Receiver group or receiver user
        if (message.getParent() != 0) {
            callableStatement.setInt(8, message.getParent());
        } else {
            callableStatement.setNull(8, Types.INTEGER);
        } //if message has parent
        if (message.getAttached_file() != null) {
            callableStatement.setInt(9, message.getAttached_file().getId());
        } else {
            callableStatement.setNull(9, Types.INTEGER);
        } //if is attached file

        callableStatement.executeQuery();
        conn.commit();
        callableStatement.close();
        System.out.println("UpdateMessage");
    }

    @Override
    public void deleteMessage(Message message) throws SQLException {
        CallableStatement callableStatement = conn.prepareCall(
                "call delete_zprava(?)"
        );
        callableStatement.setInt(1, message.getId());

        callableStatement.executeQuery();
        conn.commit();
        callableStatement.close();
        System.out.println("DeleteMessage");
    }
}
