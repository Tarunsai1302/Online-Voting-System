
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/dd")
public class dd extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String state = request.getParameter("state");
        String parliament = request.getParameter("parliament");
        ArrayList<String> list = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/scet", "root", "manager");

            PreparedStatement pst = null;
            if (state == null || state.isEmpty()) {
                // Fetch all unique states
                pst = conn.prepareStatement("SELECT DISTINCT state FROM assemblyconstituencies");
            } else if (parliament == null || parliament.isEmpty()) {
                // Fetch parliamentary constituencies for the selected state
                pst = conn.prepareStatement("SELECT DISTINCT constituencies FROM assemblyconstituencies WHERE state = ?");
                pst.setString(1, state);
            } else{
                // Fetch assembly constituencies for the selected parliamentary constituency
                pst = conn.prepareStatement("SELECT * FROM parlimentaryconstituencies where state="+"AndhraPradesh"+";");
                pst.setString(1, parliament);
            }

            ResultSet rs = pst.executeQuery();
            //StringBuilder result = new StringBuilder();
            while (rs.next()) {
                //if (result.length() > 0) result.append("\n");  // Add newline separator
                //result.append(rs.getString(1));  // Add state or constituency value
            	 list.add(rs.getString(1));
            }
            out.write("[\"" + String.join("\",\"", list) + "\"]");
            rs.close();
            pst.close();
            conn.close();

            //System.out.println("Servlet Output: " + result.toString());  // Debugging statement to verify output
            
            //out.write(result.toString());  // Send plain text response
        } catch (Exception e) {
            e.printStackTrace();
        }
        

    }
}
