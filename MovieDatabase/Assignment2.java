import java.util.ArrayList;      // This is the main data structure.
import java.util.Collections;    // This import is for sorting ArrayLists

import java.util.Set;            // You may find these classes helpful,
import java.util.LinkedHashSet;  // but you aren't required to use them.
import java.io.*;
import java.sql.*;
import java.util.*; // for Queue 


// To run on CDF terminal: 
// javac Assignment2.java TestAssignment2.java
// java -cp /local/packages/jdbc-postgresql/postgresql-8.4-701.jdbc4.jar: TestAssignment2 //localhost:5432/csc343h-c4soonch c4soonch

public class Assignment2 {

    // A connection to the database
    private Connection connection;
    
    // String for queries 
    String queryString;
    
    // Prepared Statement
    PreparedStatement ps;
    PreparedStatement ps2; 

    // Resultset for the query
    ResultSet rs;
    ResultSet rs2;

    // Empty constructor. There is no need to modify this.
    public Assignment2() {}

   /**
    * Establishes a connection to be used for this session, assigning it to
    * the instance variable 'connection'.
    *
    * @param  url       the url to the database
    * @param  username  the username to connect to the database
    * @param  password  the password to connect to the database
    * @return           true if the connection is successful, false otherwise
    */
    public boolean connectDB(String url, String username, String password) 
    {
	try 
	{ 
	    connection = DriverManager.getConnection(url, username, password);
            //url = "jdbc:postgresql://localhost:5432/csc343h-c4soonch";
            //connection = DriverManager.getConnection(url, "c4soonch", ""); 
	    // Can assume will always call connectDB first 
	    queryString = "SET search_path TO imdb";
	    ps = connection.prepareStatement(queryString);
	    ps.execute(); // note: it is execute() for set seatch path 
        } 
	catch (SQLException e) 
	{
	    return false; 
        }
        if(connection!=null) 
	{
	    return true; 
        } 
	else 
	{
	    return false; 
        }
    }

   /**
    * Closes the database connection.
    *
    * @return true if the closing was successful, false otherwise
    */
    public boolean disconnectDB() 
    {
	try
	{
	    connection.close();
	    return true; 
	}
	catch ( SQLException e)
	{
	    return false; 
	}
    }

   /**
    * Returns a sorted list of the names of people who have acted in
    * at least one movie with the input person.
    *
    * Returns an empty list if the input person is not found.
    *
    * NOTES:
    * 1. The names should be taken directly from the database,
    *    without any formatting. (So the form is 'Pitt, Brad')
    * 2. Use Collections.sort() to sort the names in ascending
    *    alphabetical order.
    *
    * @param  person  the name of the person to find the co-stars for
    * @return         a sorted list of names of actors who worked with person
    */
    public ArrayList<String> findCoStars(String person) 
    {
	// ArrayList is a dynamic sized array that resizes
	// Initialize an ArrayList called coStars 
	ArrayList<String> coStars = new ArrayList<String>();
	// First, check if person is in the database: 
	// NOTE: We didn't cover this one in lecture, but you'll need to
	// execute a "SET search_path TO imdb" statement before
	// executing any queries. Use the following code snippet to do so:
	//
        try
        {
	    // Can assume will always call connectDB first, so don't need set path  
	    // Find the people_id of the person
	    //queryString = "select p.person_id as person_id from people p where p.name = ?"; 
	    queryString = "select p.person_id as person_id from people p where p.name=? "; 
	    ps = connection.prepareStatement(queryString);
	    // Insert that string into the PreparedStatement and execute it.	
	    ps.setString(1, person); // queryString in SQL is 1-based indexing 
	    rs = ps.executeQuery();   // Note: It is execute query for anything not set search path 
	    // If there is such a person in the database
	    if (rs.next()) 
	    {
	        // Get the person_id 
	        int personID = rs.getInt("person_id"); // note: Very important to maintain the type when getting and setting 
	        // Get the movies he plays in 
	        queryString = "select r.movie_id as movie_id from roles r where r.person_id=? "; 
	        ps = connection.prepareStatement(queryString);
	        // Insert that string into the PreparedStatement and execute it.
	        ps.setInt(1, personID); // set Int NOT set string if it is an int!  
	        rs = ps.executeQuery();   
	        while(rs.next())
	        { 
		    int movieID = rs.getInt("movie_id"); 
		    // Get all the actor names for this movie id and append to the list 
		    queryString = "select p.name as name from people p, roles r where p.person_id=r.person_id and r.movie_id=? and p.person_id!=? ";
	    	    ps2 = connection.prepareStatement(queryString);
	    	    ps2.setInt(1, movieID);
	    	    ps2.setInt(2, personID);
		    rs2 = ps2.executeQuery();   
		    // Add all names to list of names 
		    while(rs2.next())
		    {
			String coStarNames= rs2.getString("name"); 
			coStars.add(coStarNames); // append to ArrayList
		    }
		} 
	    }
	    // If no such person, return null 
	    else
	    {
		return null; 
	    }
	    Collections.sort(coStars); // sort the coStars ArrayList 
	}
	catch (SQLException e) 
	{
	    coStars = null;
	}
	// Return the list of names for the person 
	return coStars;
    }

