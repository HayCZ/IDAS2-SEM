package data;

import model.FoodMenu;
import model.Product;

import java.sql.*;
import java.util.ArrayList;
import java.util.Collection;
import java.util.logging.Level;
import java.util.logging.Logger;

public class FoodMenuDAOImpl implements FoodMenuDAO {

    private Connection conn;

    public FoodMenuDAOImpl() {
        try {
            conn = OracleConnection.getConnection();
        } catch (SQLException ex) {
            Logger.getLogger(UserDAOImpl.class.getName()).log(Level.SEVERE, null, ex);
        }
    }


    @Override
    public void createFoodMenu(FoodMenu menu) throws SQLException {
        PreparedStatement preparedStatement = conn.prepareStatement(
                "INSERT INTO JIDELNI_LISTKY(ID_LISTKU, DATUM) "
                        + "VALUES (?, ?)"
        );
        preparedStatement.setInt(1, menu.getId());
        preparedStatement.setDate(2, menu.getDate());

        preparedStatement.executeUpdate();
        conn.commit();
        preparedStatement.close();
        System.out.println("CreateFoodMenu");
    }

    @Override
    public void addProductToFoodMenu(Product product, FoodMenu menu) throws SQLException {
        PreparedStatement preparedStatement = conn.prepareStatement(
                "INSERT INTO LISTEK_PRODUKT(ID_PRODUKT, ID_LISTEK) "
                        + "VALUES (?, ?)"
        );
        preparedStatement.setInt(1, product.getId());
        preparedStatement.setInt(2, menu.getId());

        preparedStatement.executeUpdate();
        preparedStatement.close();
        conn.commit();
        System.out.println("addProductToFoodMenu");
    }

    @Override
    public void updateFoodMenu(FoodMenu menu) throws SQLException {
        PreparedStatement preparedStatement = conn.prepareStatement(
                "UPDATE JIDELNI_LISTKY SET DATUM = ? where ID_LISTKU = ?"
        );
        preparedStatement.setDate(1, menu.getDate());
        preparedStatement.setInt(2, menu.getId());

        preparedStatement.executeUpdate();
        conn.commit();
        preparedStatement.close();
        System.out.println("UpdateFoodMenu");
    }

    @Override
    public void deleteFoodMenu(FoodMenu menu) throws SQLException {
        PreparedStatement preparedStatement = conn.prepareStatement(
                "DELETE FROM JIDELNI_LISTKY WHERE ID_LISTKU = ?"
        );
        preparedStatement.setInt(1, menu.getId());

        preparedStatement.executeQuery();
        preparedStatement.close();
        conn.commit();
        System.out.println("DeleteFoodMenu");
    }

    @Override
    public void deleteProductFromFoodMenu(Product product, FoodMenu menu) throws SQLException {
        PreparedStatement preparedStatement = conn.prepareStatement(
                "DELETE FROM LISTEK_PRODUKT WHERE ID_PRODUKT = ? AND ID_LISTEK = ?"
        );
        preparedStatement.setInt(1, product.getId());
        preparedStatement.setInt(2, menu.getId());

        preparedStatement.executeQuery();
        preparedStatement.close();
        conn.commit();
        System.out.println("deleteProductFromFoodMenu");
    }

    @Override
    public FoodMenu getFoodMenuByDate(Date date) throws SQLException {
        PreparedStatement preparedStatement = conn.prepareStatement(
                "SELECT * FROM JIDELNI_LISTKY WHERE to_char(DATUM, 'yyyy-mm-dd') = to_char(?, 'yyyy-mm-dd') ");
        preparedStatement.setDate(1, date);

        ResultSet rs = preparedStatement.executeQuery();
        FoodMenu foodMenu = null;
        if (rs.next())
            foodMenu = getFoodMenu(rs);

        preparedStatement.close();
        System.out.println("GetFoodMenuByDate");
        return foodMenu;
    }

    @Override
    public Collection<FoodMenu> getAllFoodMenu() throws SQLException {
        Collection<FoodMenu> collection = new ArrayList<>();

        Statement statement = conn.createStatement();
        ResultSet rs = statement.executeQuery(
                "SELECT * FROM JIDELNI_LISTKY");
        while (rs.next()) {
            FoodMenu foodMenu = getFoodMenu(rs);
            collection.add(foodMenu);
        }
        statement.close();
        System.out.println("GetAllFoodMenu");
        return collection;
    }

    /**
     * Parse ResultSet to FoodMenu
     *
     * @param rs
     * @return produkt
     * @throws SQLException
     */
    private FoodMenu getFoodMenu(ResultSet rs) throws SQLException {
        FoodMenu foodMenu = new FoodMenu(
                rs.getInt("id_listku"),
                rs.getDate("datum")
        );
        return foodMenu;
    }
}
