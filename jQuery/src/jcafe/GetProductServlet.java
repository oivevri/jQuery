package jcafe;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

@WebServlet("/GetProductServlet")
public class GetProductServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public GetProductServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 요구할때는(request) 필요없는데 결과값 나올때는(response) 한국어가 제대로 나와야하니까 
		response.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=UTF-8");
		
		String itemNo = request.getParameter("itemNo");
		ProductDAO dao = new ProductDAO();
		ProductVO vo = dao.getProduct(itemNo); // itemNo로 찾은 결과값을 vo에 담음
		response.getWriter().append(JSONArray.fromObject(vo).toString());
		// 방금 vo로부터 받은 배열을 화면에 출력되도록
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}