package model;

import controller.enums.USER_TYPE;
import data.OracleConnection;

import java.awt.image.BufferedImage;
import java.sql.Date;
import java.time.LocalDateTime;
import java.util.Objects;

public class User {

    private int id;
    private String firstName;
    private String password;
    private String lastName;
    private String email;
    private BufferedImage userAvatar;
    private final Date dateCreated;
    private final USER_TYPE userType;

    public User(String firstName, String lastName, String email, USER_TYPE type, String password, BufferedImage userAvatar) {
        this(-1, firstName, lastName, email,
                OracleConnection.parseDate(LocalDateTime.now().toString(), "yyyy-MM-dd'T'HH:mm:ss"),
                type, userAvatar);
        this.password = password;
        //Pokud vytvářím uživatele, ještě neznám jeho id, takže nastavím -1 a při insertu ho nastavím
        //Také automaticky vytvořím datum vytvoření
        //TODO Přemejšlím nad tím, že bych volal insert do databáze už tady
    }

    public User(int id, String firstName, String lastName, String email, Date dateCreated, USER_TYPE type, BufferedImage userAvatar) {
        this.id = id;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.dateCreated = dateCreated;
        this.userType = type;
        this.userAvatar = userAvatar;

        //Zde nemám nastavování hesla. Nezískávám password z databáze kvůli bezpečnosti
    }

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }

    public String getFirstName() {
        return firstName;
    }
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }

    public BufferedImage getUserAvatar() { return userAvatar;}
    public void setUserAvatar(BufferedImage userAvatar) { this.userAvatar = userAvatar;}

    public Date getDateCreated() {
        return dateCreated;
    }

    public USER_TYPE getUserType() {
        return userType;
    }


    @Override
    public int hashCode() {
        return Objects.hash(id, firstName, password, lastName, email, userAvatar, dateCreated, userType);
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final User other = (User) obj;
        return this.id == other.id;
    }

    @Override
    public String toString() {
        return "[" + getUserType() + "]" + "\t" + getFirstName() + " " + getLastName();
    }


}
