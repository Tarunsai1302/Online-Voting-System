import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/StateConstituencyServlet")
public class StateConstituencyServlet extends HttpServlet {
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

            if (state == null && parliament == null) {
                // Fetch all unique states
                System.out.println("Fetching States");

                pst = conn.prepareStatement("SELECT DISTINCT state FROM assemblyconstituencies");
                System.out.println("Fetching States");
            } 
            else if (state != null && (parliament == null || parliament.isEmpty())) {
                // Fetch parliamentary constituencies for the selected state
                System.out.println("Fetching Parliamentary Constituencies for state: " + state);

                pst = conn.prepareStatement("SELECT DISTINCT parliamentary_constituency FROM assemblyconstituencies WHERE state = ?");
                pst.setString(1, state);
                System.out.println("Fetching Parliamentary Constituencies for state: " + state);
            } 
            else if (state != null && parliament != null) {
                // Fetch assembly constituencies for the selected parliamentary constituency
                System.out.println("Fetching Assembly Constituencies for parliament: " + parliament);

                pst = conn.prepareStatement("SELECT assembly_constituency FROM assemblyconstituencies WHERE parliamentary_constituency=?");
                pst.setString(1, parliament);
                System.out.println("Fetching Assembly Constituencies for parliament: " + parliament);
            }

            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                list.add(rs.getString(1)); // Fetch only the first column of the result
            }

            // Convert list to JSON and return it
            out.write("[\"" + String.join("\",\"", list) + "\"]");

            rs.close();
            pst.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}