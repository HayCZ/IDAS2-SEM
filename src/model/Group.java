package model;


import java.util.List;

/**
 *
 * @author Tomáš Vondra
 */
public class Group {

    private int id;
    private String name;
    private String description;
    private List<Subject> subjects;

    public Group(String name, String description, List<Subject> subjects){
        this(-1, name, description, subjects);
    }
    public Group(int id, String name, String description, List<Subject> subjects) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.subjects = subjects;

    }

    public int getId() {
        return id;
    }
    
    public void setId(int id){
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    public List<Subject> getSubject() {
        return subjects;
    }

    @Override
    public String toString() {
        return getName();
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setSubject(List<Subject> subjects) {
        this.subjects = subjects;
    }
    

}