   /**
    * Computes and returns the connectivity between two actors.
    *
    * Returns 0 if the two arguments are equal, regardless of whether they are
    * in the database or not.
    * Returns -1 if at least one of the input actors are not found.
    *
    * WARNING:
    * Do not assume the actors are connected; return -1 if they are not.
    * It's easy to write this method naively and get into an infinite loop
    * when the actors are not connected. Make sure you handle this!
    *
    * @param person1  the name of an actor
    * @param person2  the name of an actor
    * @return         the connectivity between the actors, or -1 if they
    *                 are not connected
    */
    public int computeConnectivity(String person1, String person2) 
    {
	if(person1.equals(person2))
	{
	    return 0; 
	}
	// Important variables to prevent infinite loop 
	int numActors = 0; // total number of actors in allPossibleNames 
	Set<String> allPossibleNames = new LinkedHashSet<String>();  // to keep track of all the possible names 
	Queue<String> qNamesLeft = new LinkedList<String>(); // queue for BFS 
	// First, check that both person are in the database and return -1 if one of them is not 
        try
        {
	    // Can assume will always call connectDB first, so don't need set path  
	    // Find the people_id of the person
	    queryString = "select r.person_id as person_id from roles r "; 
	    ps = connection.prepareStatement(queryString);
	    // Insert that string into the PreparedStatement and execute it.	
	    rs = ps.executeQuery();   // Note: It is execute query for anything not set search path 
	    // Go through all person_id and get it's respective name 
	    while (rs.next()) 
	    {
		int tempPersonID = rs.getInt("person_id");  
		// Now, get it's name which should be one result only 
		 	    // Can assume will always call connectDB first, so don't need set path  
		// Find the respective name 
		queryString = "select p.name as name from people p where p.person_id=? "; 
		ps2 = connection.prepareStatement(queryString);
		// Insert that integer into the PreparedStatement and execute it.	
		ps2.setInt(1, tempPersonID); // queryString in SQL is 1-based indexing 
		rs2 = ps2.executeQuery();   
		// Should only have 1 name here 		
		while(rs2.next())
		{
		    String tempName = rs2.getString("name"); 
		    if(allPossibleNames.contains(tempName))
		    {
			// do nothing 
		    }
		    // Only add if needed to add 
		    else
		    {
			allPossibleNames.add(tempName); // add this to the list of possible people 
			numActors++; // add 1 to all possible actors
		    }
		}
	    }
	    // Done storing all possible actors into database 		
	    // Check if the people exists in the list of roles 
	    if(allPossibleNames.contains(person1) && allPossibleNames.contains(person2))
	    {
		allPossibleNames.remove(person1); // remove the starting node 
		// don't remove ending node 

		// Breadth First Search but use LinkedHashSet to make sure don't access same person twice 
		// Note: Need use coStars here 
		ArrayList<String> res = findCoStars(person1);
		int currDepth = 0; // set number of people in current depth to be 0 
		int level = 0; // start with depth of 0 to not be anything 
		for (String s : res) 
		{ 
		    // Add each actor to Array, , only remove from allPossibleNames when adding it's neighbour 
		    if(allPossibleNames.contains(s))
		    {
			// only add to queue if inside allPossibleNames 
			qNamesLeft.add(s); // add into queue 
			currDepth++; // number of elements in queue for level 1 
			// Remove from all possible names 
			allPossibleNames.remove(s); 
		    }
        	}
		// Here, done, adding first level people, now need check next level 
		level++; // level = 1
		int currDepthNew = 0;  // next level depth 
		int iterationNum = 0;  // number of nodes popped off the queue since new level 
		// Keep doing this until queue is empty 
		while(true)
		{
	  	    // if no more element, means no path exists
		    if(qNamesLeft.peek() == null)
		    {
		        return -1; // no path exists 
		    }

		    if(iterationNum >= currDepth)
		    {
			level++; // add the level 
			currDepth = currDepthNew; // set the new level 
			iterationNum = 0; // reset iterationNum 
			currDepthNew = 0; // reset currDepthNew 
		    } 
		    // Otherwise, get next element 
		    String nextNode = qNamesLeft.poll(); // retrieves and removes head of this queue
		    if(nextNode.equals(person2))
		    {
		        return level; // return the depth cause found; 
		    } 
		    // get the list of neighbours for this node 
		    ArrayList<String> res2 = findCoStars(nextNode);
		    // Loop through all child 
		    for (String s : res2) 
		    { 
		        // Only append to queue if not already appended 
			if(allPossibleNames.contains(s))
			{
			    // only add to queue if inside allPossibleNames 
			    qNamesLeft.add(s); // add into queue 
			    currDepthNew++; // number of elements in current level 
			    // Remove from all possible names 
			    allPossibleNames.remove(s); 
			}
		    } 
		    iterationNum++; // increase number for next node
		} 
	    }
	    // One of the person does not exist in the database 
	    else
	    {
		return -1; 
	    }
	}
	catch (SQLException e) 
	{
	    return -1; 
	}
    }
}
