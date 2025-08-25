package com.db.students;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet({"/removeStudent"})
public class RemoveStudentServlet extends HttpServlet {
	private static final String DB_URL = "jdbc:oracle:thin:@localhost:1521:orcl";
	private static final String DB_USER = "system";
	private static final String DB_PASSWORD = "Manvith7226";

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {
		response.setContentType("text/html");
		PrintWriter pw = response.getWriter();
		String regNo = request.getParameter("regNoRemove");
		String year = request.getParameter("year");
		String section = request.getParameter("section");
		Connection con = null;
		PreparedStatement pst1 = null;
		PreparedStatement pst2 = null;
		String message = "";

		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl", "system", "Manvith7226");
			con.setAutoCommit(false);
			String studentsTableName = "students_" + year + section.toLowerCase();
			String attendanceTableName = "students_attendance_" + year + section.toLowerCase();
			String query1 = "DELETE FROM " + attendanceTableName + " WHERE reg_no = ?";
			String query2 = "DELETE FROM " + studentsTableName + " WHERE reg_no = ?";
			pst1 = con.prepareStatement(query1);
			pst1.setString(1, regNo);
			int rowsDeletedFromAttendance = pst1.executeUpdate();
			pst2 = con.prepareStatement(query2);
			pst2.setString(1, regNo);
			int rowsDeletedFromStudents = pst2.executeUpdate();
			if (rowsDeletedFromAttendance > 0 && rowsDeletedFromStudents > 0) {
				con.commit();
				message = "Student removed successfully!";
			} else {
				con.rollback();
				message = "Failed to remove student.";
			}
		} catch (SQLException | ClassNotFoundException var27) {
			var27.printStackTrace();

			try {
				if (con != null) {
					con.rollback();
				}
			} catch (SQLException var26) {
				var26.printStackTrace();
			}

			message = "An error occurred: " + var27.getMessage();
		} finally {
			try {
				if (pst1 != null) {
					pst1.close();
				}

				if (pst2 != null) {
					pst2.close();
				}

				if (con != null) {
					con.close();
				}
			} catch (SQLException var25) {
				var25.printStackTrace();
			}

		}

		request.setAttribute("message", message);
		RequestDispatcher dispatcher = request.getRequestDispatcher("manageStudents.jsp");
		dispatcher.forward(request, response);
	}
}