package files;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet({"/addmaterials"})
@MultipartConfig
public class addmaterials extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String UPLOAD_DIR = "uploads1";

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");
		if ("Upload".equals(action)) {
			Part filePart = request.getPart("file");
			String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
			String var10002 = this.getServletContext().getRealPath("");
			File uploads = new File(var10002 + File.separator + "uploads1");
			if (!uploads.exists()) {
				uploads.mkdirs();
			}

			File file = new File(uploads, fileName);
			filePart.write(file.getAbsolutePath());
			response.sendRedirect("materials.jsp");
		}

	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");
		String var10002;
		if ("List".equals(action)) {
			var10002 = this.getServletContext().getRealPath("");
			File uploads = new File(var10002 + File.separator + "uploads1");
			File[] files = uploads.listFiles();
			request.setAttribute("files", files);
			request.getRequestDispatcher("results.jsp").forward(request, response);
		} else {
			String fileName;
			File file;
			if ("Download".equals(action)) {
				fileName = request.getParameter("fileName");
				var10002 = this.getServletContext().getRealPath("");
				file = new File(var10002 + File.separator + "uploads1" + File.separator + fileName);
				if (file.exists()) {
					response.setHeader("Content-Disposition", "attachment;filename=" + file.getName());
					Files.copy(file.toPath(), response.getOutputStream());
				}
			} else if ("Delete".equals(action)) {
				fileName = request.getParameter("fileName");
				var10002 = this.getServletContext().getRealPath("");
				file = new File(var10002 + File.separator + "uploads1" + File.separator + fileName);
				if (file.exists()) {
					file.delete();
				}

				response.sendRedirect("materials.jsp");
			}
		}

	}
}