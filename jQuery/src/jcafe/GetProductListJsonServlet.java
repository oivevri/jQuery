package jcafe;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

@WebServlet("/GetProductListJsonServlet")
public class GetProductListJsonServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public GetProductListJsonServlet() {
        super();
    }
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setCharacterEncoding("utf-8"); // 한글나오게하려고 이거랑
		response.setContentType("text/html;charset=UTF-8"); // 이거 추가
		
		ProductDAO dao = new ProductDAO();
		List<ProductVO> list = dao.getProductList();
		response.getWriter().append(
		JSONArray.fromObject(list).toString()); // 가져온 리스트컬렉션을 제이슨타입으로 바꿔서 그걸 화면에 출력
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
