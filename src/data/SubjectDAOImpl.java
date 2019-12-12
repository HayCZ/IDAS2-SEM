package data;

import java.sql.*;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import model.*;

/**
 *
 * @author Tomáš Vondra
 */
public class SubjectDAOImpl implements SubjectDAO {

    private Connection conn;

    public SubjectDAOImpl() {
        try {
            conn = OracleConnection.getConnection();
        } catch (SQLException ex) {
            Logger.getLogger(SubjectDAOImpl.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public Collection<Subject> getAllSubjects() {
        Collection<Subject> collection = new ArrayList<>();
        try {

            Statement statement = conn.createStatement();
            ResultSet rs = statement.executeQuery(
                    "SELECT * FROM PREDMETY");

            while (rs.next()) {
                Subject predmet = getPredmet(rs);
                collection.add(predmet);
            }

            return collection;
        } catch (SQLException ex) {
            Logger.getLogger(UserDAOImpl.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    @Override
    public Collection<Subject> getSubjectsForField(Field obor) {
        Collection<Subject> collection = new ArrayList<>();
        try {
            PreparedStatement pstm = conn.prepareStatement(
                    "SELECT * FROM OBOR_PREDMET op\n"
                    + "JOIN PREDMETY p ON p.id_predmet = op.predmet_id_predmet\n"
                    + "WHERE op.studijni_obor_id_obor = ?"
            );
            pstm.setInt(1, obor.getId());

            ResultSet rs = pstm.executeQuery();
            while (rs.next()) {
                Subject p = getPredmet(rs);
                collection.add(p);
            }
            return collection;
        } catch (SQLException ex) {
            Logger.getLogger(SubjectDAOImpl.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    private Subject getPredmet(ResultSet rs) throws SQLException {
        Subject predmet = new Subject(
                rs.getInt("id_predmet"),
                rs.getString("nazev"),
                rs.getString("popis")
        );

        return predmet;
    }

    @Override
    public void insertSubject(Subject subject) throws SQLException {
        CallableStatement callableStatement = conn.prepareCall(
                "call insert_predmet(?,?)"
        );
        callableStatement.setString(1, subject.getName());
        callableStatement.setString(2, subject.getDescription());
        callableStatement.execute();
        conn.commit();
        System.out.println("Subject created.");
    }

    @Override
    public void insertSubjectsToField(List<Subject> predmety, Field obor) {
        try {

            for (int i = 0; i < predmety.size(); i++) {
                PreparedStatement pstm = conn.prepareStatement(
                        "INSERT INTO OBOR_PREDMET(studijni_obor_id_obor, predmet_id_predmet)"
                        + "VALUES (?, ?)"
                );
                pstm.setInt(1, obor.getId());
                pstm.setInt(2, predmety.get(i).getId());
                
                
                pstm.executeUpdate();
                conn.commit();
                System.out.println("Subject added to field");
            }
        } catch (SQLException ex) {
            Logger.getLogger(SubjectDAOImpl.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public void insertSubjectsToField(Subject subject, Field fieldOfStudy) throws SQLException {
        CallableStatement callableStatement = conn.prepareCall(
                "call insert_obor_predmet(?,?)"
        );
        callableStatement.setInt(1, fieldOfStudy.getId());
        callableStatement.setInt(2, subject.getId());
        callableStatement.execute();
        conn.commit();
        System.out.println("Subject added to Field");
    }

    @Override
    public void insertTeacherToSubject(Subject subject, User teacher) throws SQLException {
        CallableStatement callableStatement = conn.prepareCall(
                "call insert_predmet_ucitel(?,?)"
        );
        callableStatement.setInt(1, teacher.getId());
        callableStatement.setInt(2, subject.getId());
        callableStatement.execute();
        conn.commit();
        System.out.println("Teacher added to subject");
    }

    @Override
    public void insertSubjectToGroup(Subject subject, Group group) throws SQLException {
        CallableStatement callableStatement = conn.prepareCall(
                "call   insert_skupiny_predmety(?,?)"
        );
        callableStatement.setInt(1, group.getId());
        callableStatement.setInt(2, subject.getId());
        callableStatement.execute();
        conn.commit();
        System.out.println("Subject added to group.");
    }

    @Override
    public void updateSubject(Subject subject) throws SQLException {
        CallableStatement callableStatement = conn.prepareCall(
                "call update_predmet(?,?,?)"
        );
        callableStatement.setInt(1, subject.getId());
        callableStatement.setString(2, subject.getName());
        callableStatement.setString(3, subject.getDescription());
        callableStatement.execute();
        conn.commit();
        System.out.println("Subject updated!");
    }

    @Override
    public void removeSubjectsFromField(List<Subject> predmety, Field obor) {
        try {

            for (int i = 0; i < predmety.size(); i++) {
                PreparedStatement pstm = conn.prepareStatement(
                        "DELETE FROM OBOR_PREDMET "
                                + "WHERE predmet_id_predmet = ? AND "
                                + "studijni_obor_id_obor = ?"
                );
                pstm.setInt(1, predmety.get(i).getId());
                pstm.setInt(2, obor.getId());
                pstm.setInt(1, predmety.get(i).getId());
                
                
                pstm.executeUpdate();
                conn.commit();
                System.out.println("Subject deleted from field");
            }
        } catch (SQLException ex) {
            Logger.getLogger(SubjectDAOImpl.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public void removeSubjectsFromField(Subject subject, Field fieldOfStudy) throws SQLException {
        CallableStatement callableStatement = conn.prepareCall(
                "call delete_obor_predmet(?,?)"
        );
        callableStatement.setInt(1, subject.getId());
        callableStatement.setInt(2, fieldOfStudy.getId());
        callableStatement.execute();
        conn.commit();
        System.out.println("Subject removed from field of study.");
    }

    @Override
    public void removeTeacherFromSubject(Subject subject, User teacher) throws SQLException {
        CallableStatement callableStatement = conn.prepareCall(
                "call delete_ucitele_predmety(?,?)"
        );
        callableStatement.setInt(1, subject.getId());
        callableStatement.setInt(2, teacher.getId());
        callableStatement.execute();
        conn.commit();
        System.out.println("Subject removed from field of study.");
    }

    @Override
    public void removeSubjectFromGroup(Subject subject, Group group) throws SQLException {
        CallableStatement callableStatement = conn.prepareCall(
                "call delete_skupiny_predmety(?,?)"
        );
        callableStatement.setInt(1, subject.getId());
        callableStatement.setInt(2, group.getId());
        callableStatement.execute();
        conn.commit();
        System.out.println("Subject removed from field of study.");
    }

    @Override
    public void removeSubject(Subject subject) throws SQLException{
        CallableStatement callableStatement = conn.prepareCall(
                "call delete_predmet(?)"
        );
        callableStatement.setInt(1, subject.getId());
        callableStatement.execute();
        conn.commit();
        System.out.println("Subject deleted!");
    }
}
