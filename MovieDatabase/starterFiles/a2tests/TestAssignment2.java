import java.sql.*;
import java.util.ArrayList;

class TestAssignment2
{
    Connection conn;
    Assignment2 a2;

    TestAssignment2()
    {
        conn = null;
        try{
            a2 = new Assignment2();
        }catch(Exception s)
        {
            System.out.println("Error");
        }

    }
    /**
     *Parameters:
     *args[0] : dbname
     *args[1] : username for database
     *arts[2] : password for database
     */

    public static void main(String args[])
    {
        System.out.println("              JDBC PART            ");


        String dbname = args[0];
        String username = args[1];
        String password = "";
        String url = "jdbc:postgresql:" + dbname;

        TestAssignment2 ta2 = new TestAssignment2();

        //Test function connectDB
        ta2.a2.connectDB(url,username,password);

        //Test function findCoStars
        System.out.println("");
        System.out.println("Find co-stars of Pitt, Brad");
        ArrayList<String> res = ta2.a2.findCoStars("Pitt, Brad");
        for (String s : res) {
            System.err.println(s);
        }

        //Test function computeConnectivity
        System.out.println("");
        System.out.println("Compute the connectivity between Pitt, Brad  and Norton, Edward");
        System.err.println(ta2.a2.computeConnectivity("Pitt, Brad", "Norton, Edward"));
        ta2.a2.disconnectDB();
    }
}